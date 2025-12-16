CREATE INDEX station_days_embedding_idx
ON station_days
USING ivfflat (embedding vector_cosine_ops)
WITH (lists = 100);
