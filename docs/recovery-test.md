# Prueba de recuperación

Un respaldo no se considera válido hasta comprobar que puede restaurarse. Esta guía usa una base de prueba local, nunca una base de datos en uso.

## Preparación

1. Confirma que el archivo de respaldo fue creado por `scripts/backup-postgres.sh`.
2. Selecciona un nombre de base temporal; por ejemplo, `operations_lab_restore_test`.
3. Verifica que dispones de espacio local y que el contenedor `postgres` está saludable.

## Validación

```bash
set -a && source .env && set +a
docker compose exec -T postgres createdb -U "$POSTGRES_USER" operations_lab_restore_test
gunzip -c backups/ARCHIVO.sql.gz | docker compose exec -T postgres psql -U "$POSTGRES_USER" -d operations_lab_restore_test
docker compose exec -T postgres psql -U "$POSTGRES_USER" -d operations_lab_restore_test -c '\\dt'
```

Reemplaza `ARCHIVO.sql.gz` por un archivo real. Revisa que las tablas esperadas estén presentes y que el comando final no muestre errores.

## Cierre

Cuando la validación concluya, elimina únicamente la base temporal:

```bash
set -a && source .env && set +a
docker compose exec -T postgres dropdb -U "$POSTGRES_USER" operations_lab_restore_test
```

Registra fecha, archivo validado, resultado y cualquier incidencia. En un entorno real también se requerirían retención, copia externa, cifrado, control de acceso y un procedimiento de recuperación aprobado.

