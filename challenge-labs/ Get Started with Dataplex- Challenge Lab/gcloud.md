gcloud services enable dataplex.googleapis.com

gcloud services enable dataproc.googleapis.com

gcloud services enable metastore.googleapis.com

gcloud services enable datacatalog.googleapis.com

gcloud services enable bigquery.googleapis.com

gcloud services enable storage.googleapis.com

TASK 1
----------------
export LOCATION=


gcloud alpha dataplex lakes create customer-engagements \
 --location=$LOCATION \
 --display-name="Customer Engagements"

 
gcloud alpha dataplex zones create raw-event-data \
--lake=customer-engagements \
--location=$LOCATION \
--display-name="Raw Event Data" \
--type=RAW \
--resource-location-type=SINGLE_REGION \
--discovery-enabled 

TASK 2
---------------
export PROJECT_ID=$(gcloud config get-value project)
export BUCKET=$(gcloud config get-value project)

gsutil mb -l $LOCATION gs://$BUCKET

gcloud alpha dataplex assets create raw-event-files \
--location=$LOCATION \
--display-name="Raw Event Files" \
--lake=customer-engagements \
--zone=raw-event-data \
--resource-type=STORAGE_BUCKET \
--resource-name=projects/$PROJECT_ID/buckets/$BUCKET \
--discovery-enabled \
--csv-header-rows=1 \
--csv-delimiter="," \
--csv-encoding=UTF-8


TASK 3 Create a public tag template named Protected Raw Data Template with an enumerated field named Protected Raw Data Flag that contains two values: Y and N.
---------------------------------------------------------------------------------------------------------------------------------------------------------------

gcloud data-catalog tag-templates create protected_raw_data_template \
--location=$LOCATION \
--display-name="Protected Raw Data Template" \
--field=id=protected_raw_data_flag,display-name="Protected Raw Data Flag",type='enum(Y|N)'


Attach a tag template to an asset


On the left menu, under Discover, click Search.

For Filters > Systems, enable the checkbox for Dataplex.

Click on the customer_raw_data table

 
