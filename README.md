# Network Function Certification Script

## Prerequisites

Before using this script, ensure that you have the following prerequisites in place:

1. **Openshift Client binary (OC)** is installed and configured correctly.

2. **Operator SDK** is installed.

3. The necessary **kubeconfig file** is available and properly configured.

4. You have the required **cnf configuration** and a **list of Operator bundles and packageName** (`bundlelist-certified-new.txt`) that need to be tested.

5. The `tnf_config.yml` and `run-tnf-container.sh` files are available in the same directory as this script.

6. You have the required **permissions and access** to create projects, pods, and manage operators on the OpenShift cluster.

7. You have the registry credentials for `registry.connect.redhat.com` and `registry.redhat.io`

## Usage

To use the script, follow these steps:

1. To get all the packages present in a given catalog:

```
oc get packagemanifest | grep "Red Hat Operators" > redhat-operators.txt
```

2. Get BundleImage for each of the packages:

```
while read i; do ./get-latest-bundle.sh $i; done < redhat-operators.txt > redhat-bundelist.txt
```

3. Create a directory to store the results for each CNF runs:

```
mkdir -p report-redhat-opertaors
```

4. Modify the `run-cnf-operator.sh` script to use `redhat-bundlelist.txt` and above created directory