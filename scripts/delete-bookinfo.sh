
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

instance="$1"
echo "Deleting bookinfo."

for i in $(seq 0 1 $instance); do
  { helm uninstall bookinfo-$i --namespace bookinfo-$i;
    kubectl delete namespace bookinfo-$i --wait; } &
done

wait

grace "kubectl get namespaces | grep bookinfo"
