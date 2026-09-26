#!/usr/bin/env bash
set -euo pipefail

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
REPO_DIR="/home/ubuntu/WAR-DEPLOYING"

exec 9>/tmp/war-deploy-sync.lock
flock -n 9 || exit 0

cd "$REPO_DIR"
echo "Syncing deployment manifests from origin/main..."
git pull --ff-only origin main
kubectl apply -f deployment.yml
kubectl apply -f service.yml