# MkDocs + Elasticsearch + Reveal.js in Docker

## Requirement
- docker1.10
- docker-compose 1.7.1

## Prepare

- `/etc/hosts` in Host Machine

IP is VM's IP or localhost

- e.g)

```
192.168.30.93 docker-local-elasticsearch
```

## up

```
docker-compose up [-d]
```

### Containers
- cron
    - to post markdown text to elasticsearch
    - run by cron.
    - default `*/10 * * * *`
- mkdocs
    - mkdocs server
- reveal
    - convert to revealjs slide of article
    - default is `docs/sample.md`
- elasticsearch
    - for full-text search of article
- nginx
    - reverse proxy to elasticsearch
    - in order to ajax request from browser

## markdown to elasticsearch

this script (md2es) is running by cron container

```
docker-compose run mkdocs md2es
```

## revealjs serve

```
#                  name   command project file
docker-compose run reveal reveal sample docs/index.md
```

- revealjs slide page

`http://[hostname]:8001`

- to pdf

`http://[hostname]:8001/?print-pdf/#`

