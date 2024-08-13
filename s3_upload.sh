#!/bin/bash

# Variables
UPLOAD_DIR="/var/www/html/uploads"
BUCKET_NAME="my-website-uploads-yourname"
DATE=$(date +%Y-%m-%d-%H%M)
LOG_FILE="/var/log/s3_upload.log"

# Upload files to S3
aws s3 sync $UPLOAD_DIR s3://$BUCKET_NAME/uploads/$DATE --log-level info >> $LOG_FILE 2>&1

# Delete files older than one day from S3
aws s3 ls s3://$BUCKET_NAME/uploads/ | awk '{print $2}' | while read -r dir; do
  aws s3 rm s3://$BUCKET_NAME/uploads/$dir --recursive --exclude "*" --include "*$(date -d '1 day ago' +%Y-%m-%d)*" >> $LOG_FILE 2>&1
done

