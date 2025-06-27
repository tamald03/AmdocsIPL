import mysql.connector
from mysql.connector import Error
from abc import ABC, abstractmethod
import hashlib
from prettytable import PrettyTable

# ========== CONFIG ==========
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "abc@123",
}
DB_NAME = "amdocs_ipl"

# ========== CONNECTION SETUP ==========
def get_connection(use_db=True):
    conn = mysql.connector.connect(**DB_CONFIG)
    if use_db:
        conn.database = DB_NAME
    return conn

# ========== DB + TABLE SETUP ==========
def initialize_database():
    conn = get_connection(use_db=False)
    cursor = conn.cursor()
    cursor.execute(f"CREATE DATABASE IF NOT EXISTS {DB_NAME}")
    conn.database = DB_NAME

    # Users
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS users (
        user_id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(50) NOT NULL UNIQUE,
        password_hash VARCHAR(100) NOT NULL,
        role ENUM('manager', 'team') NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )""")

    # Teams
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS team (
        team_id INT AUTO_INCREMENT PRIMARY KEY,
        team_name VARCHAR(100) NOT NULL UNIQUE,
        team_owner VARCHAR(100) NOT NULL,
        budget DECIMAL(10,2) DEFAULT 100000000.00,
        ground_id VARCHAR(10)
    )""")

    # Players
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS player (
        player_id INT AUTO_INCREMENT PRIMARY KEY,
        player_name VARCHAR(100) NOT NULL,
        player_age INT,
        player_country VARCHAR(50),
        player_role ENUM('Batsman', 'Bowler', 'All-rounder', 'Wicket-keeper') NOT NULL,
        base_price DECIMAL(10,2) NOT NULL,
        is_sold BOOLEAN DEFAULT FALSE,
        player_sell_price INT,
        captain BOOLEAN DEFAULT FALSE,
        team_id INT,
        FOREIGN KEY (team_id) REFERENCES team(team_id) ON DELETE SET NULL
    )""")

    # Coaches
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS coach (
        coach_id INT AUTO_INCREMENT PRIMARY KEY,
        team_id INT,
        coach_name VARCHAR(100) NOT NULL,
        coach_role VARCHAR(100),
        coach_age INT,
        coach_country VARCHAR(100),
        coach_work_exp INT,
        FOREIGN KEY (team_id) REFERENCES team(team_id) ON DELETE SET NULL
    )""")

    # Umpires
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS umpire (
        umpire_id INT AUTO_INCREMENT PRIMARY KEY,
        umpire_name VARCHAR(100) NOT NULL,
        umpire_country VARCHAR(50),
        umpire_work_exp INT
    )""")

    # Grounds
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS ground (
        ground_id INT AUTO_INCREMENT PRIMARY KEY,
        ground_name VARCHAR(100) NOT NULL,
        ground_location VARCHAR(100)
    )""")

    # Match schedule
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS match_schedule (
        match_id INT AUTO_INCREMENT PRIMARY KEY,
        team1_id INT,
        team2_id INT,
        ground_id INT,
        umpire1_id INT,
        umpire2_id INT,
        match_date DATE,
        match_status ENUM('Completed', 'Upcoming', 'Cancelled', 'On-going') NOT NULL,
        FOREIGN KEY (team1_id) REFERENCES team(team_id),
        FOREIGN KEY (team2_id) REFERENCES team(team_id),
        FOREIGN KEY (ground_id) REFERENCES ground(ground_id),
        FOREIGN KEY (umpire1_id) REFERENCES umpire(umpire_id),
        FOREIGN KEY (umpire2_id) REFERENCES umpire(umpire_id)
    )""")

    conn.commit()
    cursor.close()
    conn.close()

# ========== DUMMY DATA ==========
def insert_dummy_data():
    conn = get_connection()
    cursor = conn.cursor()

    # Insert teams if not exists
    cursor.execute("SELECT COUNT(*) FROM team")
    if cursor.fetchone()[0] == 0:
        cursor.execute("INSERT INTO team (team_name, team_owner, ground_id) VALUES ('Mumbai Indians', 'Ambani', 'W001')")
        cursor.execute("INSERT INTO team (team_name, team_owner, ground_id) VALUES ('RCB', 'United Spirits', 'W002')")

    # Insert players
    cursor.execute("SELECT COUNT(*) FROM player")
    if cursor.fetchone()[0] == 0:
        cursor.execute("""
        INSERT INTO player (player_name, player_age, player_country, player_role, base_price, player_sell_price, team_id, captain)
        VALUES 
        ('Rohit Sharma', 36, 'India', 'Batsman', 2000000, 2500000, 1, TRUE),
        ('Virat Kohli', 35, 'India', 'Batsman', 2200000, 2700000, 2, TRUE)
        """)

    # Insert coaches
    cursor.execute("SELECT COUNT(*) FROM coach")
    if cursor.fetchone()[0] == 0:
        cursor.execute("""
        INSERT INTO coach (team_id, coach_name, coach_role, coach_age, coach_country, coach_work_exp)
        VALUES 
        (1, 'Mahela Jayawardene', 'Head Coach', 46, 'Sri Lanka', 8),
        (2, 'Sanjay Bangar', 'Assistant Coach', 50, 'India', 6)
        """)

    # Insert users
    cursor.execute("SELECT COUNT(*) FROM users")
    if cursor.fetchone()[0] == 0:
        cursor.execute("""
        INSERT INTO users (username, password_hash, role)
        VALUES 
        ('admin', %s, 'manager'),
        ('teamuser', %s, 'team')
        """, (hash_password("admin123"), hash_password("team123")))

    conn.commit()
    cursor.close()
    conn.close()

# ========== HELPER ==========
def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

# ========== USER ROLES ==========
class User(ABC):
    def __init__(self, username):
        self.username = username

    @abstractmethod
    def menu(self):
        pass

class Manager(User):
    def menu(self):
        while True:
            print("\n--- Manager Menu ---")
            print("1. View All Teams")
            print("2. View All Players by Team")
            print("3. Count Players by Team")
            print("4. Assign Player to Team")
            print("5. Logout")
            choice = input("Enter choice: ")

            if choice == "1":
                self.view_teams()
            elif choice == "2":
                self.view_players_by_team()
            elif choice == "3":
                self.count_players_by_team()
            elif choice == "4":
                self.assign_player()
            elif choice == "5":
                break
            else:
                print("Invalid option.")

    def view_teams(self):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM team")
        rows = cursor.fetchall()
        table = PrettyTable(["ID", "Name", "Owner", "Budget", "Ground ID"])
        for row in rows:
            table.add_row(row)
        print(table)
        cursor.close()
        conn.close()

    def view_players_by_team(self):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT t.team_name, p.player_name, p.player_role, p.player_country, p.base_price, p.is_sold, p.captain
            FROM player p
            JOIN team t ON p.team_id = t.team_id
        """)
        rows = cursor.fetchall()
        table = PrettyTable(["Team", "Name", "Role", "Country", "Base Price", "Sold?", "Captain"])
        for row in rows:
            table.add_row(row)
        print(table)
        cursor.close()
        conn.close()

    def count_players_by_team(self):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT t.team_name, COUNT(p.player_id)
            FROM team t
            LEFT JOIN player p ON t.team_id = p.team_id
            GROUP BY t.team_name
        """)
        rows = cursor.fetchall()
        table = PrettyTable(["Team", "Total Players"])
        for row in rows:
            table.add_row(row)
        print(table)
        cursor.close()
        conn.close()

    def assign_player(self):
        try:
            player_id = int(input("Enter Player ID: "))
            new_team_id = int(input("Enter New Team ID: "))
            conn = get_connection()
            cursor = conn.cursor()
            cursor.execute("UPDATE player SET team_id = %s WHERE player_id = %s", (new_team_id, player_id))
            conn.commit()
            print("Player reassigned.")
            cursor.close()
            conn.close()
        except Exception as e:
            print("Error:", e)

class TeamUser(User):
    def menu(self):
        while True:
            print("\n--- Team Menu ---")
            print("1. View My Players")
            print("2. View My Coach")
            print("3. Logout")
            choice = input("Enter choice: ")

            if choice == "1":
                self.view_my_players()
            elif choice == "2":
                self.view_my_coach()
            elif choice == "3":
                break
            else:
                print("Invalid option.")

    def view_my_players(self):
        team_id = int(input("Enter your Team ID: "))
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT player_id, player_name, player_role, player_country FROM player WHERE team_id = %s", (team_id,))
        rows = cursor.fetchall()
        table = PrettyTable(["ID", "Name", "Role", "Country"])
        for row in rows:
            table.add_row(row)
        print(table)
        cursor.close()
        conn.close()

    def view_my_coach(self):
        team_id = int(input("Enter your Team ID: "))
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT coach_name, coach_role, coach_age, coach_country FROM coach WHERE team_id = %s", (team_id,))
        rows = cursor.fetchall()
        table = PrettyTable(["Name", "Role", "Age", "Country"])
        for row in rows:
            table.add_row(row)
        print(table)
        cursor.close()
        conn.close()

# ========== AUTH ==========
def login():
    username = input("Username: ")
    password = input("Password: ")
    hashed = hash_password(password)
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT role FROM users WHERE username = %s AND password_hash = %s", (username, hashed))
    result = cursor.fetchone()
    if result:
        role = result[0]
        if role == 'manager':
            Manager(username).menu()
        elif role == 'team':
            TeamUser(username).menu()
    else:
        print("Invalid credentials.")
    cursor.close()
    conn.close()

def register():
    username = input("Choose username: ")
    password = input("Choose password: ")
    role = input("Choose role (manager/team): ").lower()
    hashed = hash_password(password)
    conn = get_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("INSERT INTO users (username, password_hash, role) VALUES (%s, %s, %s)", (username, hashed, role))
        conn.commit()
        print("Registration successful.")
    except mysql.connector.IntegrityError:
        print("Username already exists.")
    cursor.close()
    conn.close()

# ========== MAIN ==========
def main():
    initialize_database()
    insert_dummy_data()
    while True:
        print("\n==== IPL Management System ====")
        print("1. Login")
        print("2. Register")
        print("3. Exit")
        choice = input("Select option: ")
        if choice == '1':
            login()
        elif choice == '2':
            register()
        elif choice == '3':
            print("Goodbye!")
            break
        else:
            print("Invalid option.")

if __name__ == "__main__":
    main()
