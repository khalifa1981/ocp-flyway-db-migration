#!/bin/bash

cp -f /var/flyway/data/*.sql  $FLYWAY_HOME/sql/
cd $FLYWAY_HOME/
ls -lrt sql/

if [[ "$IS_CLEAN" -eq 1 ]]; 
then
	$FLYWAY_HOME/flyway clean info  -user=${DB_USER} -password=${DB_PASSWORD} -url=${DB_URL}
	echo "Database is cleaned successfully"
fi


if [[ "$IS_BASELINE" -eq 1 ]]; 
then
	if [ -z "$BASELINE_VERSION" ]; then 
		echo "Baseline Version is NULL then Set it to 1";
		$BASELINE_VERSION = 1
	else 
		echo "Baseline is $BASELINE_VERSION"; 
	fi
	
	$FLYWAY_HOME/flyway baseline info  -user=${DB_USER} -password=${DB_PASSWORD} -url=${DB_URL} -baselineVersion=${BASELINE_VERSION}
	echo "Database is baseline successfully"
fi
            

$FLYWAY_HOME/flyway  migrate info  -user=${DB_USER} -password=${DB_PASSWORD} -url=${DB_URL}