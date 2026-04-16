-- ============================================================
-- Cricket Tournament Scheduling Database
-- Subject: DBMS (CIC-210) | Assigned Domain: Sports Tournament Scheduling DB
-- Schema normalized to 3NF
-- ============================================================

CREATE DATABASE IF NOT EXISTS cricket_tournament;
USE cricket_tournament;

-- ============================================================
-- TABLE: Venue
-- Stores information about match venues/stadiums
-- ============================================================
CREATE TABLE Venue (
    venue_id    INT           NOT NULL AUTO_INCREMENT,
    venue_name  VARCHAR(100)  NOT NULL,
    city        VARCHAR(50)   NOT NULL,
    capacity    INT           CHECK (capacity > 0),
    PRIMARY KEY (venue_id),
    UNIQUE (venue_name)
);

-- ============================================================
-- TABLE: Team
-- Stores cricket team details
-- ============================================================
CREATE TABLE Team (
    team_id     INT          NOT NULL AUTO_INCREMENT,
    team_name   VARCHAR(100) NOT NULL,
    country     VARCHAR(50)  NOT NULL,
    coach_name  VARCHAR(100),
    PRIMARY KEY (team_id),
    UNIQUE (team_name)
);

-- ============================================================
-- TABLE: Match
-- Represents a scheduled cricket match
-- match_type: 'Group', 'Quarter-Final', 'Semi-Final', 'Final'
-- status: 'Scheduled', 'Completed', 'Abandoned', 'Postponed'
-- ============================================================
CREATE TABLE Matches (
    match_id    INT          NOT NULL AUTO_INCREMENT,
    match_date  DATE         NOT NULL,
    match_time  TIME         NOT NULL DEFAULT '14:00:00',
    venue_id    INT          NOT NULL,
    match_type  VARCHAR(20)  NOT NULL DEFAULT 'Group'
                             CHECK (match_type IN ('Group','Quarter-Final','Semi-Final','Final')),
    status      VARCHAR(15)  NOT NULL DEFAULT 'Scheduled'
                             CHECK (status IN ('Scheduled','Completed','Abandoned','Postponed')),
    PRIMARY KEY (match_id),
    FOREIGN KEY (venue_id) REFERENCES Venue(venue_id)
                           ON DELETE RESTRICT ON UPDATE CASCADE,
    -- Constraint: same venue cannot have two matches on same date at same time
    UNIQUE (venue_id, match_date, match_time)
);

-- ============================================================
-- TABLE: Participation
-- Links teams to matches (exactly 2 teams per match enforced via app logic)
-- role: 'Home' or 'Away' — distinguishes the two participating teams
-- ============================================================
CREATE TABLE Participation (
    match_id    INT         NOT NULL,
    team_id     INT         NOT NULL,
    role        VARCHAR(10) NOT NULL DEFAULT 'Home'
                            CHECK (role IN ('Home','Away')),
    PRIMARY KEY (match_id, team_id),
    FOREIGN KEY (match_id) REFERENCES Matches(match_id)
                           ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (team_id)  REFERENCES Team(team_id)
                           ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ============================================================
-- TABLE: Referee
-- Stores officials who officiate matches
-- ============================================================
CREATE TABLE Referee (
    referee_id    INT          NOT NULL AUTO_INCREMENT,
    referee_name  VARCHAR(100) NOT NULL,
    nationality   VARCHAR(50),
    experience_yrs INT         CHECK (experience_yrs >= 0),
    PRIMARY KEY (referee_id)
);

-- ============================================================
-- TABLE: Referee_Assignment
-- Assigns referees to matches
-- assignment_role: 'Umpire1', 'Umpire2', 'Third Umpire', 'Match Referee'
-- ============================================================
CREATE TABLE Referee_Assignment (
    match_id        INT         NOT NULL,
    referee_id      INT         NOT NULL,
    assignment_role VARCHAR(20) NOT NULL DEFAULT 'Umpire1'
                                CHECK (assignment_role IN ('Umpire1','Umpire2','Third Umpire','Match Referee')),
    PRIMARY KEY (match_id, referee_id),
    FOREIGN KEY (match_id)   REFERENCES Matches(match_id)
                             ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (referee_id) REFERENCES Referee(referee_id)
                             ON DELETE RESTRICT ON UPDATE CASCADE,
    -- One referee cannot hold two roles in the same match
    UNIQUE (match_id, assignment_role)
);

-- ============================================================
-- TABLE: Match_Result  (derived / post-match data)
-- Stores winner and score summary after match completion
-- ============================================================
CREATE TABLE Match_Result (
    match_id        INT          NOT NULL,
    winner_team_id  INT,                         -- NULL if abandoned/draw
    win_margin      VARCHAR(50),                 -- e.g. "5 wickets", "20 runs"
    player_of_match VARCHAR(100),
    PRIMARY KEY (match_id),
    FOREIGN KEY (match_id)       REFERENCES Matches(match_id)
                                 ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (winner_team_id) REFERENCES Team(team_id)
                                 ON DELETE SET NULL ON UPDATE CASCADE
);
