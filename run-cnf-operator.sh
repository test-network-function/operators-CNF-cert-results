#!/bin/sh
while IFS=, read -r package_name bundle_image
do
  package_name=$(echo "$package_name" | awk '{$1=$1};1')
  bundle_image=$(echo "$bundle_image" | awk '{$1=$1};1')
  # before running 
  ns=test
  oc project $ns
  operator-sdk run bundle $bundle_image
  csv=$(oc get csv -n $ns | grep -v NAME | awk '{print $1}')
  oc label csv $csv test-network-function.com/operator=target -n "$ns"
  pod=$(oc get pod -n $ns | grep -v NAME | awk '{print $1}')
  oc label pod $pod test-network-function.com/generic=target -n "$ns"
  mkdir -p ./reports-redhat-september/$package_name
  ./run-tnf-container.sh -k /Users/yoza/Desktop/cnf-certification-test/.kube/config -t /Users/yoza/Desktop/cnf-certification-test -o /Users/yoza/Desktop/cnf-certification-test/reports-redhat-september/$package_name -c /Users/yoza/Desktop/cnf-certification-test/config.json -l "operator, access-control, networking, affiliated-certification, lifecycle, manageability, networking, observability, platform-alteration"
  csv=$(oc get csv -n $ns | grep -v NAME | awk '{print $1}')
  oc label csv $csv test-network-function.com/operator- -n "$ns"
  operator-sdk cleanup $package_name
  ./tnf/main claim show csv -c ./reports-redhat-september/$package_name/claim.json -n $package_name -t cmd/tnf/claim/show/csv/cnf-type.json >> results-redhat-september.csv
done < bundlelist-redhat-new.txt
