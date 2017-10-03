#!/bin/bash

oc -n openshift policy add-role-to-group edit system:authenticated
