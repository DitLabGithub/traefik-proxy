FROM traefik:v3.3

# Create necessary directory and copy users file
COPY ./users /etc/traefik/users