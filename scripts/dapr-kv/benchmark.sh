#!/bin/bash

script_location="$(dirname "${BASH_SOURCE[0]}")"

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
# --


function run() {
    echo "   Running '$@'"
    $@
}
# --

function install_benchmark() {
    local rps="$1"

    local duration=600
    local init_delay=60

    local app_count=$(kubectl get namespaces | grep emojivoto | wc -l)

    kubectl create ns benchmark
    helm install benchmark --namespace benchmark \
        --set wrk2.app.count="$app_count" \
        --set wrk2.RPS="$rps" \
        --set wrk2.duration=$duration \
        --set wrk2.connections=128 \
        --set wrk2.initDelay=$init_delay \
        ${script_location}/../../configs/benchmark/
}
# --

function run_bench() {
    local rps="$1"

    install_benchmark "$rps"
    grace "kubectl get pods -n benchmark | grep wrk2-prometheus | grep -v Running" 60

    echo "Benchmark started."

    while kubectl get jobs -n benchmark \
            | grep wrk2-prometheus \
            | grep -qv 1/1; do
        kubectl logs \
                --tail 1 -n benchmark  jobs/wrk2-prometheus -c wrk2-prometheus
        sleep 10
    done
    echo "Cleaning up."

}
# --

function run_benchmarks(){
    rps=$1
    echo " +++ istio benchmark"
    run_bench $rps
}
# --

kubectl delete ns benchmark
run_benchmarks 20
