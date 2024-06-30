

# PostgreSQL

To use Debezium we need to adjust a few things that are described here:
https://debezium.io/documentation/reference/stable/connectors/postgresql.html#setting-up-postgresql

The most important one is to set the `wal_level` to `logical` inside `/var/lib/postgresql/data/postgresql.conf`

# Debezium

## PostgreSQL Connctor

``` json
{
  "name": "orders-connector",
  "config": {
    "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
    "tasks.max": "1",
    "database.hostname": "postgres",
    "database.port": "5432",
    "database.user": "postgres",
    "database.password": "1234",
    "database.dbname": "postgres",
    "table.include.list": "public.products,public.deliveries",
    "topic.prefix": "ecom",
    "schema.history.internal.kafka.bootstrap.servers": "kafka1:9092,kafka2:9092,kafka3:9092",
    "plugin.name": "pgoutput",
    "snapshot.mode": "initial",
    "snapshot.lock.timeout.ms": "60000",
    "snapshot.minimal.locks": "true"
  }
}
```