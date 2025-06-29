-- ===============================
-- IPL TEAM MANAGEMENT: PROCEDURES & FUNCTIONS
-- ===============================

-- STORED PROCEDURE: Show all players in a team
DELIMITER //
CREATE PROCEDURE ShowPlayersByTeam(IN teamName VARCHAR(100))
BEGIN
    SELECT p.player_id, p.player_name, p.role, p.iscaptain
    FROM player p
    JOIN team t ON p.team_id = t.team_id
    WHERE t.team_name = teamName;
END //
DELIMITER ;

-- STORED PROCEDURE: Display match details by date
DELIMITER //
CREATE PROCEDURE GetMatchDetailsByDate(IN matchDate DATE)
BEGIN
    SELECT m.match_id, t1.team_name AS Team1, t2.team_name AS Team2,
           m.venue, m.match_date, u1.umpire_name AS Umpire1, u2.umpire_name AS Umpire2
    FROM match_schedule m
    JOIN team t1 ON m.team1_id = t1.team_id
    JOIN team t2 ON m.team2_id = t2.team_id
    JOIN umpire u1 ON m.umpire1_id = u1.umpire_id
    JOIN umpire u2 ON m.umpire2_id = u2.umpire_id
    WHERE m.match_date = matchDate;
END //
DELIMITER ;

-- STORED PROCEDURE: Assign player to team (with validation)
DELIMITER //
CREATE PROCEDURE AssignPlayerToTeam(
    IN p_id INT,
    IN t_id INT
)
BEGIN
    DECLARE team_player_count INT;

    SELECT COUNT(*) INTO team_player_count
    FROM player
    WHERE team_id = t_id;

    IF team_player_count >= 25 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Team already has 25 players.';
    ELSE
        UPDATE player
        SET team_id = t_id
        WHERE player_id = p_id;
    END IF;
END //
DELIMITER ;

-- STORED PROCEDURE: Remove player (with safety)
DELIMITER //
CREATE PROCEDURE SafeRemovePlayer(IN p_id INT)
BEGIN
    DECLARE t_id INT;
    DECLARE t_count INT;

    SELECT team_id INTO t_id FROM player WHERE player_id = p_id;
    SELECT COUNT(*) INTO t_count FROM player WHERE team_id = t_id;

    IF t_count <= 18 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete player. Team must have at least 18 players.';
    ELSE
        DELETE FROM player WHERE player_id = p_id;
    END IF;
END //
DELIMITER ;

-- STORED PROCEDURE: Show team budgets
DELIMITER //
CREATE PROCEDURE ShowTeamBudget()
BEGIN
    SELECT team_name, budget, YEAR(CURDATE()) AS current_year
    FROM team;
END //
DELIMITER ;

-- FUNCTION: Calculate player age
DELIMITER //
CREATE FUNCTION GetPlayerAge(dob DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, dob, CURDATE());
END //
DELIMITER ;

-- FUNCTION: Calculate team budget for future year (10% increment per year)
DELIMITER //
CREATE FUNCTION GetFutureBudget(current_budget DECIMAL(15,2), years INT)
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    RETURN current_budget * POW(1.10, years);
END //
DELIMITER ;

-- FUNCTION: Total matches played by a team
DELIMITER //
CREATE FUNCTION TotalMatchesPlayed(tid INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE match_count INT;
    SELECT COUNT(*) INTO match_count
    FROM match_schedule
    WHERE team1_id = tid OR team2_id = tid;
    RETURN match_count;
END //
DELIMITER ;
