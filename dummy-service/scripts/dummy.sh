#!/bin/bash

while true; do
  echo "Dummy service is running..." | tee -a /var/log/dummy-service.log
  sleep 10
done
