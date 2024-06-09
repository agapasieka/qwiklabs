Task 1. Configure HTTP and health check firewall rules
-------------------------------------------------------

gcloud compute firewall-rules create app-allow-http --direction=INGRESS --priority=1000 --network=my-internal-app --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=lb-backend

gcloud compute firewall-rules create app-allow-health-check --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp --source-ranges=130.211.0.0/22,35.191.0.0/16 --target-tags=lb-backend


Task 2. Configure instance templates and create instance groups
-----------------------------------------------------------------

export REGION=

export ZONE1=

export ZONE2=

export PROJECT_ID=$(gcloud config get-value project)

gcloud compute instance-templates create instance-template-1 \
  --machine-type=e2-medium \
  --network-interface=network-tier=PREMIUM,subnet=subnet-a \
  --metadata=startup-script-url=gs://cloud-training/gcpnet/ilb/startup.sh,enable-oslogin=true \
  --region=$REGION \
  --tags=lb-backend \
  --create-disk=auto-delete=yes,boot=yes,device-name=instance-template-1,image=projects/debian-cloud/global/images/debian-12-bookworm-v20240515,mode=rw,size=10,type=pd-balanced 

gcloud compute instance-templates create instance-template-2 \
--machine-type=e2-medium \
--network-interface=network-tier=PREMIUM,subnet=subnet-b \
--metadata=startup-script-url=gs://cloud-training/gcpnet/ilb/startup.sh,enable-oslogin=true \
--region=$REGION \
--tags=lb-backend \
--create-disk=auto-delete=yes,boot=yes,device-name=instance-template-1,image=projects/debian-cloud/global/images/debian-12-bookworm-v20240515,mode=rw,size=10,type=pd-balanced


gcloud beta compute instance-groups managed create instance-group-1 \
    --project=$PROJECT_ID \
    --base-instance-name=instance-group-1 \
    --template=projects/$PROJECT_ID/global/instanceTemplates/instance-template-1 \
    --size=1 \
    --zone=$ZONE1 \
    --default-action-on-vm-failure=repair \
    --no-force-update-on-repair \
    --standby-policy-mode=manual \
    --list-managed-instances-results=PAGELESS \
&& \
gcloud beta compute instance-groups managed set-autoscaling instance-group-1 \
    --project=$PROJECT_ID \
    --zone=$ZONE1 \
    --mode=on \
    --min-num-replicas=1 \
    --max-num-replicas=5 \
    --target-cpu-utilization=0.8 \
    --cool-down-period=45

gcloud beta compute instance-groups managed create instance-group-2 \
    --project=$PROJECT_ID \
    --base-instance-name=instance-group-1 \
    --template=projects/$PROJECT_ID/global/instanceTemplates/instance-template-1 \
    --size=1 \
    --zone=$ZONE2 \
    --default-action-on-vm-failure=repair \
    --no-force-update-on-repair \
    --standby-policy-mode=manual \
    --list-managed-instances-results=PAGELESS \
&& \
gcloud beta compute instance-groups managed set-autoscaling instance-group-1 \
    --project=$PROJECT_ID \
    --zone=$ZONE2 \
    --mode=on \
    --min-num-replicas=1 \
    --max-num-replicas=5 \
    --target-cpu-utilization=0.8 \
    --cool-down-period=45



Verify the backends

gcloud compute instances create utility-vm \
--zone=$ZONE1 \
--machine-type=e2-micro \
--network-interface=network-tier=PREMIUM,private-network-ip=10.10.20.50,stack-type=IPV4_ONLY,subnet=subnet-a \
--create-disk=auto-delete=yes,boot=yes,device-name=utility-vm,image=projects/debian-cloud/global/images/debian-12-bookworm-v20240515,mode=rw,size=10,type=projects/$PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced



Task 3. Configure the Internal Load Balancer
--------------------------------------------

gcloud compute health-checks create tcp my-ilb-health-check --port 80

gcloud compute backend-services create 	be-ilb \
--load-balancing-scheme=INTERNAL \
--protocol=TCP \
--region=$REGION \
--health-checks=my-ilb-health-check \


gcloud compute backend-services add-backend be-ilb \
--region=$REGION  \
--instance-group=instance-group-1 \
--instance-group-zone=$ZONE1

gcloud compute backend-services add-backend be-ilb \
--region=$REGION  \
--instance-group=instance-group-2 \
--instance-group-zone=$ZONE2

gcloud compute addresses create my-ilb-ip --addresses=10.10.30.5 --region=$REGION --subnet=projects/$PROJECT_ID/regions/$REGION/subnetworks/subnet-b 

gcloud compute forwarding-rules create my-ilb \
    --region=$REGION \
    --load-balancing-scheme=internal \
    --network=my-internal-app \
    --subnet=subnet-b \
    --address=my-ilb-ip \
    --ip-protocol=TCP \
    --ports=80 \
    --backend-service=be-ilb


