FROM postgres:latest as runner

RUN apt-get update && \
    apt-get install -y postgresql-18-pgvector && \
    rm -rf /var/lib/apt/lists/*

COPY ./init /docker-entrypoint-initdb.d/

EXPOSE 5432
