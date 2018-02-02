#!/bin/bash

if [ ! ${BUILD_BUILDNUMBER} = '' ];then 
  echo 'Upgrading using rancher-compose' 
  export TMPDIR=/tmp
  export DEPLOYDIR=$(mktemp -d) 
  cat docker-compose.yml.tmpl \
    | envsubst \
    > ${DEPLOYDIR}/docker-compose.yml 
  cat rancher-compose.yml.tmpl \
    | envsubst \
    > ${DEPLOYDIR}/rancher-compose.yml 
  cd ${DEPLOYDIR} 
  timeout --preserve-status 5m \
    rancher-compose \
      --debug \
      --url ${RANCHER_URL} \
      --access-key ${RANCHER_ACCESS_KEY} \
      --secret-key ${RANCHER_SECRET_KEY} \
      --project-name ${RANCHER_STACK_NAME} \
      up \
      --force-upgrade \
      --pull \
      --batch-size "2" \
      -d \
    || status=$? 
       case ${status:=0} in 
         143) 
           echo 'ERROR: Timed out. Check Rancher, service may be spinning.' 
           rm -rf ${DEPLOYDIR} 
           exit ${status} 
           ;; 
         0) 
           ;; 
         *) 
           echo 'ERROR: Other. Check logs above.' 
           rm -rf ${DEPLOYDIR} 
           exit ${status} 
           ;; 
       esac 
  echo '\nConfirming upgrade using rancher-compose' 
  rancher-compose \
    --debug \
    --url ${RANCHER_URL} \
    --access-key ${RANCHER_ACCESS_KEY} \
    --secret-key ${RANCHER_SECRET_KEY} \
    --project-name ${RANCHER_STACK_NAME} \
    up \
    --confirm-upgrade \
    -d 
  rm -rf ${DEPLOYDIR} 
else 
  echo 'ERROR: Are you sure you deployed this through the pipeline?' 
  exit 1 
fi