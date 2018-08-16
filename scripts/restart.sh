#!/bin/bash
cd ~/gui
nohup npm start &
cd ~/backend
nohup mvn spring-boot:run &