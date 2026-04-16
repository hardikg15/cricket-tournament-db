# ER Diagram — Cricket Tournament Scheduling DB

```mermaid
erDiagram
  VENUE {
    int venue_id PK
    varchar venue_name
    varchar city
    int capacity
  }
  MATCHES {
    int match_id PK
    date match_date
    time match_time
    int venue_id FK
    varchar match_type
    varchar status
  }
  TEAM {
    int team_id PK
    varchar team_name
    varchar country
    varchar coach_name
  }
  PARTICIPATION {
    int match_id FK
    int team_id FK
    varchar role
  }
  REFEREE {
    int referee_id PK
    varchar referee_name
    varchar nationality
    int experience_yrs
  }
  REFEREE_ASSIGNMENT {
    int match_id FK
    int referee_id FK
    varchar assignment_role
  }
  MATCH_RESULT {
    int match_id FK
    int winner_team_id FK
    varchar win_margin
    varchar player_of_match
  }

  VENUE ||--o{ MATCHES : "hosts"
  MATCHES ||--|{ PARTICIPATION : "has"
  TEAM ||--|{ PARTICIPATION : "plays in"
  MATCHES ||--|{ REFEREE_ASSIGNMENT : "officiated by"
  REFEREE ||--|{ REFEREE_ASSIGNMENT : "assigned to"
  MATCHES ||--o| MATCH_RESULT : "produces"
  TEAM ||--o{ MATCH_RESULT : "wins"
```

## Relationship Notes

- **VENUE → MATCHES**: One venue can host many matches, but each match has exactly one venue.
- **MATCHES ↔ TEAM** (via PARTICIPATION): Many-to-many. Each match has exactly 2 teams (enforced at application level). The `role` attribute distinguishes Home vs Away.
- **MATCHES ↔ REFEREE** (via REFEREE_ASSIGNMENT): Many-to-many. Each match has up to 4 officials (Umpire1, Umpire2, Third Umpire, Match Referee). The `UNIQUE(match_id, assignment_role)` constraint prevents duplicate roles.
- **MATCHES → MATCH_RESULT**: One-to-one optional. A result only exists after the match is completed.
- **MATCH_RESULT → TEAM** (winner): Optional FK. NULL when match is abandoned or drawn.
