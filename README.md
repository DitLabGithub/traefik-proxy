# Traefik Proxy Setup

This repository contains a Docker Compose configuration for setting up Traefik as a reverse proxy. It is designed to be flexible, supporting both **local development** and **production Docker Swarm** environments.

## Setup Guide

### 1. Create External Networks

Traefik uses external networks to communicate with services and the Docker socket proxy.

**For Local Development:**
```bash
docker network create web
```

### 2. Create authentication file

Create a file named users in the same directory as your docker-compose.yml:

```# Generate password hash
htpasswd -nb admin strongpassword > users

# Or manually create the file with content like:
# admin:$apr1$zxS7IiJT$PWCmBVNSoogQzL5JL0a9N1
```

If you don't have htpasswd installed:
On macOS: brew install httpd
On Ubuntu/Debian: apt-get install apache2-utils
On Windows: Use WSL or install Apache HTTP Server

### 3. Create environment variables

Create a .env file in the same directory as your docker-compose.yml:

```
# Do
cp .env-template .env
```

and adjust accordingly to your needs

### 4. Start Traefik

you still need to build to get the users file in.

```
docker compose -f docker-compose-dev.yml up -d --build
```

## Adding services

To add your own services behind Traefik, use labels in your Docker Compose files:

```
services:
  myapp:
    image: myapp:latest
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.myapp.rule=Host(`myapp.localhost`)"
      - "traefik.http.routers.myapp.entrypoints=web"
    networks:
      - web

networks:
  web:
    external: true
```

or with tls:

```
services:
  myapp:
    image: myapp:latest
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.myapp.rule=Host(`myapp.example.com`)"
      - "traefik.http.routers.myapp.entrypoints=websecure"
      - "traefik.http.routers.myapp.tls=true"
      - "traefik.http.routers.myapp.tls.certresolver=letsencrypt"
    networks:
      - web

networks:
  web:
    external: true
```

## Troubleshooting

### Dashboard Not Accessible

- Check that the DOMAIN environment variable is set correctly
- Verify that port 8080 is not being used by another service
- Ensure the users file exists and has valid credentials

### TLS Not Working

- Make sure TRAEFIK_TLS is set to true
- Verify that EMAIL is set to a valid email address
- Check that ports 80 and 443 are accessible from the internet (required for Let's Encrypt)

### Services Not Appearing

- Ensure services are connected to the web network
- Verify that services have the traefik.enable=true label
- Check that the Host rule matches your expected domain

### More information

For more advanced setups visit [the documentation](https://doc.traefik.io/traefik/)
