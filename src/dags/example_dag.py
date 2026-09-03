from datetime import datetime
from airflow.decorators import dag, task
from airflow.providers.amazon.aws.hooks.s3 import S3Hook

@dag(
     dag_id='s3_upload_incremental_2022_v2',
    default_args={
        'owner': 'dwh_team',
        'depends_on_past': False
    },
    schedule_interval='@daily',       
    start_date=datetime(2022, 12, 1),  
    end_date=datetime(2022, 12, 10), 
    catchup=True,                     
    max_active_runs=1,                
    tags=['stg'],
)
def s3_load():
    @task
    def download_currencies():
        s3_conn_id = "conn_s3"  
        bucket_name = "final-project"
        s3_key = "currencies_history.csv"
        local_path = "/tmp/currencies_history.csv"

        # Initialize the S3Hook with your connection
        hook = S3Hook(aws_conn_id=s3_conn_id)

        print(f"Downloading...")
        
        # Download the file
        hook.get_key(s3_key, bucket_name).download_file(local_path)
        
        print("Download complete!")
        return local_path

    @task
    def download_transactions_current_batch(ds=None, **kwargs):
        s3_conn_id = "conn_s3"  
        bucket_name = "final-project"
        local_path = "/tmp/transactions_batch_latest.csv"

        hook = S3Hook(aws_conn_id=s3_conn_id)

        # батчи в s3 названы номерами, а не числами
        # этот код имитирует загрузку по дням 
        day_str = datetime.strptime(ds, "%Y-%m-%d").strftime('%d')
        batch_number = int(day_str)
        file_key = f"transactions_batch_{batch_number}.csv"
        print(file_key)
        if hook.check_for_key(key=file_key, bucket_name=bucket_name):
            print("file found")
            hook.get_key(file_key, bucket_name).download_file(local_path)

        # код для инкрементальной загрузки по датам, который МОГ БЫ БЫТЬ 
        # file_keys = hook.list_keys(bucket_name=bucket_name, prefix='transactions_batch')
        # for key in file_keys:
        #     obj = hook.get_key(key=key, bucket_name=bucket_name)
        #     load_time = obj.last_modified.date()
        #     if load_time == parsed_date:
        #         file_key = obj['Key']
        #         hook.get_key(file_key, bucket_name).download_file(local_path)    

    # 3. Call the task to add it to the DAG topology
    download_currencies() >> download_transactions_current_batch()

# 4. Instantiate the DAG
s3_load()