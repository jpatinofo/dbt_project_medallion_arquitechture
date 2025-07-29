#!/usr/bin/env bash

echo "-------- Starting Apolo 11 script... --------"
ABS_PATH=$(pwd)
CONFIG_SH=${ABS_PATH}/scripts/config.sh
CONFIG_FILE=${ABS_PATH}/variables.config

bash ${CONFIG_SH} > ${CONFIG_FILE}
source ${CONFIG_FILE}

TIMESTAMP=$(date $date_format)
FILE_NAME="${consolidated_file_name/fdate/$TIMESTAMP}"

CONSOLIDATED_FILE_PATH="${ABS_PATH}/${stats_folder}/${TIMESTAMP}/${FILE_NAME}"

DB="${ABS_PATH}/database/unal.db"

mkdir -p ${ABS_PATH}/${temp_folder} > /dev/null
mkdir -p ${ABS_PATH}/${backup_folder} > /dev/null
mkdir -p ${ABS_PATH}/${stats_folder} > /dev/null

source ${ABS_PATH}/scripts/create_logs.sh ${TIMESTAMP}

source ${ABS_PATH}/scripts/get_stats.sh ${TIMESTAMP}

# Ejecutar el script Python que carga los datos
python3 app.py $CONSOLIDATED_FILE_PATH "," $DB "bronze.events"

# Ejecutar dbt
dbt deps
dbt seed
dbt run
dbt docs generate

rm -rf variables.config

echo "-------- Apolo 11 script completed successfully. --------"