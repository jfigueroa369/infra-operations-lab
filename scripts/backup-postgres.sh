#!/usr/bin/env bash
set -euo pipefail

# Ejecutar desde la raíz del repositorio, después de crear el archivo .env.
set -a
source .env
set +a

backup_dir="backups"
timestamp="$(date +%Y%m%d_%H%M%S)"
backup_file="${backup_dir}/${POSTGRES_DB}_${timestamp}.sql.gz"

mkdir -p "${backup_dir}"

docker compose exec -T postgres pg_dump \
  -U "${POSTGRES_USER}" \
  -d "${POSTGRES_DB}" \
  | gzip > "${backup_file}"

echo "Respaldo creado: ${backup_file}"
echo "Valida la recuperación en una base de prueba según docs/recovery-test.md."

