# Deja Whu Server

A server app built using [Shelf](https://pub.dev/packages/shelf),
configured to enable running with [Docker](https://www.docker.com/).

## Set up

* Set up postgres
* Create env var keys for
  * BONGO_DB_URL - Location of the db, localhost by default
  * BONGO_DB - Name of the database
  * BONGO_DB_USER
  * BONGO_DB_PASSWORD

## Running

```
$ dart run bin/server.dart
Server listening on port 8080
```

## Running with Docker

If you have [Docker Desktop](https://www.docker.com/get-started) installed, you
can build and run with the `docker` command:

```
$ docker build . -t myserver
$ docker run -it -p 8080:8080 myserver
Server listening on port 8080
```
