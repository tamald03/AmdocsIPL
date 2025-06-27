use amdocs_ipl;

-- Teams
CREATE TABLE team (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL UNIQUE,
    team_owner varchar(100) not null,
    budget DECIMAL(10, 2),
    ground_id varchar(10)
);
 
-- Coaches
CREATE TABLE coach (
    coach_id INT AUTO_INCREMENT PRIMARY KEY,
    coach_name VARCHAR(100) NOT NULL,
    coach_role varchar(100),
    coach_age int,
    coach_country varchar(100),
    coach_work_exp INT
);
 
-- Players
CREATE TABLE player (
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    player_name VARCHAR(100) NOT NULL,
    player_age int(4),
    player_country VARCHAR(50),
    player_role ENUM('Batsman', 'Bowler', 'All-rounder', 'Wicket-keeper') NOT NULL,
    base_price DECIMAL(10, 2) NOT NULL,
    is_sold BOOLEAN DEFAULT FALSE,
    player_sell_price int
);
 
-- Team-Player Mapping
CREATE TABLE team_player (
    team_id INT,
    player_id INT,
    iscaptain bool default false, 
    bidding_price int, 
    PRIMARY KEY (team_id, player_id),
    FOREIGN KEY (team_id) REFERENCES team(team_id) ON DELETE CASCADE,
    FOREIGN KEY (player_id) REFERENCES player(player_id) ON DELETE CASCADE
);

-- Team-Coach Mapping
create table team_coach(
	team_id int, 
    coach_id int,
    PRIMARY KEY (team_id, coach_id),
    FOREIGN KEY (team_id) REFERENCES team(team_id) ON DELETE CASCADE,
    FOREIGN KEY (coach_id) REFERENCES coach(coach_id) ON DELETE CASCADE
);

-- Umpires
CREATE TABLE umpire (
    umpire_id INT AUTO_INCREMENT PRIMARY KEY,
    umpire_name VARCHAR(100) NOT NULL,
    umpire_country VARCHAR(50),
    umpire_work_exp int(3)
);
 
-- Grounds
CREATE TABLE ground (
    ground_id INT AUTO_INCREMENT PRIMARY KEY,
    ground_name VARCHAR(100) NOT NULL,
    ground_location VARCHAR(100)
);
 
-- Matches
CREATE TABLE match_schedule (
    match_id INT AUTO_INCREMENT PRIMARY KEY,
    team1_id INT,
    team2_id INT,
    ground_id INT,
    umpire1_id INT,
    umpire2_id INT,
    match_date DATE,
    FOREIGN KEY (team1_id) REFERENCES team(team_id),
    FOREIGN KEY (team2_id) REFERENCES team(team_id),
    FOREIGN KEY (ground_id) REFERENCES ground(ground_id),
    FOREIGN KEY (umpire1_id) REFERENCES umpire(umpire_id),
    FOREIGN KEY (umpire2_id) REFERENCES umpire(umpire_id)
);
 

