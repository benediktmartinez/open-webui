#!/bin/bash

# Let's Encrypt initialization script
# Run this once on the VPS to obtain initial SSL certificates

set -e

DOMAIN=chat.utilities.dearemployee.de
EMAIL="${LETSENCRYPT_EMAIL:-admin@dearemployee.de}"  # Set LETSENCRYPT_EMAIL env var or change this

echo "Initializing Let's Encrypt for $DOMAIN..."

# Create required directories
mkdir -p certbot/conf certbot/www

# Start nginx for ACME challenge
echo "Starting nginx..."
docker compose -f docker-compose.yaml -f docker-compose.prod.yaml up -d nginx

# Wait for nginx to start
sleep 5

# Obtain certificate
echo "Requesting certificate for $DOMAIN..."
docker compose -f docker-compose.yaml -f docker-compose.prod.yaml run --rm certbot certonly \
  --webroot \
  -w /var/www/certbot \
  --email "$EMAIL" \
  --agree-tos \
  --no-eff-email \
  -d "$DOMAIN"

# Restart nginx to load the new certificate
echo "Restarting nginx with SSL certificate..."
docker compose -f docker-compose.yaml -f docker-compose.prod.yaml restart nginx

echo "Done! SSL certificate obtained for $DOMAIN"
