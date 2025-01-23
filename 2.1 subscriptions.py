import sqlite3
import random
import datetime

def create_database():
    # Connecting to the database (or creating it if it doesn't exist)
    conn = sqlite3.connect('subscriptions.db')
    cursor = conn.cursor()

    # Creating the table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS subscriptions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            segment TEXT,
            subscription_start DATE,
            subscription_end DATE
        )
    ''')

    # Inserting 300 rows of data
    for _ in range(300):
        # Generating a random date between 12/01/2016 and 03/30/2017
        start_date = datetime.date(2016, 12, 1) + datetime.timedelta(days=random.randint(0, 120))
        # Generating an end date at least 30 days after the start
        end_date = start_date + datetime.timedelta(days=random.randint(30, 120))
        # Choosing randomly between the two segments
        segment = random.choice(['Seguimento 1', 'Seguimento 2'])
        cursor.execute("INSERT INTO subscriptions (segment, subscription_start, subscription_end) VALUES (?, ?, ?)",
                       (segment, start_date, end_date))

    conn.commit()
    conn.close()

if __name__ == "__main__":
    create_database()