Task 2. Create a VPC network and VM instances
----------------------------------------------

gcloud compute networks create mynetwork --subnet-mode auto


export ZONE1=

export ZONE2=


gcloud compute instances create mynet-us-vm \
--zone $ZONE1 \
--machine-type e2-micro \
--network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=mynetwork


gcloud compute instances create mynet-second-vm \
--zone $ZONE2 \
--machine-type e2-micro \
--network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=mynetwork







