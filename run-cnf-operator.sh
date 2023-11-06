#!/bin/sh

# For each bundle in a provided catalog, this script will install the operator and run the CNF test suite.
while IFS=, read -r package_name bundle_image
do
  # read package name and bundle image from the text file
  package_name=$(echo "$package_name" | awk '{$1=$1};1')
  bundle_image=$(echo "$bundle_image" | awk '{$1=$1};1')

  # create a new namespace for each operator install
  ns="$package_name"-"test"
  oc new-project $ns

  # use operator-sdk binary to install the operator in a custom namespace
  operator-sdk run bundle $bundle_image

  # change the targetNameSpace in tng_config file
  sed "s/\$ns/$ns/" tnf_config.yml > tnf-config/tnf_config.yml

  # label the Operator csv and Operator(controller) pod
  csv=$(oc get csv -n $ns | grep -v NAME | awk '{print $1}')
  oc label csv $csv test-network-function.com/operator=target -n "$ns"
  pod=$(oc get pod -n $ns | grep -v NAME | awk '{print $1}')
  oc label pod $pod test-network-function.com/generic=target -n "$ns"

  # store the results of CNF test in a new directory
  mkdir -p ./report-certified-october/$package_name

  # run tnf-container
  ./run-tnf-container.sh -k /Users/yoza/Desktop/cnf-certification-test/.kube/config -t /Users/yoza/Desktop/cnf-certification-test/tnf-config -o /Users/yoza/Desktop/cnf-certification-test/report-certified-october/$package_name -c /Users/yoza/Desktop/cnf-certification-test/config.json -l "operator, access-control, networking, affiliated-certification, lifecycle, manageability, networking, observability, platform-alteration"

  # unlabel and uninstall the operator
  csv=$(oc get csv -n $ns | grep -v NAME | awk '{print $1}')
  oc label csv $csv test-network-function.com/operator- -n "$ns"
  operator-sdk cleanup $package_name

  # delete the namespace
  oc delete ns $ns

  # merge claim.json from each operator to a single csv file
  ./tnf/main claim show csv -c ./report-certified-october/$package_name/claim.json -n $package_name -t cmd/tnf/claim/show/csv/cnf-type.json >> result-certified-october-latest.csv
  
done < bundlelist-certified-new.txt
