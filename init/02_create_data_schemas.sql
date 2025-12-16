CREATE TABLE station_days (
    id SERIAL PRIMARY KEY,
    station TEXT NOT NULL,
    day INTEGER NOT NULL,
    embedding vector(1024),
    UNIQUE (station, day)
);

CREATE TYPE reading_type AS ENUM (
    'pressure',
    'flowRate',
    'flowAcc',
    'rawFlowRate',
    'rawFlowAcc',
    'prodTurbidity',
    'rawTurbidity'
)

CREATE TABLE readings (
    id SERIAL PRIMARY KEY,
    station_day_id INTEGER NOT NULL REFERENCES station_days(id) ON DELETE CASCADE,
    type reading_type NOT NULL,
    timestamp BIGINT NOT NULL,
    value DOUBLE PRECISION NOT NULL
)

CREATE TABLE station_errors (
    id SERIAL PRIMARY KEY,
    station_day_id INTEGER NOT NULL REFERENCES station_days(id) ON DELETE CASCADE,
    timestamp BIGINT NOT NULL,
    error_code TEXT NOT NULL
)
