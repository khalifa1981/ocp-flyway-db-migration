#!/bin/bash

cp -f /var/flyway/data/*.sql  $FLYWAY_HOME/sql/
cd $FLYWAY_HOME/
ls -lrt sql/
echo "Current Directory is: $PWD"

BACKUP_FILE=""

if [[ $BACKUP == "ALL" ]] ; then 
	echo "Take Backup (Data + Schema) for Schema $SCHEMA_NAME"
	BACKUP_FILE=$SCHEMA_NAME-all
	BACKUP_FILE_PATH=/var/flyway/data/$BACKUP_FILE.sql
   	export PGPASSWORD=$DB_PASSWORD
   	echo "PGPASSWORD is: $PGPASSWORD"
	pg_dump -h $DB_HOST -p $DB_PORT -U postgres --dbname=$DB_NAME --schema=$SCHEMA_NAME --blobs --clean --create --column-inserts --inserts --quote-all-identifiers  --file=$BACKUP_FILE.sql --format=plain
	echo "Backup is completeted successfuly and save in file $BACKUP_FILE"
	
	zip -r $BACKUP_FILE.zip $BACKUP_FILE.sql
	ls -lrt
fi


if [[ "$IS_CLEAN" -eq 1 ]];
then
	$FLYWAY_HOME/flyway clean info  -user=${DB_USER} -password=${DB_PASSWORD} -url=${DB_URL}
	echo "Database is cleaned successfully"
fi


if [[ "$IS_BASELINE" -eq 1 ]]; 
then
	if [ -z "$BASELINE_VERSION" ]; then 
		echo "Baseline Version is NULL then Set it to 1";
		$BASELINE_VERSION = "1"
	else 
		echo "Baseline is $BASELINE_VERSION"; 
	fi
	
	$FLYWAY_HOME/flyway baseline info  -user=${DB_USER} -password=${DB_PASSWORD} -url=${DB_URL} -baselineVersion=${BASELINE_VERSION}
	echo "Database is baseline successfully"
fi
            

$FLYWAY_HOME/flyway  migrate info  -user=${DB_USER} -password=${DB_PASSWORD} -url=${DB_URL}

while true; do sleep 30; done;