#+ /bin/sh

if test $# != 1; then
    echo You need to pass in role arn for the role having the AWSIoTThingsRegistration managed policy attached.
    exit 1
fi
if [[ -z "$ACCOUNT_ID" ]]; then
    echo "Please set the ACCOUNT_ID"
    exit 1
fi

region=${region:-eu-west-1}
profile=${profile:-default}
std_awscli_args="--output text --region ${region} --profile ${profile}"

source_policy=$(dirname $0)/fp-template-claim.json
target_policy=/tmp/fp-template-claim.$$.json

sed -e "s/ACCOUNT_ID/${ACCOUNT_ID}/g" -e "s/REGION/${region}/g" ${source_policy} > ${target_policy}

aws ${std_awscli_args} iot create-provisioning-template \
    --template-name fp-template-claim \
    --description "Provision by claim with no parameters" \
    --template-body file://${target_policy} \
    --enabled \
    --provisioning-role-arn $1

if test $? != 0; then
    echo "creating the provisioning template in the cloud failed.  check errors and try again."
    exit 1
fi
