#!/bin/sh

oc adm policy add-cluster-role-to-group system:openshift:templateservicebroker-client system:unauthenticated system:authenticated
oc create -f template-broker.yaml
cat tech-preview.js >>/etc/origin/master/tech-preview.js
sed -i -e 's/extensionScripts:/extensionScripts\n    - \/etc\/origin\/master\/tech-preview.js/' /etc/origin/master/master-config.yml
systemctl restart atomic-openshift-master
