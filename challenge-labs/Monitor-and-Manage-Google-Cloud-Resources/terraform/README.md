LAB name: Monitor and Manage Google Cloud Resources: Challenge Lab
LAb link: https://www.cloudskillsboost.google/games/4992/labs/32531


1. Review Lab tasks and fill out information in terraform.tfvars
2. In cloud shell copy repo: git clone https://github.com/agapasieka/qwiklabs && cd qwiklabs/challenge-labs/Monitor-and-Manage-Google-Cloud-Resources/terraform/
3. Run terraform init
4. Run terraform apply --auto-approve
5. Fill out variable for bucket from TASK 1 and uplad a sample file called travel.jpg
     
     export INPUT_BUCKET=
   
     wget https://storage.googleapis.com/cloud-training/arc101/travel.jpg
   
     gcloud storage cp travel.jpg gs://$INPUT_BUCKET
