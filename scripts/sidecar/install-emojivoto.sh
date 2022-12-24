#!/bin/bash

function grace() {
    grace=10
    [ -n "$2" ] && grace="$2"

    while true; do
        eval $1
        if [ $? -eq 0 ]; then
            sleep 1
            grace=10
            [ -n "$2" ] && grace="$2"
            continue
        fi

        if [ $grace -gt 0 ]; then
            sleep 1
            echo "grace period: $grace"
            grace=$(($grace-1))
            continue
        fi

        break
    done
}

instance="$1"
echo "Installing emojivoto."

for num in $(seq 0 1 $instance); do
{
  kubectl create namespace emojivoto-$num
  kubectl label namespace emojivoto-$num istio-injection=enabled
  helm install emojivoto-$num --namespace emojivoto-$num $(dirname "${BASH_SOURCE[0]}")/../configs/emojivoto/
  sleep 1s
}
done
wait

grace "kubectl get pods --all-namespaces | grep emojivoto | grep -v Running" 60
