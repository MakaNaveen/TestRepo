#!/usr/bin/env bash

AWS_REGION="us-east-1"
TENANT_ID=""

#############################################################
# Print usage information
#############################################################
# Arguments:
#   none
# Returns:
#   none
#############################################################
usage() {
cat << EOF
Usage: ./SQSDelete.sh [OPTIONAL_ARGS]
Optional arguments:
      -r  | --region REGION
      -t  | --tenantId TENANT_ID
EOF
}

#############################################################
# Parses the script arumgents
#############################################################
# Arguments:
#   none
# Returns:
#   none
#############################################################
parse_args() {
  while [[ $# -gt 0 ]]
  do
    key="$1"
    case $key in
      -r|--region)
        AWS_REGION=$2
        shift 2
        ;;
      -t|--tenantId)
        TENANT_ID=$2
        shift 2
        ;;
      -h|--help)
        usage
        shift
        exit 0
        ;;
      --) # end argument parsing
        shift
        break
        ;;
      *) # unsupported flags
        echo "### ERROR: Unsupported flag $1 ###"
        usage
        exit 1
        ;;
      esac
  done
}


#############################################################
# Cleans all the SQS queues which were not cleaned up during
# the teardown step
#############################################################
# Arguments:
#   none
# Returns:
#   none
#############################################################
cleanup_sqs(){
  echo "################"
  echo "Cleaning up SQS resources..."
  echo "################"

  #DEL="delete"

  # create list of queues to delete
  aws --region ${AWS_REGION} sqs list-queues --queue-name-prefix ${TENANT_ID}- > queues-${TENANT_ID}
  aws --region ${AWS_REGION} sqs list-queues --queue-name-prefix "xpod-external-nettyPubsub-${TENANT_ID}-" >> queues-${TENANT_ID}

  #for i in `cat queues-$TENANT_ID | grep http | sed -e 's/"$//' | sed -e 's/",$//' | sed -e 's/^.*"//' | grep -E ":${TENANT_ID}-|-${TENANT_ID}-|/${TENANT_ID}-"` ; do
  #  echo "REMOVE $i"
  #   if [[ "$DEL" == "delete" ]] ; then
   #     aws --region ${AWS_REGION} sqs delete-queue --queue-url $i
  #    fi
  #done

  echo "######################"
  echo "validate SQS "
  echo "######################"
  aws --region us-east-1 sqs list-queues --queue-name-prefix ${TENANT_ID}-
}

######################### START ######################################
ARGS=$@
parse_args $ARGS

echo "################################################################"
echo "### SQS Delete"
echo "################################################################"
echo "### AWS_REGION:           $AWS_REGION"
echo "### TENANT_ID:            $TENANT_ID"
echo "################################################################"

cleanup_sqs

echo "##################"
echo "SQS delete successful"
echo "##################"


#testing signed commit


