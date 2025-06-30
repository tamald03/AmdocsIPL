
import mysql.connector
from mysql.connector import Error
from abc import ABC, abstractmethod
import hashlib
from prettytable import PrettyTable
from datetime import datetime

# ========== CONFIG ==========
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "Tamaldas@01",
    "database": "amdocs_ipl"
}

def get_connection():
    return mysql.connector.connect(**DB_CONFIG)

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
        print("Entered Manager menu")
        try:
            while True:
                print("\n--- Manager Menu ---")
                print("1. View All Teams")
                print("2. View All Players by Team")
                print("3. Count Players by Team")
                print("4. Assign Player to Team")
                print("5. Show Top 5 Run Scorers")
                print("6. Show Top 5 Wicket Takers")
                print("7. Show Points Table")
                print("8. Add Management User")
                print("9. Add Team")
                print("10. Advanced Manager Features")
                print("11. Logout")
                print("12. View System Rules & Restrictions")
                print("13. View Current Team Roster by Role")
                print("14. View Team Captains")
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
                    self.top_run_scorers()
                elif choice == "6":
                    self.top_wicket_takers()
                elif choice == "7":
                    self.points_table()
                elif choice == "8":
                    self.add_management_user()
                elif choice == "9":
                    self.add_team()
                elif choice == "10":
                    manager_procedure_menu()
                elif choice == "11":
                    break
                elif choice == "12":
                    view_trigger_rules()
                elif choice == "13":
                    view_team_rosters_by_role()
                elif choice == "14":
                    view_team_captains()
                else:
                    print("Invalid option.")
        except Exception as e:
            print("Error in Manager menu:", e)

    def view_teams(self):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT team_id, team_name, team_owner, team_budget FROM team")
        rows = cursor.fetchall()
        table = PrettyTable(["ID", "Name", "Owner", "Budget"])
        for row in rows:
            table.add_row(row)
        print(table)
        cursor.close()
        conn.close()

    def view_players_by_team(self):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT t.team_name, p.player_name, p.player_role, p.player_country
            FROM player p
            JOIN team t ON p.team_id = t.team_id
        """)
        rows = cursor.fetchall()
        table = PrettyTable(["Team", "Player", "Role", "Country"])
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
            player_id = input("Enter Player ID: ")
            new_team_id = input("Enter New Team ID: ")
            conn = get_connection()
            cursor = conn.cursor()
            cursor.execute("UPDATE player SET team_id = %s WHERE player_id = %s", (new_team_id, player_id))
            conn.commit()
            print("Player reassigned.")
            cursor.close()
            conn.close()
        except Exception as e:
            print("Error:", e)

    def top_run_scorers(self):
        try:
            conn = get_connection()
            cursor = conn.cursor()
            cursor.execute("""
                SELECT p.player_name, t.team_name, SUM(i.runs) as total_runs
                FROM ind_score i
                JOIN player p ON i.player_id = p.player_id
                JOIN team t ON i.team_id = t.team_id
                GROUP BY p.player_name, t.team_name
                ORDER BY total_runs DESC
                LIMIT 5
            """)
            rows = cursor.fetchall()
            if not rows:
                print("No run scorer data available.")
                return
            table = PrettyTable(["Player", "Team", "Runs"])
            for row in rows:
                table.add_row(row)
            print(table)
        except Exception as e:
            print("Error fetching top run scorers:", e)
        finally:
            cursor.close()
            conn.close()

    def top_wicket_takers(self):
        try:
            conn = get_connection()
            cursor = conn.cursor()
            cursor.execute("""
                SELECT p.player_name, t.team_name, SUM(i.wickets) as total_wickets
                FROM ind_score i
                JOIN player p ON i.player_id = p.player_id
                JOIN team t ON i.team_id = t.team_id
                GROUP BY p.player_name, t.team_name
                ORDER BY total_wickets DESC
                LIMIT 5
            """)
            rows = cursor.fetchall()
            if not rows:
                print("No wicket taker data available.")
                return
            table = PrettyTable(["Player", "Team", "Wickets"])
            for row in rows:
                table.add_row(row)
            print(table)
        except Exception as e:
            print("Error fetching top wicket takers:", e)
        finally:
            cursor.close()
            conn.close()

    def points_table(self):
        today = input("Enter date (YYYY-MM-DD): ")
        try:
            datetime.strptime(today, "%Y-%m-%d")
        except ValueError:
            print("Invalid date format.")
            return

        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT match_winner, team1_id, team2_id, match_result
            FROM match_schedule
            WHERE match_date < %s
        """, (today,))
        results = cursor.fetchall()

        stats = {}
        for winner, team1, team2, result in results:
            for team in [team1, team2]:
                if team not in stats:
                    stats[team] = {"Win": 0, "Loss": 0, "Draw": 0, "Points": 0}
            if result == "Win":
                stats[winner]["Win"] += 1
                stats[winner]["Points"] += 2
                loser = team1 if winner == team2 else team2
                stats[loser]["Loss"] += 1
            elif result in ("Cancel", "Draw"):
                stats[team1]["Draw"] += 1
                stats[team2]["Draw"] += 1
                stats[team1]["Points"] += 1
                stats[team2]["Points"] += 1
            elif result == "Loss":
                stats[team1]["Loss"] += 1
                stats[team2]["Win"] += 1
                stats[team2]["Points"] += 2

        table = PrettyTable(["Team", "Wins", "Losses", "Draw/Cancelled", "Points"])
        sorted_stats = sorted(stats.items(), key=lambda x: x[1]['Points'], reverse=True)
        for team_id, record in sorted_stats:
            cursor.execute("SELECT team_name FROM team WHERE team_id = %s", (team_id,))
            team_name = cursor.fetchone()[0]
            table.add_row([
                team_name, record["Win"], record["Loss"], record["Draw"], record["Points"]
            ])
        print(table)
        cursor.close()
        conn.close()

    def add_management_user(self):
        username = input("Enter new management username: ")
        password = input("Enter password: ")
        hashed_pw = hash_password(password)
        conn = get_connection()
        cursor = conn.cursor()
        try:
            cursor.execute("INSERT INTO management (mngt_user, mngt_password) VALUES (%s, %s)", (username, hashed_pw))
            conn.commit()
            print("Management user added successfully.")
        except mysql.connector.Error as err:
            print("Error:", err)
        finally:
            cursor.close()
            conn.close()

    def add_team(self):
        team_id = input("Enter new Team ID: ")
        name = input("Enter team name: ")
        owner = input("Enter owner name: ")
        ground_id = input("Enter ground ID: ")
        budget = int(input("Enter budget: "))
        create_date = input("Enter creation date (YYYY-MM-DD): ")
        password = input("Enter password: ")
        hashed_pw = hash_password(password)
        conn = get_connection()
        cursor = conn.cursor()
        try:
            cursor.execute("""
                INSERT INTO team (team_id, team_name, team_owner, ground_id, team_budget, create_date, team_password)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, (team_id, name, owner, ground_id, budget, create_date, hashed_pw))
            conn.commit()
            print("Team added successfully.")
        except mysql.connector.Error as err:
            print("Error:", err)
        finally:
            cursor.close()
            conn.close()

def manager_procedure_menu():
    while True:
        print("\n--- Advanced Manager Features ---")
        print("1. View Player Stats by Match")
        print("2. View Team Performance Over Time")
        print("3. Back to Manager Menu")
        choice = input("Enter choice: ")
        if choice == "1":
            view_player_stats_by_match()
        elif choice == "2":
            view_team_performance_over_time()
        elif choice == "3":
            break
        else:
            print("Invalid option.")

def view_trigger_rules():
    print("\nSystem Rules & Restrictions (Enforced by Database Triggers):\n")
    table = PrettyTable(["Rule Enforced", "Description"])
    table.add_row(["Match Config Validation", "Match cannot have same teams or same umpires."])
    table.add_row(["Max 25 Players & One Captain", "Team can't exceed 25 players or have multiple captains."])
    table.add_row(["Single Captain Update", "Cannot assign another captain via update if one exists."])
    table.add_row(["Min 18 Players", "Cannot delete players if team has ≤ 18 players."])
    print(table)

def view_team_rosters_by_role():
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT t.team_name, p.player_name, p.player_role
            FROM player p
            JOIN team t ON p.team_id = t.team_id
            ORDER BY t.team_name, p.player_role
        """)
        rows = cursor.fetchall()
        if not rows:
            print("No players found.")
            return
        table = PrettyTable(["Team", "Player", "Role"])
        for row in rows:
            table.add_row(row)
        print("\n=== Team Roster by Role ===")
        print(table)
    except Exception as e:
        print("Error fetching team rosters:", e)
    finally:
        cursor.close()
        conn.close()

def view_team_captains():
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT t.team_name, p.player_name
            FROM player p
            JOIN team t ON p.team_id = t.team_id
            WHERE p.iscaptain = TRUE
        """)
        rows = cursor.fetchall()
        if not rows:
            print("No captains assigned.")
            return
        table = PrettyTable(["Team", "Captain"])
        for row in rows:
            table.add_row(row)
        print("\n=== Current Captains ===")
        print(table)
    except Exception as e:
        print("Error fetching captains:", e)
    finally:
        cursor.close()
        conn.close()

def view_player_stats_by_match():
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT match_id FROM match_schedule WHERE match_status IN ('Completed', 'On-going') ORDER BY match_id")
        valid_matches = [row[0] for row in cursor.fetchall()]
        if not valid_matches:
            print("No matches available.")
            return
        print("Available Matches:", ", ".join(valid_matches))
        match_id = input("Enter match ID to view stats (e.g., M001): ").strip().upper()
        if match_id not in valid_matches:
            print("Invalid match ID.")
            return
        cursor.execute("""
            SELECT ms.match_id, p.player_name, t.team_name, i.runs, i.wickets
            FROM ind_score i
            JOIN player p ON i.player_id = p.player_id
            JOIN team t ON i.team_id = t.team_id
            JOIN match_schedule ms ON i.match_id = ms.match_id
            WHERE ms.match_id = %s
            ORDER BY p.player_name
        """, (match_id,))
        rows = cursor.fetchall()
        if not rows:
            print("No stats available for this match.")
            return
        table = PrettyTable(["Match ID", "Player", "Team", "Runs", "Wickets"])
        for row in rows:
            table.add_row(row)
        print(table)
    except Exception as e:
        print("Error fetching player stats:", e)
    finally:
        cursor.close()
        conn.close()

def view_team_performance_over_time():
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT ms.match_date, t1.team_name AS Team1, t2.team_name AS Team2, ms.match_result, ms.match_winner
            FROM match_schedule ms
            JOIN team t1 ON ms.team1_id = t1.team_id
            JOIN team t2 ON ms.team2_id = t2.team_id
            ORDER BY ms.match_date
        """)
        rows = cursor.fetchall()
        winner_names = {}
        for row in rows:
            winner_id = row[4]
            if winner_id and winner_id not in winner_names:
                cursor.execute("SELECT team_name FROM team WHERE team_id = %s", (winner_id,))
                result = cursor.fetchone()
                winner_names[winner_id] = result[0] if result else "Unknown"
        table = PrettyTable(["Date", "Team 1", "Team 2", "Result", "Winner"])
        for row in rows:
            match_date, team1, team2, result, winner_id = row
            winner_name = winner_names.get(winner_id, "N/A") if winner_id else "N/A"
            table.add_row([match_date, team1, team2, result, winner_name])
        print(table)
    except Exception as e:
        print("Error fetching team performance:", e)
    finally:
        cursor.close()
        conn.close()


def login():
    username = input("Username: ")
    password = input("Password: ")
    hashed = hash_password(password)
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT mngt_password FROM management WHERE mngt_user = %s", (username,))
    manager = cursor.fetchone()
    if manager and manager[0] == hashed:
        print("Logged in as Manager")
        Manager(username).menu()
    else:
        print("Invalid credentials.")
    cursor.close()
    conn.close()

def main():
    while True:
        print("\n==== IPL Management System ====")
        print("1. Login")
        print("2. Exit")
        choice = input("Select option: ")
        if choice == '1':
            login()
        elif choice == '2':
            print("Goodbye!")
            break
        else:
            print("Invalid option.")

class TeamUser(User):
    def menu(self):
        print("Entered Team menu")
        try:
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
        except Exception as e:
            print("Error in Team menu:", e)

    def view_my_players(self):
        team_id = self.username
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
        team_id = self.username
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT coach_name, coach_role, coach_country, coach_work_exp FROM coach WHERE team_id = %s", (team_id,))
        rows = cursor.fetchall()
        table = PrettyTable(["Name", "Role", "Country", "Experience"])
        for row in rows:
            table.add_row(row)
        print(table)
        cursor.close()
        conn.close()

def login():
    username = input("Username: ")
    password = input("Password: ")
    hashed = hash_password(password)
    conn = get_connection()
    cursor = conn.cursor()

    # Check Manager
    cursor.execute("SELECT mngt_password FROM management WHERE mngt_user = %s", (username,))
    manager = cursor.fetchone()
    if manager and manager[0] == hashed:
        print("Logged in as Manager")
        cursor.close()
        conn.close()
        Manager(username).menu()
        return

    # Check Team
    cursor.execute("SELECT team_password FROM team WHERE team_id = %s", (username,))
    team = cursor.fetchone()
    if team and team[0] == hashed:
        print("Logged in as Team")
        cursor.close()
        conn.close()
        TeamUser(username).menu()
        return

    print("Invalid credentials.")
    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()
