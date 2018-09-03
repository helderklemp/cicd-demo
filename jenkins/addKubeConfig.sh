#!/bin/bash
set -e
set -o pipefail

# Configure kubectl to point to a specific cluster
if [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]] || [[ -z "$4" ]] || [[ -z "$5" ]]; then
 echo "usage: $0 <service_account_name> <namespace> <clusterAddress> <token> <certificate>"
 exit 1
fi

SERVICE_ACCOUNT_NAME=$1
NAMESPACE="$2"
CLUSTER_NAME="${NAMESPACE}"
ENDPOINT="$4"
USER_TOKEN="$5"
CA_CRT="$6"
KUBECFG_FILE_NAME="/tmp/kube/k8s-${SERVICE_ACCOUNT_NAME}-${NAMESPACE}-conf"
TARGET_FOLDER="/tmp/kube/external_conf"

create_target_folder() {
    echo -n "Creating target directory to hold files in ${TARGET_FOLDER}..."
    mkdir -p "${TARGET_FOLDER}"
    printf "done"
}

set_kube_config_values() {
    # Set up the config
    echo -e "\\nPreparing k8s-${SERVICE_ACCOUNT_NAME}-${NAMESPACE}-conf"
    echo -n "Setting a cluster entry in kubeconfig..."
    kubectl config set-cluster "${CLUSTER_NAME}" \
    --kubeconfig="${KUBECFG_FILE_NAME}" \
    --server="${ENDPOINT}" \
    --certificate-authority="${CA_CRT}" \
    --embed-certs=true

    echo -n "Setting token credentials entry in kubeconfig..."
    kubectl config set-credentials \
    "${SERVICE_ACCOUNT_NAME}-${NAMESPACE}-${CLUSTER_NAME}" \
    --kubeconfig="${KUBECFG_FILE_NAME}" \
    --token="${USER_TOKEN}"

    echo -n "Setting a context entry in kubeconfig..."
    kubectl config set-context \
    "${SERVICE_ACCOUNT_NAME}-${NAMESPACE}-${CLUSTER_NAME}" \
    --kubeconfig="${KUBECFG_FILE_NAME}" \
    --cluster="${CLUSTER_NAME}" \
    --user="${SERVICE_ACCOUNT_NAME}-${NAMESPACE}-${CLUSTER_NAME}" \
    --namespace="${NAMESPACE}"

    echo -n "Setting the current-context in the kubeconfig file..."
    kubectl config use-context "${SERVICE_ACCOUNT_NAME}-${NAMESPACE}-${CLUSTER_NAME}" \
    --kubeconfig="${KUBECFG_FILE_NAME}"
}

create_target_folder
set_kube_config_values

export KUBECONFIG=${KUBECFG_FILE_NAME}
KUBECONFIG=${KUBECFG_FILE_NAME} kubectl get pods
