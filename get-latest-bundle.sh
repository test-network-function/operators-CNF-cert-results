#!/bin/bash

PACKAGE_NAME=$1
jsonData=$(grpcurl -plaintext localhost:50051 api.Registry.ListBundles | jq --arg packagename "$PACKAGE_NAME" '. | select(.packageName == $packagename) | del(.csvJson) | del(.object)')

latest=$(echo "$jsonData" | jq -r '.version' | sort -V | tail -n1)

# retrieve the bundlePath for the latest version
bundlePath=$(echo "$jsonData" | jq -r --arg latest "$latest" '. | select(.version == $latest) | .bundlePath' | tail -n1) 

echo $PACKAGE_NAME, $bundlePath