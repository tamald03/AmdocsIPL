import mysql.connector
from mysql.connector import Error
from abc import ABC, abstractmethod
import hashlib
from getpass import getpass
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
                print("9. Team Management")
                print("10. Player Management")
                print("11. Umpire Management")
                print("12. Ground Management")
                print("13. View System Rules & Restrictions")
                print("14. View Current Team Roster by Role")
                print("15. View Team Captains")
                print("16. Logout")
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
                    self.team_management_menu()
                elif choice == "10":
                    self.player_management_menu()
                elif choice == "16":
                    print("Logging out...")
                    return
                elif choice == "13":
                    view_trigger_rules()
                elif choice == "14":
                    view_team_rosters_by_role()
                elif choice == "11":
                     self.umpire_management_menu()
                elif choice == "12":
                    self.ground_management_menu()
                elif choice == "15":
                    view_team_captains()
                else:
                    print("Invalid option.")
        except Exception as e:
            print("Error in Manager menu:", e)

    def umpire_management_menu(self):
        while True:
            print("\n--- Umpire Management ---")
            print("1. Show Umpire Details")
            print("2. Add Umpire")
            print("3. Delete Umpire")
            print("4. Back to Manager Menu")
            choice = input("Enter choice: ")
            conn = get_connection()
            cursor = conn.cursor()
            try:
                if choice == "1":
                    cursor.execute("SELECT * FROM umpire")
                    rows = cursor.fetchall()
                    table = PrettyTable([i[0] for i in cursor.description])
                    for row in rows:
                        table.add_row(row)
                    print(table)
                elif choice == "2":
                    uid = input("Enter Umpire ID: ")
                    name = input("Enter Umpire Name: ")
                    country = input("Enter Country: ")
                    cursor.execute("INSERT INTO umpire (umpire_id, umpire_name, umpire_country) VALUES (%s, %s, %s)", (uid, name, country))
                    conn.commit()
                    print("Umpire added successfully.")
                elif choice == "3":
                    uid = input("Enter Umpire ID to delete: ")
                    cursor.execute("DELETE FROM umpire WHERE umpire_id = %s", (uid,))
                    conn.commit()
                    print("Umpire deleted successfully.")
                elif choice == "4":
                    break
                else:
                    print("Invalid choice")
            except Exception as e:
                print("Error:", e)
            finally:
                cursor.close()
                conn.close()

    def ground_management_menu(self):
        while True:
            print("\n--- Ground Management ---")
            print("1. Show Ground Details")
            print("2. Add Ground")
            print("3. Delete Ground")
            print("4. Back to Manager Menu")
            choice = input("Enter choice: ")
            conn = get_connection()
            cursor = conn.cursor()
            try:
                if choice == "1":
                    cursor.execute("SELECT g.ground_id, g.ground_name, g.ground_location, t.team_name FROM ground g LEFT JOIN team t ON g.ground_id = t.ground_id")
                    rows = cursor.fetchall()
                    table = PrettyTable(["Ground ID", "Ground Name", "Location", "Assigned Team"])
                    for row in rows:
                        table.add_row(row)
                    print(table)
                elif choice == "2":
                    gid = input("Enter Ground ID: ")
                    name = input("Enter Ground Name: ")
                    location = input("Enter Ground Location: ")
                    cursor.execute("INSERT INTO ground (ground_id, ground_name, ground_location) VALUES (%s, %s, %s)", (gid, name, location))
                    conn.commit()
                    print("Ground added successfully.")
                elif choice == "3":
                    gid = input("Enter Ground ID to delete: ")
                    cursor.execute("DELETE FROM ground WHERE ground_id = %s", (gid,))
                    conn.commit()
                    print("Ground deleted successfully.")
                elif choice == "4":
                    break
                else:
                    print("Invalid choice")
            except Exception as e:
                print("Error:", e)
            finally:
                cursor.close()
                conn.close()

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
            print("New Player assigned.")
            cursor.close()
            conn.close()
        except Exception as e:
            print("Error:", e)

    def top_run_scorers(self):
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
        table = PrettyTable(["Player", "Team", "Runs"])
        for row in rows:
            table.add_row(row)
        print(table)
        cursor.close()
        conn.close()

    def top_wicket_takers(self):
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
        table = PrettyTable(["Player", "Team", "Wickets"])
        for row in rows:
            table.add_row(row)
        print(table)
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

    def team_management_menu(self):
        try:
            while True:
                print("\n--- Team Management ---")
                print("1. Add Team")
                print("2. Delete Team")
                print("3. Update Team")
                print("4. Back to Manager Menu")
                choice = input("Enter choice: ")
                if choice == "1":
                    self.add_team()
                elif choice == "2":
                    self.delete_team()
                elif choice == "3":
                    self.update_team()
                elif choice == "4":
                    break
                else:
                    print("Invalid option.")
        except Exception as e:
            print("Error in Team Management:", e)

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

    def delete_team(self):
        team_id = input("Enter Team ID to delete: ")
        conn = get_connection()
        cursor = conn.cursor()
        try:
            cursor.execute("DELETE FROM team WHERE team_id = %s", (team_id,))
            conn.commit()
            print("Team deleted successfully.")
        except Exception as e:
            print("Error deleting team:", e)
        finally:
            cursor.close()
            conn.close()

    def update_team(self):
        team_id = input("Enter Team ID to update: ")
        name = input("Enter new team name: ")
        owner = input("Enter new owner name: ")
        ground_id = input("Enter new ground ID: ")
        budget = int(input("Enter new budget: "))
        create_date = input("Enter new creation date (YYYY-MM-DD): ")
        password = input("Enter new password: ")
        hashed_pw = hash_password(password)
        conn = get_connection()
        cursor = conn.cursor()
        try:
            cursor.execute("""
                UPDATE team
                SET team_name = %s, team_owner = %s, ground_id = %s, team_budget = %s, create_date = %s, team_password = %s
                WHERE team_id = %s
            """, (name, owner, ground_id, budget, create_date, hashed_pw, team_id))
            conn.commit()
            print("Team updated successfully.")
        except Exception as e:
            print("Error updating team:", e)
        finally:
            cursor.close()
            conn.close()


    def player_management_menu(self):
        try:
            while True:
                print("\n--- Player Management ---")
                print("1. Add Player")
                print("2. Exchange Two Players Between Teams")
                print("3. View Player Stats by ID")
                print("4. Back to Manager Menu")
                choice = input("Enter choice: ")
                if choice == "1":
                    self.add_player()
                elif choice == "2":
                    self.exchange_players()
                elif choice == "3":
                    self.view_player_stats()
                elif choice == "4":
                    break
                else:
                    print("Invalid option.")
        except Exception as e:
            print("Error in Player Management:", e)

    def add_player(self):
        try:
            player_id = input("Enter Player ID: ")
            name = input("Enter Player Name: ")
            role = input("Enter Role (Batsman/Bowler/All-rounder): ")
            country = input("Enter Country: ")
            team_id = input("Enter Team ID: ")
            iscaptain = input("Is Captain? (yes/no): ").lower() == "yes"
            password = getpass("Enter Player Password: ")
            hashed_pw = hash_password(password)
            conn = get_connection()
            cursor = conn.cursor()
            cursor.execute("""
                INSERT INTO player (player_id, player_name, player_role, player_country, team_id, iscaptain, player_password)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, (player_id, name, role, country, team_id, iscaptain, hashed_pw))
            conn.commit()
            print("Player added successfully.")
        except Exception as e:
            print("Error adding player:", e)
        finally:
            cursor.close()
            conn.close()
    def exchange_players(self):
        try:
            p1 = input("Enter Player ID 1: ")
            p2 = input("Enter Player ID 2: ")
            conn = get_connection()
            cursor = conn.cursor()

            cursor.execute("SELECT team_id, iscaptain FROM player WHERE player_id = %s", (p1,))
            result1 = cursor.fetchone()
            cursor.execute("SELECT team_id, iscaptain FROM player WHERE player_id = %s", (p2,))
            result2 = cursor.fetchone()

            if not result1 or not result2:
                print("One or both players not found.")
                return

            t1, c1 = result1
            t2, c2 = result2

            if c1 != c2:
                print("Exchange not allowed: one player is a captain and the other is not.")
                return

            cursor.execute("UPDATE player SET team_id = %s WHERE player_id = %s", (t2, p1))
            cursor.execute("UPDATE player SET team_id = %s WHERE player_id = %s", (t1, p2))
            conn.commit()
            print("Players exchanged successfully.")
        except Exception as e:
            print("Error exchanging players:", e)
        finally:
            cursor.close()
            conn.close()


    def view_player_stats(self):
        try:
            player_id = input("Enter Player ID: ")
            conn = get_connection()
            cursor = conn.cursor()
            cursor.execute("""
                SELECT p.player_name, t.team_name, SUM(i.runs), SUM(i.wickets)
                FROM ind_score i
                JOIN player p ON i.player_id = p.player_id
                JOIN team t ON i.team_id = t.team_id
                WHERE i.player_id = %s
                GROUP BY p.player_name, t.team_name
            """, (player_id,))
            row = cursor.fetchone()
            if row:
                table = PrettyTable(["Player", "Team", "Total Runs", "Total Wickets"])
                table.add_row(row)
                print(table)
            else:
                print("No stats found for given player ID.")
        except Exception as e:
            print("Error viewing player stats:", e)
        finally:
            cursor.close()
            conn.close()
def login():
    username = input("Username: ")
    password = getpass("Password: ")
    hashed = hash_password(password)
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT mngt_password FROM management WHERE mngt_user = %s", (username,))
    manager = cursor.fetchone()
    if manager and manager[0] == hashed:
        print("Logged in as Manager")
        Manager(username).menu()
        cursor.close()
        conn.close()
        return

    cursor.execute("SELECT team_password FROM team WHERE team_id = %s", (username,))
    team = cursor.fetchone()
    if team and team[0] == hashed:
        print("Logged in as Team")
        TeamUser(username).menu()
        cursor.close()
        conn.close()
        return

    print("Invalid credentials.")
    cursor.close()
    conn.close()

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

def manager_procedure_menu():
    print("\n(Advanced features placeholder — to be implemented)")

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


if __name__ == "__main__":
    main()
