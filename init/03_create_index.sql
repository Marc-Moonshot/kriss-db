CREATE INDEX device_days_embedding_idx
ON device_days
USING ivfflat (embedding vector_cosine_ops)
WITH (lists = 100);
