#!/bin/bash
# BEFORE RUNNING THIS SCRIPT, SET YOUR MAPBOX ACCESS_TOKEN HERE:
MAPBOX_ACCOUNT_NAME=""
MAPBOX_ACCESS_TOKEN=""

if [ "$MAPBOX_ACCOUNT_NAME" == '' ] || [ "$MAPBOX_ACCESS_TOKEN" == '' ]; then
    echo "Please set your MapBox account name and/or access token before running this script."
else
    echo "Your MapBox account name = $MAPBOX_ACCOUNT_NAME"
    echo "Your MapBox access token = $MAPBOX_ACCESS_TOKEN"
fi

# Loop through .tif files in current folder. To upload in parallel you need new credentials for every upload. Alternatively wait at least 20 seconds between uploads to clear previous uploads
for FILE in *.tif; do
    if [ -f "$FILE" ]; then

    # Request credentials for AWS S3 upload from MapBox API:
    echo "Requesting credentials for AWS S3 upload from MapBox API..."
    REPLY=$(curl -X POST "https://api.mapbox.com/uploads/v1/$MAPBOX_ACCOUNT_NAME/credentials?access_token=$MAPBOX_ACCESS_TOKEN")

    # To show the reply received from MapBox API:
    # echo -e "JSON reply recveived from MapBox is: \n $REPLY \n"

    # Extract and set the variables needed for AWS S3 from the MapBox API JSON reply:
    export AWS_ACCESS_KEY_ID=$(echo $REPLY | jq -r '.accessKeyId')
    export AWS_SECRET_ACCESS_KEY=$(echo $REPLY | jq -r '.secretAccessKey')
    export AWS_SESSION_TOKEN=$(echo $REPLY | jq -r '.sessionToken')

    # Extract and set variables for this script to run
    AWS_BUCKET=$(echo $REPLY | jq -r '.bucket')
    AWS_KEY=$(echo $REPLY | jq -r '.key')
    AWS_URL=$(echo $REPLY | jq -r '.url')

    echo "Now starting to upload and process files, one at a time"
    #set the id of the dataset to the filename excluding the file extension
    ID=${FILE%".tif"}
    echo -e "\nStarting upload of new file $FILE to AWS S3"
    aws s3 cp ${FILE} s3://${AWS_BUCKET}/${AWS_KEY}
    echo -e "\nStarting upload of tileset $ID from AWS S3 to MapBox"
    curl -X POST -H "Content-Type: application/json" -H "Cache-Control: no-cache" -d "{\"url\": \"$AWS_URL\", \"tileset\": \"$MAPBOX_ACCOUNT_NAME.$ID\", \"name\": \"$ID\"}" "https://api.mapbox.com/uploads/v1/$MAPBOX_ACCOUNT_NAME?access_token=$MAPBOX_ACCESS_TOKEN"
    echo -e "\nNext please..."
    sleep 1
  fi
done
