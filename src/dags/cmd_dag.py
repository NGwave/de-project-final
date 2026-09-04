import os
from datetime import datetime
from airflow.decorators import dag, task
from airflow.providers.vertica.operators.vertica import VerticaOperator

@dag(
     dag_id='global_metrics_datamart_v3',
    default_args={
        'owner': 'student',
        'depends_on_past': False
    },
    schedule_interval='@daily', 
    template_searchpath=[os.path.join(os.path.dirname(__file__), 'sql')],      
    start_date=datetime(2022, 11, 01), #последние актуальные данные в учебном датасете 
    catchup=False,                     
    max_active_runs=1,                
    tags=['cdm'],
)
def cmd_upd():
    update_datamart = VerticaOperator(
        task_id='update_datamart',
        vertica_conn_id='vertica_conn',
        sql='calc_cdm.sql'
        )      
    update_datamart


cmd_upd()
