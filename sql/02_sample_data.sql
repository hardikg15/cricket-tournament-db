-- ============================================================
-- Cricket Tournament Scheduling Database — Sample Data
-- ============================================================

USE cricket_tournament;

-- Venues
INSERT INTO Venue (venue_name, city, capacity) VALUES
('Narendra Modi Stadium',  'Ahmedabad',  132000),
('Eden Gardens',           'Kolkata',    66000),
('Wankhede Stadium',       'Mumbai',     33000),
('M. Chinnaswamy Stadium', 'Bengaluru',  40000),
('Rajiv Gandhi Stadium',   'Hyderabad',  55000);

-- Teams
INSERT INTO Team (team_name, country, coach_name) VALUES
('India',        'India',       'Gautam Gambhir'),
('Australia',    'Australia',   'Andrew McDonald'),
('England',      'England',     'Brendon McCullum'),
('South Africa', 'South Africa','Rob Walter'),
('New Zealand',  'New Zealand', 'Gary Stead'),
('Pakistan',     'Pakistan',    'Jason Gillespie');

-- Referees
INSERT INTO Referee (referee_name, nationality, experience_yrs) VALUES
('Aleem Dar',      'Pakistani',    25),
('Kumar Dharmasena','Sri Lankan',   18),
('Richard Kettleborough','English', 15),
('Marais Erasmus', 'South African', 20),
('Rod Tucker',     'Australian',   12);

-- Matches
INSERT INTO Matches (match_date, match_time, venue_id, match_type, status) VALUES
('2026-06-01', '14:00:00', 1, 'Group',        'Scheduled'),
('2026-06-03', '10:00:00', 2, 'Group',        'Scheduled'),
('2026-06-05', '14:00:00', 3, 'Group',        'Scheduled'),
('2026-06-08', '14:00:00', 4, 'Group',        'Scheduled'),
('2026-06-15', '14:00:00', 1, 'Semi-Final',   'Scheduled'),
('2026-06-20', '14:00:00', 1, 'Final',        'Scheduled');

-- Participation (2 teams per match)
INSERT INTO Participation (match_id, team_id, role) VALUES
(1, 1, 'Home'), (1, 2, 'Away'),   -- India vs Australia
(2, 3, 'Home'), (2, 4, 'Away'),   -- England vs South Africa
(3, 5, 'Home'), (3, 6, 'Away'),   -- New Zealand vs Pakistan
(4, 1, 'Home'), (4, 3, 'Away'),   -- India vs England
(5, 1, 'Home'), (5, 4, 'Away'),   -- India vs South Africa (Semi)
(6, 1, 'Home'), (6, 2, 'Away');   -- India vs Australia (Final)

-- Referee Assignments
INSERT INTO Referee_Assignment (match_id, referee_id, assignment_role) VALUES
(1, 1, 'Umpire1'),      (1, 2, 'Umpire2'),      (1, 3, 'Third Umpire'), (1, 4, 'Match Referee'),
(2, 2, 'Umpire1'),      (2, 3, 'Umpire2'),       (2, 4, 'Third Umpire'), (2, 5, 'Match Referee'),
(3, 3, 'Umpire1'),      (3, 4, 'Umpire2'),       (3, 5, 'Third Umpire'), (3, 1, 'Match Referee'),
(4, 1, 'Umpire1'),      (4, 5, 'Umpire2'),       (4, 2, 'Third Umpire'), (4, 3, 'Match Referee'),
(5, 1, 'Umpire1'),      (5, 2, 'Umpire2'),       (5, 4, 'Third Umpire'), (5, 5, 'Match Referee'),
(6, 1, 'Umpire1'),      (6, 2, 'Umpire2'),       (6, 3, 'Third Umpire'), (6, 4, 'Match Referee');
