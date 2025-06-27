USE amdocs_ipl;

-- Teams
CREATE TABLE team (
    team_id VARCHAR(10) NOT NULL PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL UNIQUE,
    team_owner VARCHAR(100) NOT NULL,
    ground_id VARCHAR(10),
    team_budget INT,
    doc DATE,
    team_password VARCHAR(20) NOT NULL,
    FOREIGN KEY (ground_id) REFERENCES ground(ground_id) ON DELETE SET NULL
);

-- Coaches
CREATE TABLE coach (
    coach_id VARCHAR(10) NOT NULL PRIMARY KEY,
    coach_name VARCHAR(100) NOT NULL,
    coach_role VARCHAR(100),
    coach_country VARCHAR(100),
    coach_work_exp INT,
    team_id VARCHAR(10),
    FOREIGN KEY (team_id) REFERENCES team(team_id) ON DELETE SET NULL
);

-- Players
CREATE TABLE player (
    player_id VARCHAR(10) NOT NULL PRIMARY KEY,
    player_name VARCHAR(100) NOT NULL,
    player_age INT,
    player_country VARCHAR(50),
    player_role ENUM('Batsman', 'Bowler', 'All-rounder', 'Wicket-keeper') NOT NULL,
    team_id VARCHAR(10),
    match_id VARCHAR(10),
    iscaptain BOOLEAN DEFAULT FALSE,
    player_password VARCHAR(10) NOT NULL,
    FOREIGN KEY (team_id) REFERENCES team(team_id) ON DELETE SET NULL,
    FOREIGN KEY (match_id) REFERENCES match_schedule(match_id) ON DELETE SET NULL
);

-- Umpires
CREATE TABLE umpire (
    umpire_id VARCHAR(10) NOT NULL PRIMARY KEY,
    umpire_name VARCHAR(100) NOT NULL,
    umpire_country VARCHAR(50),
    umpire_work_exp INT
);

-- Grounds
CREATE TABLE ground (
    ground_id VARCHAR(10) NOT NULL PRIMARY KEY,
    ground_name VARCHAR(100) NOT NULL,
    ground_location VARCHAR(100)
);

-- Matches
CREATE TABLE match_schedule (
    match_id VARCHAR(10) NOT NULL PRIMARY KEY,
    team1_id VARCHAR(10),
    team2_id VARCHAR(10),
    ground_id VARCHAR(10),
    umpire1_id VARCHAR(10),
    umpire2_id VARCHAR(10),
    match_date DATE,
    match_status ENUM('Completed', 'Upcoming', 'Cancelled', 'On-going') NOT NULL,
    match_result ENUM('Win','Loss', 'Draw', 'Cancel') NOT NULL,
    FOREIGN KEY (team1_id) REFERENCES team(team_id),
    FOREIGN KEY (team2_id) REFERENCES team(team_id),
    FOREIGN KEY (ground_id) REFERENCES ground(ground_id),
    FOREIGN KEY (umpire1_id) REFERENCES umpire(umpire_id),
    FOREIGN KEY (umpire2_id) REFERENCES umpire(umpire_id)
);

-- Score Database
CREATE TABLE ind_score (
    player_id VARCHAR(10) NOT NULL PRIMARY KEY,
    team_id VARCHAR(10) NOT NULL,
    match_id VARCHAR(10),
    runs INT,
    wickets INT,
    catches INT,
    sixes INT,
    fours INT,
    FOREIGN KEY (player_id) REFERENCES player(player_id),
    FOREIGN KEY (team_id) REFERENCES team(team_id),
    FOREIGN KEY (match_id) REFERENCES match_schedule(match_id)
);

-- Management
CREATE TABLE management (
    mngt_user VARCHAR(50) NOT NULL,
    mngt_password VARCHAR(50) NOT NULL
);

-- Insert default management user
INSERT INTO management (mngt_user, mngt_password) VALUES ('root', 'abc@123');


-- In