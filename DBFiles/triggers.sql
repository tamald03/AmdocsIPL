DROP TRIGGER IF EXISTS trg_invalid_match_config;
DROP TRIGGER IF EXISTS trg_check_captain_and_max_players;
DROP TRIGGER IF EXISTS trg_single_captain_update;
DROP TRIGGER IF EXISTS trg_min_18_players;


-- Ensuring Unique match setup 
DELIMITER //
CREATE TRIGGER trg_invalid_match_config BEFORE INSERT ON match_schedule FOR EACH ROW BEGIN
    -- Ensure different teams
    IF NEW.team1_id = NEW.team2_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A match cannot be scheduled between the same team.';
    END IF;

    -- Ensure different umpires
    IF NEW.umpire1_id = NEW.umpire2_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A match must have two different umpires.';
    END IF;
END
//

DELIMITER ;

-- on insert ensuring we have only one captain and max players per team is 25
DELIMITER //
CREATE TRIGGER trg_check_captain_and_max_players BEFORE INSERT ON player FOR EACH ROW BEGIN
    DECLARE player_count INT;
    DECLARE captain_count INT;

    -- Max 25 players check
    IF NEW.team_id IS NOT NULL THEN
        SELECT COUNT(*) INTO player_count FROM player WHERE team_id = NEW.team_id;
        IF player_count >= 25 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot add player: Team already has maximum 25 players.';
        END IF;
    END IF;

    -- Single captain check
    IF NEW.iscaptain = TRUE THEN
        SELECT COUNT(*) INTO captain_count 
        FROM player 
        WHERE team_id = NEW.team_id AND iscaptain = TRUE;
        
        IF captain_count >= 1 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'A team can have only one captain.';
        END IF;
    END IF;
END
//

DELIMITER ;

-- having only one captain on update 
DELIMITER //
CREATE TRIGGER trg_single_captain_update BEFORE UPDATE ON player FOR EACH ROW BEGIN
    DECLARE cap_count INT;

    IF NEW.iscaptain = TRUE AND OLD.iscaptain = FALSE THEN
        SELECT COUNT(*) INTO cap_count 
        FROM player 
        WHERE team_id = NEW.team_id AND iscaptain = TRUE;

        IF cap_count >= 1 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'This team already has a captain.';
        END IF;
    END IF;
END
//

DELIMITER ;

-- on delete ensuring there are min 18 players 
DELIMITER //
CREATE TRIGGER trg_min_18_players BEFORE DELETE ON player FOR EACH ROW BEGIN
    DECLARE player_count INT;

    IF OLD.team_id IS NOT NULL THEN
        SELECT COUNT(*) INTO player_count 
        FROM player WHERE team_id = OLD.team_id;

        IF player_count <= 18 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Cannot delete player: Team must have at least 18 players.';
        END IF;
    END IF;
END
//

DELIMITER ;
