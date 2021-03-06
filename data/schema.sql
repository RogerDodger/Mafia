--
-- Schema for Mafia.pm
-- Author: Cameron Thornton <cthor@cpan.org>
--

PRAGMA foreign_keys = ON;

CREATE TABLE users (
	id        INTEGER PRIMARY KEY,
	-- User info
	name      TEXT(16) COLLATE NOCASE UNIQUE NOT NULL,
	password  TEXT NOT NULL,
	is_admin  BIT(1) DEFAULT 0,
	is_mod    BIT(1) DEFAULT 0,
	email     TEXT(256) COLLATE NOCASE UNIQUE,
	email2    TEXT(256),
	active    BIT(1) DEFAULT 1,
	verified  BIT(1) DEFAULT 0,
	token     TEXT(32),
	-- Game stats
	wins      INTEGER DEFAULT 0,
	losses    INTEGER DEFAULT 0,
	ties      INTEGER DEFAULT 0,
	games     INTEGER DEFAULT 0,
	-- Timestamps
	last_mailed TIMESTAMP,
	created     TIMESTAMP,
	updated     TIMESTAMP
);

-- Player roles, e.g., "Townie", "Goon", "Cop"
CREATE TABLE roles (
	id    INTEGER PRIMARY KEY,
	name  TEXT
);

CREATE TABLE groups (
	id  INTEGER PRIMARY KEY
);

CREATE TABLE teams (
	id    INTEGER PRIMARY KEY,
	name  TEXT
);

CREATE TABLE group_role (
	group_id  INTEGER REFERENCES groups(id) ON DELETE CASCADE,
	role_id   INTEGER REFERENCES roles(id) ON DELETE CASCADE,
	team_id   INTEGER REFERENCES teams(id) ON DELETE CASCADE,
	count     INTEGER NOT NULL,
	PRIMARY KEY (group_id, role_id, team_id)
);

CREATE TABLE group_setup (
	group_id   INTEGER REFERENCES groups(id) ON DELETE CASCADE,
	setup_id   INTEGER REFERENCES setups(id) ON DELETE CASCADE,
	PRIMARY KEY (group_id, setup_id)
);

CREATE TABLE setups (
	id         INTEGER PRIMARY KEY,
	user_id    INTEGER REFERENCES users(id) ON DELETE SET NULL,
	title      TEXT(64),
	descr      TEXT(2048),
	allow_nk   BIT(1) DEFAULT 1,
	allow_nv   BIT(1) DEFAULT 1,
	day_start  BIT(1) DEFAULT 0,
	final      BIT(1) DEFAULT 0,
	private    BIT(1) DEFAULT 1,
	-- Stats
	plays      INTEGER DEFAULT 0,
	-- Timestamps
	created    TIMESTAMP,
	updated    TIMESTAMP
);

CREATE TABLE games (
	id        INTEGER PRIMARY KEY,
	host_id   INTEGER REFERENCES users(id) ON DELETE SET NULL,
	setup_id  INTEGER REFERENCES setups(id),
	is_day    BIT(1),
	gamedate  INTEGER,
	end       TIMESTAMP,
	created   TIMESTAMP
);

CREATE TABLE players (
	id       INTEGER PRIMARY KEY,
	name     TEXT(16),
	user_id  INTEGER REFERENCES users(id) ON DELETE SET NULL,
	game_id  INTEGER REFERENCES games(id) ON DELETE CASCADE,
	role_id  INTEGER REFERENCES roles(id) ON DELETE RESTRICT,
	vote_id  INTEGER REFERENCES players(id) ON DELETE SET NULL,
	team_id  INTEGER REFERENCES teams(id) ON DELETE RESTRICT,
	life     INTEGER DEFAULT 1,
	UNIQUE (user_id, game_id)
);

CREATE TABLE actions (
	game_id    INTEGER REFERENCES games(id) ON DELETE CASCADE,
	actor_id   INTEGER REFERENCES players(id) ON DELETE CASCADE,
	target_id  INTEGER REFERENCES players(id) ON DELETE CASCADE,
	PRIMARY KEY (actor_id, target_id)
);

CREATE TABLE threads (
	id       INTEGER PRIMARY KEY,
	board_id INTEGER REFERENCES boards(id) ON DELETE SET NULL,
	game_id  INTEGER REFERENCES games(id) ON DELETE CASCADE,
	title    TEXT(64)
);

CREATE TABLE posts (
	id        INTEGER PRIMARY KEY,
	thread_id INTEGER REFERENCES threads(id) ON DELETE CASCADE,
	user_id   INTEGER REFERENCES users(id) ON DELETE SET NULL,
	is_op     BIT(1) DEFAULT 0,
	class     TEXT,
	plain     TEXT,
	render    TEXT,
	gamedate  INTEGER,
	created   TIMESTAMP,
	updated   TIMESTAMP
);