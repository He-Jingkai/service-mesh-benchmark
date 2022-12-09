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

function install_emojivoto() {
    local mesh="$1"
    local instance="$2"

    echo "Installing emojivoto."

    for num in $(seq 0 1 $instance); do
        {
            kubectl create namespace emojivoto-$num

            [ "$mesh" == "istio" ] && \
                kubectl label namespace emojivoto-$num istio.io/dataplane-mode=ambient

            helm install emojivoto-$num --namespace emojivoto-$num \
                             ${script_location}/../configs/emojivoto/
            sleep 1s
         }
    done

    wait

    grace "kubectl get pods --all-namespaces | grep emojivoto | grep -v Running" 60
}
# --


function delete_emojivoto() {
    local instance="$1"
    echo "Deleting emojivoto."

    for i in $(seq 0 1 $instance); do
        { helm uninstall emojivoto-$i --namespace emojivoto-$i;
          kubectl delete namespace emojivoto-$i --wait; } &
    done

    wait

    grace "kubectl get namespaces | grep emojivoto"
}
# --

function run() {
    echo "   Running '$@'"
    $@
}
# --

function install_benchmark() {
    local mesh="$1"
    local rps="$2"

    local duration=600
    local init_delay=60

    local app_count=$(kubectl get namespaces | grep emojivoto | wc -l)

    echo "Running $mesh benchmark"
    kubectl create ns benchmark
    [ "$mesh" == "istio" ] && \
        kubectl label namespace benchmark istio.io/dataplane-mode=ambient
    if [ "$mesh" != "bare-metal" ] ; then
        helm install benchmark --namespace benchmark \
            --set wrk2.serviceMesh="$mesh" \
            --set wrk2.app.count="$app_count" \
            --set wrk2.RPS="$rps" \
            --set wrk2.duration=$duration \
            --set wrk2.connections=128 \
            --set wrk2.initDelay=$init_delay \
            ${script_location}/../configs/benchmark/
    else
        helm install benchmark --namespace benchmark \
            --set wrk2.app.count="$app_count" \
            --set wrk2.RPS="$rps" \
            --set wrk2.duration=$duration \
            --set wrk2.initDelay=$init_delay \
            --set wrk2.connections=128 \
            ${script_location}/../configs/benchmark/
    fi
}
# --

function run_bench() {
    local mesh="$1"
    local rps="$2"

    install_benchmark "$mesh" "$rps"
    grace "kubectl get pods -n benchmark | grep wrk2-prometheus | grep -v Running" 60

    echo "Benchmark started."

    while kubectl get jobs -n benchmark \
            | grep wrk2-prometheus \
            | grep -qv 1/1; do
        kubectl logs \
                --tail 1 -n benchmark  jobs/wrk2-prometheus -c wrk2-prometheus
        sleep 10
    done

#    echo "Benchmark concluded. Updating summary metrics."
#    helm install --create-namespace --namespace metrics-merger \
#        metrics-merger ${script_location}/../configs/metrics-merger/
#    sleep 5
#    while kubectl get jobs -n metrics-merger \
#            | grep wrk2-metrics-merger \
#            | grep  -v "1/1"; do
#        sleep 1
#    done
#
#    kubectl logs -n metrics-merger jobs/wrk2-metrics-merger

    echo "Cleaning up."
#    helm uninstall benchmark --namespace benchmark
#    kubectl delete ns benchmark --wait
#    helm uninstall --namespace metrics-merger metrics-merger
#    kubectl delete ns metrics-merger --wait
}
# --

function run_benchmarks_istio(){
    rps=$1
    instance=$2
    echo " +++ istio benchmark"
    install_emojivoto istio $instance
    run_bench istio $rps
    delete_emojivoto $instance
}
# --

function run_benchmarks_bare_metal(){
    rps=$1
    instance=$2
    echo " +++ bare metal benchmark"
    install_emojivoto bare-metal $instance
    run_bench bare-metal $rps
    delete_emojivoto $instance
}
# --

function run_benchmarks_istio_repeat(){
    instance=$1
    for rps in 500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500; do
        for repeat in 1 2 3 4 5; do
            run_benchmarks_istio $rps $instance
        done
    done
}
# --

function run_benchmarks_bare_metal_repeat(){
    instance=$1
    for rps in 500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500; do
        for repeat in 1 2 3 4 5; do
           run_benchmarks_bare_metal $rps $instance
        done
    done
}
# --

if [ "$(basename $0)" = "benchmark-emojivoto.sh" ] ; then
    # if [ "$1" = "istio" ] ; then
    #     run_benchmarks_istio_repeat
    # fi
    # if [ "$1" = "bare-metal" ] ; then
    #     run_benchmarks_bare_metal_repeat
    # fi
    run_benchmarks_istio 20 49
fi