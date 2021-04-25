#!/bin/bash

cp -f /var/flyway/data/*.sql  $FLYWAY_HOME/sql/
cd $FLYWAY_HOME/
ls -lrt sql/

BACKUP_FILE=""

if [[ $BACKUP == "ALL" ]] ; then 
	echo "Take Backup (Data + Schema) for Schema $SCHEMA_NAME"
	BACKUP_FILE=/var/flyway/data/$SCHEMA_NAME-all-$(date +%d%m%Y).sql
   
	pg_dump -h $DB_HOST -p $DB_PORT -U postgres --dbname=$DB_NAME --schema=$SCHEMA_NAME --clean --create --column-inserts --inserts --quote-all-identifiers  --file=$BACKUP_FILE --format=plain
	echo "Backup is completeted successfuly and save in file $BACKUP_FILE"
elif [[ $BACKUP == "DATA" ]] ; then
	echo "Take Backup (Data Only) for Schema $SCHEMA_NAME"
	BACKUP_FILE=/var/flyway/data/$SCHEMA_NAME-data-$(date +%d%m%Y).sql
	
	pg_dump -h $DB_HOST -p $DB_PORT -U postgres --dbname=$DB_NAME --data-only --schema=$SCHEMA_NAME --exclude-table=flyway_schema_history --exclude-table=audit --exclude-table=bot_state_transition  --column-inserts --inserts --disable-triggers --quote-all-identifiers --file=$BACKUP_FILE --format=plain
	echo "Backup is completeted successfuly and save in file $BACKUP_FILE"
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