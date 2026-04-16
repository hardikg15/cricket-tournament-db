-- ============================================================
-- Queries
-- ============================================================

USE cricket_tournament;

-- ============================================================
-- SECTION 1: Basic SELECT Queries
-- ============================================================

-- Q: List all scheduled matches with venue name and date
SELECT m.match_id, m.match_date, m.match_time, v.venue_name, v.city, m.match_type, m.status
FROM Matches m
JOIN Venue v ON m.venue_id = v.venue_id
WHERE m.status = 'Scheduled'
ORDER BY m.match_date;

-- Q: Get all teams alphabetically
SELECT team_id, team_name, country, coach_name
FROM Team
ORDER BY team_name;

-- ============================================================
-- SECTION 2: Aggregate + GROUP BY 
-- ============================================================

-- Q3a-i: Count how many matches are scheduled at each venue
SELECT v.venue_name, COUNT(m.match_id) AS total_matches
FROM Venue v
LEFT JOIN Matches m ON v.venue_id = m.venue_id
GROUP BY v.venue_id, v.venue_name
ORDER BY total_matches DESC;

-- Q3a-ii: Count matches per match type (Group, Semi-Final, Final)
SELECT match_type, COUNT(*) AS num_matches
FROM Matches
GROUP BY match_type
HAVING COUNT(*) >= 1
ORDER BY num_matches DESC;

-- Q3a-iii: Count number of matches each referee has been assigned to
SELECT r.referee_name, COUNT(ra.match_id) AS matches_officiated
FROM Referee r
LEFT JOIN Referee_Assignment ra ON r.referee_id = ra.referee_id
GROUP BY r.referee_id, r.referee_name
HAVING matches_officiated > 0
ORDER BY matches_officiated DESC;

-- ============================================================
-- SECTION 3: JOIN Queries
-- ============================================================

-- Q4a: Full match schedule — teams, venue, referees (JOIN across 5 tables)
SELECT
    m.match_id,
    m.match_date,
    m.match_type,
    v.venue_name,
    v.city,
    t1.team_name  AS home_team,
    t2.team_name  AS away_team,
    m.status
FROM Matches m
JOIN Venue v        ON m.venue_id = v.venue_id
JOIN Participation p1 ON m.match_id = p1.match_id AND p1.role = 'Home'
JOIN Participation p2 ON m.match_id = p2.match_id AND p2.role = 'Away'
JOIN Team t1        ON p1.team_id = t1.team_id
JOIN Team t2        ON p2.team_id = t2.team_id
ORDER BY m.match_date;

-- Q4a-ii: List all referees assigned to a specific match (match_id = 6, the Final)
SELECT r.referee_name, r.nationality, ra.assignment_role
FROM Referee r
JOIN Referee_Assignment ra ON r.referee_id = ra.referee_id
WHERE ra.match_id = 6;

-- ============================================================
-- SECTION 4: Subqueries
-- ============================================================

-- Q4b: Get team names participating in the Final (match_id = 6) using subquery
-- (Equivalent to the JOIN version above, but using nested SELECT)
SELECT team_name
FROM Team
WHERE team_id IN (
    SELECT team_id
    FROM Participation
    WHERE match_id = (
        SELECT match_id FROM Matches WHERE match_type = 'Final' LIMIT 1
    )
);

-- Q4b-ii: Get venues that have hosted more than 1 match (subquery alternative)
SELECT venue_name
FROM Venue
WHERE venue_id IN (
    SELECT venue_id
    FROM Matches
    GROUP BY venue_id
    HAVING COUNT(*) > 1
);

-- ============================================================
-- SECTION 5: Advanced / Analytical Queries
-- ============================================================

-- Q: Check for scheduling conflicts — same venue, same date, same time
SELECT venue_id, match_date, match_time, COUNT(*) AS clash_count
FROM Matches
GROUP BY venue_id, match_date, match_time
HAVING clash_count > 1;

-- Q: Matches where India is playing (either home or away)
SELECT m.match_id, m.match_date, v.venue_name, m.match_type
FROM Matches m
JOIN Venue v ON m.venue_id = v.venue_id
WHERE m.match_id IN (
    SELECT match_id FROM Participation
    WHERE team_id = (SELECT team_id FROM Team WHERE team_name = 'India')
)
ORDER BY m.match_date;

-- Q: Referee workload — referees assigned to more than 3 matches
SELECT r.referee_name, COUNT(ra.match_id) AS total_assignments
FROM Referee r
JOIN Referee_Assignment ra ON r.referee_id = ra.referee_id
GROUP BY r.referee_id, r.referee_name
HAVING total_assignments > 3;
