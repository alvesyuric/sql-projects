-- Geração dinâmica de meses (se não houver tabela de datas)
WITH meses AS (
  -- Definindo os meses e seus respectivos intervalos. 
  -- "primeiro_dia" é o início do mês, e "ultimo_dia" é o fim do mês.
  SELECT DATE('2024-09-01') AS primeiro_dia, DATE('2024-09-30') AS ultimo_dia
  UNION ALL
  SELECT DATE('2024-10-01'), DATE('2024-10-31')
  UNION ALL
  SELECT DATE('2024-11-01'), DATE('2024-11-30')
),
status AS (
  -- Calculando o status das assinaturas para cada mês, 
  -- verificando se a assinatura está ativa e se foi cancelada dentro do mês.
  SELECT 
    a.id,  -- ID da assinatura
    m.primeiro_dia AS mes,  -- O mês que estamos analisando
    -- Verifica se a assinatura está ativa no mês
    CASE
      WHEN (a.inicio_assinatura < m.primeiro_dia)  -- A assinatura começou antes do primeiro dia do mês
        AND (a.fim_assinatura > m.primeiro_dia OR a.fim_assinatura IS NULL) -- A assinatura ainda está em vigor ou não tem data de fim
      THEN 1  -- Assinatura está ativa
      ELSE 0   -- Assinatura não está ativa
    END AS esta_ativo,
    -- Verifica se a assinatura foi cancelada dentro do mês
    CASE 
      WHEN a.fim_assinatura BETWEEN m.primeiro_dia AND m.ultimo_dia  -- Fim da assinatura está entre o primeiro e o último dia do mês
      THEN 1  -- A assinatura foi cancelada
      ELSE 0   -- A assinatura não foi cancelada
    END AS foi_cancelado
  FROM assinaturas a
  -- Realiza um JOIN entre as assinaturas e os meses para verificar as assinaturas dentro do intervalo de cada mês.
  INNER JOIN meses m
    -- Condição de join: a assinatura deve ter iniciado antes ou no mês analisado.
    ON a.inicio_assinatura <= m.ultimo_dia -- Apenas assinaturas relevantes para o mês
),
resumo_status AS (
  -- Agrega os dados do status (ativo ou cancelado) por mês.
  SELECT
    mes,  -- O mês
    SUM(esta_ativo) AS ativos,  -- Soma os ativos para o mês (quantas assinaturas estavam ativas)
    SUM(foi_cancelado) AS cancelados  -- Soma os cancelados para o mês (quantas assinaturas foram canceladas)
  FROM status
  GROUP BY mes  -- Agrupa os dados por mês
)
-- Calcula a taxa de churn (cancelamento) para cada mês.
SELECT 
  mes,  -- O mês
  -- Calcula a taxa de churn: cancelados / ativos. Se não houver assinaturas ativas, retorna 0.
  CASE 
    WHEN ativos > 0 THEN (1.0 * cancelados / ativos)  -- Calcula a taxa de churn apenas quando há assinaturas ativas
    ELSE 0  -- Caso contrário, define a taxa de churn como 0
  END AS taxa_de_churn
FROM resumo_status;
