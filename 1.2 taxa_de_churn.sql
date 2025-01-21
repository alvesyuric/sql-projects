-- Geração dinâmica de meses (se não houver tabela de datas)
WITH meses AS (
  SELECT DATE('2024-09-01') AS primeiro_dia, DATE('2024-09-30') AS ultimo_dia
  UNION ALL
  SELECT DATE('2024-10-01'), DATE('2024-10-31')
  UNION ALL
  SELECT DATE('2024-11-01'), DATE('2024-11-30')
),
status AS (
  SELECT 
    a.id,
    m.primeiro_dia AS mes,
    CASE
      WHEN (a.inicio_assinatura < m.primeiro_dia)
        AND (a.fim_assinatura > m.primeiro_dia OR a.fim_assinatura IS NULL) 
      THEN 1 ELSE 0 
    END AS esta_ativo,
    CASE 
      WHEN a.fim_assinatura BETWEEN m.primeiro_dia AND m.ultimo_dia 
      THEN 1 ELSE 0 
    END AS foi_cancelado
  FROM assinaturas a
  INNER JOIN meses m
    ON a.inicio_assinatura <= m.ultimo_dia -- Apenas assinaturas relevantes para o mês
),
resumo_status AS (
  SELECT
    mes,
    SUM(esta_ativo) AS ativos,
    SUM(foi_cancelado) AS cancelados
  FROM status
  GROUP BY mes
)
-- Calcula a taxa de churn
SELECT 
  mes,
  CASE 
    WHEN ativos > 0 THEN (1.0 * cancelados / ativos)
    ELSE 0
  END AS taxa_de_churn
FROM resumo_status;
