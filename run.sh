#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)" #D:\All Project Repository\VS Code\Soumi-Repo\soumi-project2\Soumiproject2\
SQL_DIR="$SCRIPT_DIR/SQL"

DB_HOST="${DB_HOST:-localhost}"
DB_USER="${DB_USER:-postgres}"
DB_NAME="${DB_NAME:-postgres}"
DB_PASSWORD="${DB_PASSWORD:-root}"

if command -v psql >/dev/null 2>&1; then
	PSQL="$(command -v psql)"
elif [[ -x "/c/Program Files/PostgreSQL/18/bin/psql.exe" ]]; then
	PSQL="/c/Program Files/PostgreSQL/18/bin/psql.exe"
else
	echo "psql was not found. Install PostgreSQL client tools or add psql to PATH." >&2
	exit 1
fi


PGPASSWORD="$DB_PASSWORD" "$PSQL" -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 -f "$SQL_DIR/01_create_tables.sql"
PGPASSWORD="$DB_PASSWORD" "$PSQL" -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 -f "$SQL_DIR/02_insert_data.sql"
PGPASSWORD="$DB_PASSWORD" "$PSQL" -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 -f "$SQL_DIR/03_create_procedure.sql"
PGPASSWORD="$DB_PASSWORD" "$PSQL" -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 -f "$SQL_DIR/04_create_function.sql"