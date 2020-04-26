#!/bin/bash
PROJECT=isb-cgc-01-0006
SA=github-action-for-covid19
gcloud iam service-accounts create $SA \
       --description "allow necessary cloud storage for automating covid19 data updates"
gcloud projects add-iam-policy-binding isb-cgc-01-0006 \
  --member serviceAccount:${SA}@${PROJECT}.iam.gserviceaccount.com \
  --role roles/storage.objectCreator \
  --role roles/storage.objectViewer
gcloud iam service-accounts keys create ~/.ssh/${SA}@${PROJECT}.json \
       --iam-account ${SA}@${PROJECT}.iam.gserviceaccount.com
echo <<EOF
base64 ~/.ssh/${SA}@${PROJECT}.json
Add the encoded key to the repository's secrets (⚙ Settings > Secrets), named GOOGLE_APPLICATION_CREDENTIALS
Add the service account email, `${SA}@${PROJECT}.iam.gserviceaccount.com`, to the repository's secrets, named SA_EMAIL
Add the project name, $PROJECT to repository secrets as RUN_PROJECT
EOF

