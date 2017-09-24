#!/bin/bash
SUBSCRIPTION=6b9ff356-ec54-41e5-bf9d-9f37f7fa60fd
RESOURCE_GROUP=openshift
LOCATION="West Europe"
PASSWORD=`pwgen -1`

az group create -n openshift -l "$LOCATION"
az keyvault create -n sterburg-vault -g $RESOURCE_GROUP -l "$LOCATION" --enabled-for-template-deployment
az keyvault secret set --vault-name sterburg-vault -n ssh-key --file ~/.ssh/id_rsa
az ad sp create-for-rbac -n openshiftcloudprovider --password $PASSWORD --role contributor --scopes /subscriptions/$SUBSCRIPTION/resourceGroups/$RESOURCE_GROUP

az group deployment create --name ocp-deployment \
                           --template-file azuredeploy.json \
                           --parameters @azuredeploy.parameters.json \
                                        aadClientSecret=$PASSWORD \
                                        openshiftPassword=$PASSWORD \
                           --resource-group $RESOURCE_GROUP \
                           --no-wait
