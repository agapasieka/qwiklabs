#! /bin/bash

# Function to run Task 1
task_1() {

    gsutil mb -p $DEVSHELL_PROJECT_ID -l $REGION -b on gs://$DEVSHELL_PROJECT_ID-bucket/
    echo "Bucket has been created"
}

# Function to run Task 2
task_2() {

    export KEY_1=domain_type
    export VALUE_1=source_data

    gcloud alpha dataplex lakes create customer-lake --project=$DEVSHELL_PROJECT_ID --location=$REGION --labels="key_1=$KEY_1,value_1=$VALUE_1" --display-name="Customer-Lake"
    gcloud dataplex zones create public-zone --project=$DEVSHELL_PROJECT_ID  --location=$REGION --lake=customer-lake --type=RAW --resource-location-type=SINGLE_REGION --display-name="Public-Zone"
    echo "Lake and Zone has been created"
}

# Function to run Task 3
task_3() {

    gcloud dataplex environments create dataplex-lake-env --project=$DEVSHELL_PROJECT_ID --location=$REGION --lake=customer-lake --os-image-version=1.0 --compute-node-count 3 --compute-max-node-count 3
    echo "Environment has been created"
}

# Function to run Task 4
task_4() {

    gcloud data-catalog tag-templates create customer_data_tag_template --project=$DEVSHELL_PROJECT_ID --location=$REGION --display-name="Customer Data Tag Template" --field=id=data_owner,display-name="Data Owner",type=string,required=TRUE --field=id=pii_data,display-name="PII Data",type='enum(Yes|No)',required=TRUE
    echo "Tag template has been created"
}

# Function to run Task 5
task_5() {

    gcloud dataplex assets create customer-raw-data --project=$DEVSHELL_PROJECT_ID --location=$REGION --lake=customer-lake --zone=public-zone --resource-type=STORAGE_BUCKET --resource-name=projects/$DEVSHELL_PROJECT_ID/buckets/$DEVSHELL_PROJECT_ID-customer-bucket --discovery-enabled --display-name="Customer Raw Data"
    gcloud dataplex assets create customer-reference-data --project=$DEVSHELL_PROJECT_ID --location=$REGION --lake=customer-lake --zone=public-zone --resource-type=BIGQUERY_DATASET --resource-name=projects/$DEVSHELL_PROJECT_ID/datasets/customer_reference_data --display-name="Customer Reference Data"
    echo "Assets have been created"
}

# Function to run Task 6
task_6() {

    bq mk --location=US Raw_data
    bq load --source_format=AVRO Raw_data.public-data gs://spls/gsp1145/users.avro
    echo "Dataset has been created"   
}

# Function to run Task 7
task_7() {

    gcloud dataplex zones create temperature-raw-data --project=$DEVSHELL_PROJECT_ID --lake=public-lake --location=$REGION --type=RAW --resource-location-type=SINGLE_REGION --display-name="temperature-raw-data"
    echo "Zone has been created"    
}

# Function to run Task 8
task_8() {

    gcloud dataplex assets create customer-details-dataset --project=$DEVSHELL_PROJECT_ID --location=$REGION --lake=public-lake --zone=temperature-raw-data --resource-type=BIGQUERY_DATASET --resource-name=projects/$DEVSHELL_PROJECT_ID/datasets/customer_reference_data --discovery-enabled --display-name="Customer Details Dataset"
    echo "Asset has been created"    
}

# Function to run Task 9
task_9() {

    gcloud data-catalog tag-templates create protected_data_template --project=$DEVSHELL_PROJECT_ID --location=$REGION --display-name="Protected Data Template" --field=id=protected_data_flag,display-name="Protected Data Flag",type='enum(Yes|No)',required=TRUE
    echo "Tag template has been created"    
}

# Function to run Task 10
task_10() {

    gcloud dataplex assets create customer-reference-data --project=$DEVSHELL_PROJECT_ID --location=$REGION --zone=public-zone --resource-type=BIGQUERY_DATASET --lake=customer-lake --resource-name=projects/$DEVSHELL_PROJECT_ID/datasets/customer_reference_data --display-name="Customer Reference Data"
    echo "Entity has been created"    
}

# Function to exit
exit_script() {
    echo "Exiting the script."
    exit 0
}


echo " 1: Create a Cloud Storage bucket"
echo " 2: Create a lake in Dataplex and add a zone to your lake"
echo " 3: Environment Creation for Dataplex Lake"
echo " 4: Create a tag template 'customer_data_tag_template'"
echo " 5: Attach an existing Cloud Storage bucket to the zone"
echo " 6: Create a BigQuery dataset"
echo " 7: Add a zone to your lake"
echo " 8: Attach an existing BigQuery Dataset to the Lake"
echo " 9: Create a tag template 'protected_data_template'"
echo "10: Create Entities"


# Loop to prompt the user for input until they choose to exit
while true; do
    # Input task number
    read -p "Enter the Task number from 1-10 (or 0 to exit): " task_number

    case $task_number in
        1)
            task_1
            ;;
        2)
            task_2
            ;;
        3)
            task_3
            ;;
        4)
            task_4
            ;;
        5)
            task_5
            ;;
        6)
            task_6
            ;;    
        7)
            task_7
            ;;
        8)
            task_8
            ;;  
        9)
            task_9
            ;; 
        10)
            task_10
            ;;         
        0)
            exit_script
            ;;
        *)
            echo "Invalid input. Please enter a number between 1 and 10, or 0 to exit."
            ;;
    esac
done



