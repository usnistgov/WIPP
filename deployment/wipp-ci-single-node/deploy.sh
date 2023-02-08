#!/bin/bash
kubectl create -f mongo-deployment.yaml
kubectl create -f mongo-service.yaml
kubectl create -f postgres-deployment.yaml
kubectl create -f postgres-service.yaml
kubectl create -f keycloak-deployment.yaml
kubectl create -f keycloak-service.yaml
kubectl create -f backend-deployment.yaml
kubectl create -f backend-service.yaml
kubectl create -f tensorboard-deployment.yaml
kubectl create -f tensorboard-service.yaml
kubectl create -f frontend-deployment.yaml
kubectl create -f frontend-service.yaml
kubectl create -f wipp-ingress.yaml
kubectl create -f keycloak-ingress.yaml
kubectl create -f tensorboard-ingress.yaml