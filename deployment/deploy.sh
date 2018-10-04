#!/bin/bash
kubectl create -f mongo-deployment.yaml
kubectl create -f mongo-service.yaml
kubectl create -f backend-deployment.yaml
kubectl create -f backend-service.yaml
kubectl create -f frontend-deployment.yaml
kubectl create -f frontend-service.yaml
