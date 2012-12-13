--
-- Schema for Mafia.pm
-- Author: Cameron Thornton <cthor@cpan.org>
--

PRAGMA foreign_keys = ON;

CREATE TABLE users (
	id        INTEGER PRIMARY KEY,
	name      TEXT(16) COLLATE NOCASE UNIQUE NOT NULL,
	role_id   INTEGER REFERENCES roles(id) NOT NULL,
	email     TEXT(256) COLLATE NOCASE UNIQUE NOT NULL,
	email2    TEXT(256),
	active    BIT(1) DEFAULT 1,
	verified  BIT(1) DEFAULT 0,
	token     TEXT(32),
	created   TIMESTAMP,
	updated   TIMESTAMP
);

CREATE TABLE roles (
	id    INTEGER PRIMARY KEY,
	type  INTEGER,
	role  TEXT
);

CREATE TABLE groups (
	id  INTEGER PRIMARY KEY
);

CREATE TABLE group_role (
	group_id  INTEGER REFERENCES groups(id) ON DELETE CASCADE,
	role_id   INTEGER REFERENCES roles(id) ON DELETE CASCADE,
	PRIMARY KEY (group_id, role_id)
);

CREATE TABLE group_setup (
	group_id  INTEGER REFERENCES groups(id) ON DELETE CASCADE,
	setup_id   INTEGER REFERENCES roles(id) ON DELETE CASCADE,
	PRIMARY KEY (group_id, setup_id)
);

CREATE TABLE setups (
	id       INTEGER PRIMARY KEY,
	user_id  INTEGER PRIMARY KEY,
	title    TEXT(64),
	final    BIT(1) DEFAULT 0,
	open     BIT(1) DEFAULT 1,
	created  TIMESTAMP,
	updated  TIMESTAMP
);

CREATE TABLE games (
	id        INTEGER PRIMARY KEY,
	host_id   INTEGER REFERENCES users(id) ON DELETE CASCADE,
	setup_id  INTEGER REFERENCES setups(id),
	created   TIMESTAMP
);

CREATE TABLE players (
	id       INTEGER PRIMARY KEY,
	user_id  INTEGER REFERENCES users(id) ON DELETE CASCADE,
	game_id  INTEGER REFERENCES games(id) ON DELETE CASCADE,
	role_id  INTEGER REFERENCES roles(id) NOT NULL,
	team     TEXT,
	life     INTEGER,
	UNIQUE (user_id, game_id)
);

CREATE TABLE votes (
	game_id   INTEGER REFERENCES games(id) ON DELETE CASCADE,
	voter_id  INTEGER REFERENCES players(id) ON DELETE CASCADE,
	voted_id  INTEGER REFERENCES players(id) ON DELETE CASCADE,
	PRIMARY KEY (voter_id, voted_id)
);

CREATE TABLE actions (
	game_id    INTEGER REFERENCES games(id) ON DELETE CASCADE,
	actor_id   INTEGER REFERENCES players(id) ON DELETE CASCADE,
	target_id  INTEGER REFERENCES players(id) ON DELETE CASCADE,
	PRIMARY KEY (actor_id, target_id)
);

CREATE TABLE posts (
	id        INTEGER PRIMARY KEY,
	thread_id INTEGER REFERENCES threads(id) ON DELETE CASCADE,
	user_id   INTEGER REFERENCES users(id) ON DELETE SET NULL,
	class     TEXT,
	body      TEXT,
	created   TIMESTAMP,
	updated   TIMESTAMP
);