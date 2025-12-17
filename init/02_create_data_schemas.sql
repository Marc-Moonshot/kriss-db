CREATE TABLE device_days (
    id SERIAL PRIMARY KEY,
    deviceId BIGINT NOT NULL,
    day BIGINT NOT NULL,
    embedding vector(1024),
    raw JSONB,
    UNIQUE (deviceId, day)
);

CREATE TYPE reading_type as ENUM (
    'pressure',
    'flow_rate',
    'flow_acc',
    'turbidity'
);

CREATE TABLE readings (
    id SERIAL PRIMARY KEY,
    device_day_id INTEGER NOT NULL REFERENCES device_days(id) ON DELETE CASCADE,
    type reading_type,
    timestamp BIGINT,
    value DOUBLE PRECISION
);

CREATE TABLE station_errors (
    id SERIAL PRIMARY KEY,
    device_day_id INTEGER NOT NULL REFERENCES device_days(id) ON DELETE CASCADE,
    timestamp BIGINT,
    error_code TEXT
);
