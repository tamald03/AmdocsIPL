USE amdocs_ipl;

-- Grounds
CREATE TABLE ground (
    ground_id VARCHAR(10) NOT NULL PRIMARY KEY,
    ground_name VARCHAR(100) NOT NULL,
    ground_location VARCHAR(100)
);

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

-- Umpires
CREATE TABLE umpire (
    umpire_id VARCHAR(10) NOT NULL PRIMARY KEY,
    umpire_name VARCHAR(100) NOT NULL,
    umpire_country VARCHAR(50),
    umpire_work_exp INT
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
    toss VARCHAR(10),
    match_status ENUM('Completed', 'Upcoming', 'Cancelled', 'On-going') NOT NULL,
    match_result ENUM('Win','Loss', 'Draw', 'Cancel') NOT NULL,
    FOREIGN KEY (team1_id) REFERENCES team(team_id),
    FOREIGN KEY (team2_id) REFERENCES team(team_id),
    FOREIGN KEY (ground_id) REFERENCES ground(ground_id),
    FOREIGN KEY (umpire1_id) REFERENCES umpire(umpire_id),
    FOREIGN KEY (umpire2_id) REFERENCES umpire(umpire_id)
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

-- Score Database
CREATE TABLE ind_score (
    player_id VARCHAR(10) NOT NULL,
    team_id VARCHAR(10) NOT NULL,
    match_id VARCHAR(10) NOT NULL,
    runs INT,
    wickets INT,
    catches INT,
    sixes INT,
    fours INT,
    PRIMARY KEY (player_id, match_id),
    FOREIGN KEY (player_id) REFERENCES player(player_id),
    FOREIGN KEY (team_id) REFERENCES team(team_id),
    FOREIGN KEY (match_id) REFERENCES match_schedule(match_id)
);

-- Management
CREATE TABLE management (
    mngt_user VARCHAR(50) NOT NULL PRIMARY KEY,
    mngt_password VARCHAR(50) NOT NULL
);

-- Insert default management user
INSERT INTO management (mngt_user, mngt_password) VALUES ('root', 'abc@123');

-- Value Inserting

--Grounds
INSERT INTO ground (ground_id, ground_name, ground_location) VALUES
('G001', 'Wankhede Stadium', 'Mumbai'),
('G002', 'Eden Gardens', 'Kolkata'),
('G003', 'M. Chinnaswamy Stadium', 'Bangalore'),
('G004', 'Narendra Modi Stadium', 'Ahmedabad');


--teams
INSERT INTO team (team_id, team_name, team_owner, ground_id, team_budget, doc, team_password) VALUES
('T001', 'Mumbai Indians', 'Reliance Industries', 'G001', 95000000, '2008-04-01', 'mi@123'),
('T002', 'Kolkata Knight Riders', 'Red Chillies Entertainment', 'G002', 91000000, '2008-04-01', 'kkr@123'),
('T003', 'Royal Challengers Bangalore', 'United Spirits', 'G003', 92000000, '2008-04-01', 'rcb@123'),
('T004', 'Gujarat Titans', 'CVC Capital Partners', 'G004', 93000000, '2022-01-01', 'gt@123');

--coaches
INSERT INTO coach (coach_id, coach_name, coach_role, coach_country, coach_work_exp, team_id) VALUES
('C001', 'Mahela Jayawardene', 'Head Coach', 'Sri Lanka', 12, 'T001'),
('C002', 'Shane Bond', 'Bowling Coach', 'New Zealand', 10, 'T001'),

('C003', 'Brendon McCullum', 'Head Coach', 'New Zealand', 8, 'T002'),
('C004', 'Wasim Akram', 'Bowling Coach', 'Pakistan', 15, 'T002'),

('C005', 'Sanjay Bangar', 'Head Coach', 'India', 10, 'T003'),
('C006', 'Adam Griffith', 'Bowling Coach', 'Australia', 9, 'T003'),

('C007', 'Ashish Nehra', 'Head Coach', 'India', 7, 'T004'),
('C008', 'Gary Kirsten', 'Batting Coach', 'South Africa', 14, 'T004');


--players
INSERT INTO player (player_id, player_name, player_age, player_country, player_role, team_id, match_id, iscaptain, player_password) VALUES
('P001', 'Rohit Sharma', 36, 'India', 'Batsman', 'T001', NULL, TRUE, 'rohit@mi'),
('P002', 'Suryakumar Yadav', 34, 'India', 'Batsman', 'T001', NULL, FALSE, 'sky@mi'),
('P003', 'Ishan Kishan', 26, 'India', 'Wicket-keeper', 'T001', NULL, FALSE, 'ik@mi'),
('P004', 'Hardik Pandya', 31, 'India', 'All-rounder', 'T001', NULL, FALSE, 'hp@mi'),
('P005', 'Tilak Varma', 21, 'India', 'Batsman', 'T001', NULL, FALSE, 'tv@mi'),
('P006', 'Jasprit Bumrah', 30, 'India', 'Bowler', 'T001', NULL, FALSE, 'jb@mi'),
('P007', 'Arjun Tendulkar', 24, 'India', 'Bowler', 'T001', NULL, FALSE, 'arjun@mi'),
('P008', 'Shreyas Iyer', 29, 'India', 'Batsman', 'T002', NULL, TRUE, 'iyer@kkr'),
('P009', 'Rinku Singh', 27, 'India', 'Batsman', 'T002', NULL, FALSE, 'rinku@kkr'),
('P010', 'Venkatesh Iyer', 28, 'India', 'All-rounder', 'T002', NULL, FALSE, 'vi@kkr'),
('P011', 'Andre Russell', 34, 'West Indies', 'All-rounder', 'T002', NULL, FALSE, 'ar@kkr'),
('P012', 'Sunil Narine', 36, 'West Indies', 'All-rounder', 'T002', NULL, FALSE, 'sn@kkr'),
('P013', 'Varun Chakravarthy', 31, 'India', 'Bowler', 'T002', NULL, FALSE, 'vc@kkr'),
('P014', 'Virat Kohli', 36, 'India', 'Batsman', 'T003', NULL, FALSE, 'vk@rcb'),
('P015', 'Faf du Plessis', 40, 'South Africa', 'Batsman', 'T003', NULL, TRUE, 'faf@rcb'),
('P016', 'Glenn Maxwell', 35, 'Australia', 'All-rounder', 'T003', NULL, FALSE, 'gm@rcb'),
('P017', 'Dinesh Karthik', 38, 'India', 'Wicket-keeper', 'T003', NULL, FALSE, 'dk@rcb'),
('P018', 'Mohammed Siraj', 29, 'India', 'Bowler', 'T003', NULL, FALSE, 'ms@rcb'),
('P019', 'Anuj Rawat', 24, 'India', 'Wicket-keeper', 'T003', NULL, FALSE, 'ar@rcb'),
('P020', 'Shubman Gill', 25, 'India', 'Batsman', 'T004', NULL, TRUE, 'sg@gt'),
('P021', 'David Miller', 35, 'South Africa', 'Batsman', 'T004', NULL, FALSE, 'dm@gt'),
('P022', 'Rashid Khan', 26, 'Afghanistan', 'Bowler', 'T004', NULL, FALSE, 'rk@gt'),
('P023', 'Wriddhiman Saha', 39, 'India', 'Wicket-keeper', 'T004', NULL, FALSE, 'ws@gt'),
('P024', 'Rahul Tewatia', 31, 'India', 'All-rounder', 'T004', NULL, FALSE, 'rt@gt'),
('P025', 'Mohit Sharma', 35, 'India', 'Bowler', 'T004', NULL, FALSE, 'mohit@gt'),
('P026', 'Yashasvi Jaiswal', 28, 'India', 'All-rounder', 'T003', NULL, FALSE, 'yashasvi@ipl'),
('P027', 'Ruturaj Gaikwad', 29, 'India', 'Wicket-keeper', 'T004', NULL, FALSE, 'ruturaj@ipl'),
('P028', 'Sanju Samson', 30, 'India', 'Batsman', 'T001', NULL, FALSE, 'sanju@ipl'),
('P029', 'Deepak Hooda', 31, 'India', 'Bowler', 'T002', NULL, FALSE, 'deepak@ipl'),
('P030', 'Axar Patel', 22, 'India', 'All-rounder', 'T003', NULL, FALSE, 'axar@ipl'),
('P031', 'Kuldeep Yadav', 23, 'India', 'Wicket-keeper', 'T004', NULL, FALSE, 'kuldeep@ipl'),
('P032', 'Prithvi Shaw', 24, 'India', 'Batsman', 'T001', NULL, FALSE, 'prithvi@ipl'),
('P033', 'Ravindra Jadeja', 25, 'India', 'Bowler', 'T002', NULL, FALSE, 'ravindra@ipl'),
('P034', 'KL Rahul', 26, 'India', 'All-rounder', 'T003', NULL, FALSE, 'kl@ipl'),
('P035', 'Shikhar Dhawan', 27, 'India', 'Wicket-keeper', 'T004', NULL, FALSE, 'shikhar@ipl'),
('P036', 'Mayank Agarwal', 28, 'India', 'Batsman', 'T001', NULL, FALSE, 'mayank@ipl'),
('P037', 'Bhuvneshwar Kumar', 29, 'India', 'Bowler', 'T002', NULL, FALSE, 'bhuvneshwar@ipl'),
('P038', 'T Natarajan', 30, 'India', 'All-rounder', 'T003', NULL, FALSE, 't@ipl'),
('P039', 'Washington Sundar', 31, 'India', 'Wicket-keeper', 'T004', NULL, FALSE, 'washington@ipl'),
('P040', 'Umran Malik', 22, 'India', 'Batsman', 'T001', NULL, FALSE, 'umran@ipl'),
('P041', 'Devdutt Padikkal', 23, 'India', 'Bowler', 'T002', NULL, FALSE, 'devdutt@ipl'),
('P042', 'Shivam Dube', 24, 'India', 'All-rounder', 'T003', NULL, FALSE, 'shivam@ipl'),
('P043', 'R Sai Kishore', 25, 'India', 'Wicket-keeper', 'T004', NULL, FALSE, 'r@ipl'),
('P044', 'Chetan Sakariya', 26, 'India', 'Batsman', 'T001', NULL, FALSE, 'chetan@ipl'),
('P045', 'Shahrukh Khan', 27, 'India', 'Bowler', 'T002', NULL, FALSE, 'shahrukh@ipl'),
('P046', 'Arshdeep Singh', 28, 'India', 'All-rounder', 'T003', NULL, FALSE, 'arshdeep@ipl'),
('P047', 'Harshal Patel', 29, 'India', 'Wicket-keeper', 'T004', NULL, FALSE, 'harshal@ipl'),
('P048', 'Ravi Bishnoi', 30, 'India', 'Batsman', 'T001', NULL, FALSE, 'ravi@ipl'),
('P049', 'Manish Pandey', 31, 'India', 'Bowler', 'T002', NULL, FALSE, 'manish@ipl'),
('P050', 'Abhishek Sharma', 22, 'India', 'All-rounder', 'T003', NULL, FALSE, 'abhishek@ipl'),
('P051', 'Raj Angad Bawa', 23, 'India', 'Wicket-keeper', 'T004', NULL, FALSE, 'raj@ipl'),
('P052', 'Sai Sudharsan', 24, 'India', 'Batsman', 'T001', NULL, FALSE, 'sai@ipl'),
('P053', 'Jitesh Sharma', 25, 'India', 'Bowler', 'T002', NULL, FALSE, 'jitesh@ipl'),
('P054', 'Riyan Parag', 26, 'India', 'All-rounder', 'T003', NULL, FALSE, 'riyan@ipl'),
('P055', 'Yuzvendra Chahal', 27, 'India', 'Wicket-keeper', 'T004', NULL, FALSE, 'yuzvendra@ipl'),
('P056', 'Avesh Khan', 28, 'India', 'Batsman', 'T001', NULL, FALSE, 'avesh@ipl'),
('P057', 'Ishan Porel', 29, 'India', 'Bowler', 'T002', NULL, FALSE, 'ishan@ipl'),
('P058', 'Nitish Rana', 30, 'India', 'All-rounder', 'T003', NULL, FALSE, 'nitish@ipl'),
('P059', 'Rahul Tripathi', 31, 'India', 'Wicket-keeper', 'T004', NULL, FALSE, 'rahul@ipl'),
('P060', 'Anmolpreet Singh', 22, 'India', 'Batsman', 'T001', NULL, FALSE, 'anmolpreet@ipl'),
('P061', 'Sandeep Sharma', 23, 'India', 'Bowler', 'T002', NULL, FALSE, 'sandeep@ipl'),
('P062', 'Navdeep Saini', 24, 'India', 'All-rounder', 'T003', NULL, FALSE, 'navdeep@ipl'),
('P063', 'Shubham Mavi', 25, 'India', 'Wicket-keeper', 'T004', NULL, FALSE, 'shubham@ipl'),
('P064', 'Kamlesh Nagarkoti', 26, 'India', 'Batsman', 'T001', NULL, FALSE, 'kamlesh@ipl'),
('P065', 'Lalit Yadav', 27, 'India', 'Bowler', 'T002', NULL, FALSE, 'lalit@ipl'),
('P066', 'Anmolpreet Singh', 28, 'India', 'All-rounder', 'T003', NULL, FALSE, 'anmolpreet@ipl'),
('P067', 'Simarjeet Singh', 29, 'India', 'Wicket-keeper', 'T004', NULL, FALSE, 'simarjeet@ipl'),
('P068', 'Mukesh Choudhary', 30, 'India', 'Batsman', 'T001', NULL, FALSE, 'mukesh@ipl'),
('P069', 'Kartik Tyagi', 31, 'India', 'Bowler', 'T002', NULL, FALSE, 'kartik@ipl'),
('P070', 'Maheesh Theekshana', 22, 'India', 'All-rounder', 'T003', NULL, FALSE, 'maheesh@ipl'),
('P071', 'B Sai Praneeth', 23, 'India', 'Wicket-keeper', 'T004', NULL, FALSE, 'b@ipl'),
('P072', 'Rajvardhan Hangargekar', 24, 'India', 'Batsman', 'T001', NULL, FALSE, 'rajvardhan@ipl'),
('P073', 'Vicky Ostwal', 25, 'India', 'Bowler', 'T002', NULL, FALSE, 'vicky@ipl'),
('P074', 'Hrithik Shokeen', 26, 'India', 'All-rounder', 'T003', NULL, FALSE, 'hrithik@ipl'),
('P075', 'Suyash Sharma', 27, 'India', 'Wicket-keeper', 'T004', NULL, FALSE, 'suyash@ipl');

--Umpires
INSERT INTO umpire (umpire_id, umpire_name, umpire_country, umpire_work_exp) VALUES
('U001', 'Nitin Menon', 'India', 10),
('U002', 'Sundaram Ravi', 'India', 15),
('U003', 'Anil Chaudhary', 'India', 12),
('U004', 'Rod Tucker', 'Australia', 20),
('U005', 'Marais Erasmus', 'South Africa', 22),
('U006', 'Chris Gaffaney', 'New Zealand', 18),
('U007', 'Kumar Dharmasena', 'Sri Lanka', 19),
('U008', 'Paul Reiffel', 'Australia', 17),
('U009', 'Bruce Oxenford', 'Australia', 21),
('U010', 'Michael Gough', 'England', 14);

--matches
INSERT INTO match_schedule (match_id, team1_id, team2_id, ground_id, umpire1_id, umpire2_id, match_date, toss, match_status, match_result) VALUES
('M001', 'T001', 'T002', 'G001', 'U003', 'U004', '2025-04-01', 'T001', 'Completed', 'Win'),
('M002', 'T001', 'T003', 'G001', 'U005', 'U006', '2025-04-02', 'T001', 'Completed', 'Loss'),
('M003', 'T001', 'T004', 'G001', 'U001', 'U002', '2025-04-03', 'T001', 'Cancelled', 'Cancel'),
('M004', 'T002', 'T003', 'G002', 'U003', 'U004', '2025-04-04', 'T002', 'Completed', 'Loss'),
('M005', 'T002', 'T004', 'G002', 'U005', 'U006', '2025-04-05', 'T002', 'Completed', 'Draw'),
('M006', 'T003', 'T004', 'G003', 'U001', 'U002', '2025-04-06', 'T003', 'Completed', 'Loss'),
('M007', 'T001', 'T004', 'G001', 'U007', 'U008', '2025-04-10', 'T001', 'Completed', 'Win'),
('M008', 'T002', 'T003', 'G002', 'U009', 'U010', '2025-04-11', 'T002', 'Completed', 'Loss'),
('M009', 'T001', 'T002', 'G004', 'U001', 'U003', '2025-04-13', 'T002', 'Cancelled', 'Cancel'),
('M010', 'T001', 'T003', 'G001', 'U002', 'U003', '2025-04-14', 'T003', 'On-going', 'Draw'),
('M011', 'T004', 'T002', 'G004', 'U004', 'U005', '2025-04-15', 'T004', 'Upcoming', 'Draw'),
('M012', 'T003', 'T002', 'G003', 'U006', 'U001', '2025-04-16', 'T002', 'Upcoming', 'Draw'),
('M013', 'T004', 'T001', 'G004', 'U002', 'U006', '2025-04-17', 'T001', 'Upcoming', 'Draw');