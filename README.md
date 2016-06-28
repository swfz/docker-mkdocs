# MkDocs + Elasticsearch + Reveal.js in Docker

## Prepare

- `/etc/hosts` in Host Machine

IP is VM's IP or localhost

```
192.168.30.93 docker-local-elasticsearch
```

## up

```
docker-compose up [-d]
```

## markdown to elasticsearch

```
docker-compose run mkdocs md2es
```

## revealjs serve

```
docker-compose run reveal reveal sample docs/index.md
```

- revealjs slide page

`http://[hostname]:8001`

- to pdf

`http://[hostname]:8001/?print-pdf/#`

