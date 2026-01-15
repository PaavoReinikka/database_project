# Docker services for Postgres, batteries included

Includes:
* **Postgres database as a docker service**
* **Flyway** schema-updates/migrations.
* The service takes care of table definitions and data loading.
* **Available on port 5431** to avoid conflict with host postgres.

A quick way to get the whole database up and running in one command. The `compose.yaml` does everything. Schema (table definitions) are done in `database-migrations/V1__schemas`, dataloading is done in `database-migrations/V2__copyload`. All the data in `./data/` is available inside the database and database-migrations -services.


## Running 


```
docker compose up --build 
```

(no need to build repeatedly unless changes...)

And stopping:

```
docker compose down 
```

## Checking the containers, environment variable etc.

You can enter the running container with 

```
docker exec -it postgresql_database bash # or psql directly to check the database
```

Within the container, you might want to run `printenv` command to check the environment variables.


## Developing the client with Python

If you want to develop the client using Python and run it as a container, you should check [reinikp2/python-3.13-slim-uv](https://hub.docker.com/repository/docker/reinikp2/python-3.13-slim-uv/general)


from docker hub -- it's the standard 3.13 slim but has uv pre-configured.


## Database persistence (not used in this 'database_project')

To ensure database data is persisted locally (i.e., not lost when containers stopped or removed), './pgdata/ ' directory can be bind mounted. The database creates the directory on initial run, if enabled. You can also create it yourself:

```
mkdir -p ./pgdata # creates if not exist
chmod 700 ./pgdata # sets secure permissions (pg default)
sudo chown -R 999:999 ./pgdata # sets ownership to default pg user inside the container (UID 999)
```

