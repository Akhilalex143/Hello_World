 #!/bin/bash

echo "Welcome"

Today="$(date +"%d-%m-%Y-%H:%M:%S")"

mkdir "$Today"

cp -r /home/ubuntu/vijay/*  "$Today"

echo "All Files Copyed Successfully.........!"


tar -cf ./"$Today".tar --exclude \*.tar ./*

echo "tar file created "

rm -r "$Today"

echo "folder Deleted Succfully.......!"

aws s3 cp /home/ubuntu/"$Today".tar  s3://backup1245

echo "all files Send to S3 Buckets "

echo "Thank you"


