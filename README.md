# Cricket Tournament Scheduling DB


> Assigned Domain: Sports Tournament Scheduling DB (Complex constraints + conflicts)

---

## Overview

A fully normalized (3NF) relational database for managing a cricket tournament. Handles scheduling of matches, team participation, venue management, referee assignments, and match results with proper integrity constraints to prevent double bookings and data anomalies.

## Schema

```
Venue          (venue_id PK, venue_name, city, capacity)

Team           (team_id PK, team_name, country, coach_name)

Matches        (match_id PK, match_date, match_time, venue_id FK, match_type, status)

Participation  (match_id FK, team_id FK, role)                  [composite PK]

Referee        (referee_id PK, referee_name, nationality, experience_yrs)

Referee_Assignment (match_id FK, referee_id FK, assignment_role)   [composite PK]

Match_Result   (match_id FK, winner_team_id FK, win_margin, player_of_match)
```

All tables are in **3NF** hence no partial or transitive dependencies.

## ER Diagram

See [`er_diagram.md`](er_diagram.md).

Key relationships:
- A **Venue** hosts many **Matches** (one-to-many)
- A **Match** involves exactly 2 **Teams** via **Participation** (many-to-many)
- A **Match** is officiated by multiple **Referees** via **Referee_Assignment**
- A **Match** produces at most one **Match_Result**

## Project Structure

```
cricket-tournament-db/
├── sql/
│   ├── 01_schema.sql        # CREATE TABLE statements with constraints
│   ├── 02_sample_data.sql   # INSERT statements with realistic data
│   └── 03_queries.sql       # SELECT, JOIN, subquery, aggregate queries
│
├── er_diagram.md 
│   
└── README.md
```

## Setup (MariaDB)

### Prerequisites
- MariaDB 10.6+ or MySQL 8.0+

### Steps

```bash
# Clone the repo
git clone https://github.com/<your-username>/cricket-tournament-db.git
cd cricket-tournament-db

# Log into MariaDB
mysql -u root -p

# Run scripts in order
source sql/01_schema.sql
source sql/02_sample_data.sql
source sql/03_queries.sql
```

Or in one line from the terminal:
```bash
mysql -u root -p < sql/01_schema.sql
mysql -u root -p cricket_tournament < sql/02_sample_data.sql
```

## Key Constraints

| Constraint | Table | Purpose |
|---|---|---|
| `UNIQUE(venue_id, match_date, match_time)` | Matches | Prevents double booking a venue |
| `UNIQUE(match_id, assignment_role)` | Referee_Assignment | One referee per role per match |
| `CHECK(match_type IN (...))` | Matches | Only valid tournament stages |
| `CHECK(role IN ('Home','Away'))` | Participation | Enforces team roles |
| `FOREIGN KEY ... ON DELETE CASCADE` | Participation | Cleans up when a match is deleted |

## Sample Queries

```sql
-- Full match schedule with team names
SELECT m.match_date, t1.team_name AS home, t2.team_name AS away, v.venue_name
FROM Matches m
JOIN Venue v ON m.venue_id = v.venue_id
JOIN Participation p1 ON m.match_id = p1.match_id AND p1.role = 'Home'
JOIN Participation p2 ON m.match_id = p2.match_id AND p2.role = 'Away'
JOIN Team t1 ON p1.team_id = t1.team_id
JOIN Team t2 ON p2.team_id = t2.team_id;
```

<p align="center">
  <img src="images/query1.png" width="400"/>
</p>

```
-- Referee workload
SELECT r.referee_name, COUNT(*) AS matches_officiated
FROM Referee r JOIN Referee_Assignment ra ON r.referee_id = ra.referee_id
GROUP BY r.referee_id HAVING matches_officiated > 3;
```

<p align="center">
  <img src="images/query2.png" width="400"/>
</p>



