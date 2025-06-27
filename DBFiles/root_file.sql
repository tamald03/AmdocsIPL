USE amdocs_ipl;
 
-- Teams
CREATE TABLE team (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL UNIQUE,
    team_owner VARCHAR(100) NOT NULL,
    ground_id VARCHAR(10),
    team_budget int,
    doc date
);
 
-- Coaches
CREATE TABLE coach (
    coach_id INT AUTO_INCREMENT PRIMARY KEY,
    coach_name VARCHAR(100) NOT NULL,
    coach_role VARCHAR(100),
    coach_country VARCHAR(100),
    coach_work_exp INT,
    team_id INT,
    FOREIGN KEY (team_id) REFERENCES team(team_id) ON DELETE SET NULL
);
 
-- Players
CREATE TABLE player (
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    player_name VARCHAR(100) NOT NULL,
    player_age INT,
    player_country VARCHAR(50),
    player_role ENUM('Batsman', 'Bowler', 'All-rounder', 'Wicket-keeper') NOT NULL,
    team_id INT,
    match_id int,
    iscaptain BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (team_id) REFERENCES team(team_id) ON DELETE SET NULL,
    FOREIGN KEY (match_id) REFERENCES match_schedule(match_id) on delete set null
);
 
-- Umpires
CREATE TABLE umpire (
    umpire_id INT AUTO_INCREMENT PRIMARY KEY,
    umpire_name VARCHAR(100) NOT NULL,
    umpire_country VARCHAR(50),
    umpire_work_exp INT
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
    match_status enum('Completed', 'Upcoming', 'Cancelled', 'On-going') not null,
    FOREIGN KEY (team1_id) REFERENCES team(team_id),
    FOREIGN KEY (team2_id) REFERENCES team(team_id),
    FOREIGN KEY (ground_id) REFERENCES ground(ground_id),
    FOREIGN KEY (umpire1_id) REFERENCES umpire(umpire_id),
    FOREIGN KEY (umpire2_id) REFERENCES umpire(umpire_id)
);

-- Create table for score_database

CREATE table ind_score(
    player_id int not null primary key,
    team_id int not null,
    match_id int,
    runs int,
    wickets int,
    catches int,
    sixes int,
    fours int,
    foreign key (player_id) REFERENCES player(player_id),
    foreign key (team_id) REFERENCES team(team_id),
    foreign key (match_id) REFERENCES match_schedule(match_id)
);


