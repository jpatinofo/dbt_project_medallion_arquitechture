import sys
import traceback

import duckdb
import pandas as pd

# se toman los valores de la configuración y archivos calculados
csv_file_path: str = sys.argv[1]
csv_delimeter: str = sys.argv[2]
database_path: str = sys.argv[3]
table_name: str = sys.argv[4]

connection = None

try:
    # configurar conexión simple
    connection = duckdb.connect(database_path)

    # crea los esquemas del patron llamado medallion architecture
    # mirar: https://www.databricks.com/glossary/medallion-architecture
    connection.execute("CREATE SCHEMA IF NOT EXISTS bronze;")
    connection.execute("CREATE SCHEMA IF NOT EXISTS silver;")
    connection.execute("CREATE SCHEMA IF NOT EXISTS gold;")

    # se va a realizar un pipeline incremental, los datos generados necesitan un
    # unico identificador, por eso la forma mas simple es aplicarle secuencia
    # https://duckdb.org/docs/stable/sql/statements/create_sequence.html
    connection.execute("CREATE SEQUENCE IF NOT EXISTS bronze.seq_events;")

    # se crea events como una tabla para guardar historicos, se pone date como str
    # para no perder los 0 de adelante, mas adelante esto se pasara a fecha con formato
    # event_id sera el valor de la secuencia
    # DEFAULT nextval('bronze.event_seq') forma sencilla de asignar una secuencia para ser explicado
    connection.execute(
        f"""
        CREATE TABLE IF NOT EXISTS {table_name}(
            event_id INTEGER NOT NULL PRIMARY KEY DEFAULT nextval('bronze.seq_events'),
            date STRING NOT NULL,
            mission STRING NOT NULL,
            device_type STRING NOT NULL,
            device_status STRING NOT NULL,
            hash STRING NULL
        );
    """
    )

    df = pd.read_csv(csv_file_path, sep=csv_delimeter)
    # registrar el DataFrame como una tabla temporal en memoria
    connection.register("temp_df", df)

    # insertar datos sin tocar el event_id (automaticamente la tabla alimentara el campo)
    connection.execute(
        f"""
        INSERT INTO {table_name} (date, mission, device_type, device_status, hash)
        SELECT date, mission, device_type, device_status, hash FROM temp_df
    """
    )
except Exception as ex:
    print(ex)
    traceback.print_exc()
    sys.exit(-1)  # marcar salida como erronea

finally:
    if connection is not None:
        connection.close()
