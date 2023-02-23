{{- define "emojivotoURLs" }}
{{- $count := .Values.wrk2.app.count | int }}
{{- range $i, $e := until $count }}
        - "http://web-svc.emojivoto-{{$i}}/leaderboard"
        - "http://web-svc.emojivoto-{{$i}}/api/vote?choice=:nerd_face:"
        - "http://web-svc.emojivoto-{{$i}}/leaderboard"
        - "http://web-svc.emojivoto-{{$i}}/api/vote?choice=:see_no_evil:"
        - "http://web-svc.emojivoto-{{$i}}/leaderboard"
        - "http://web-svc.emojivoto-{{$i}}/api/vote?choice=:nerd_face:"
        - "http://web-svc.emojivoto-{{$i}}/leaderboard"
        - "http://web-svc.emojivoto-{{$i}}/api/vote?choice=:see_no_evil:"
        - "http://web-svc.emojivoto-{{$i}}/leaderboard"
        - "http://web-svc.emojivoto-{{$i}}/api/vote?choice=:nerd_face:"
        - "http://web-svc.emojivoto-{{$i}}/leaderboard"
        - "http://web-svc.emojivoto-{{$i}}/api/vote?choice=:see_no_evil:"
        - "http://web-svc.emojivoto-{{$i}}/leaderboard"
        - "http://web-svc.emojivoto-{{$i}}/api/vote?choice=:nerd_face:"
        - "http://web-svc.emojivoto-{{$i}}/leaderboard"
        - "http://web-svc.emojivoto-{{$i}}/api/vote?choice=:see_no_evil:"
        - "http://web-svc.emojivoto-{{$i}}/leaderboard"
        - "http://web-svc.emojivoto-{{$i}}/api/vote?choice=:nerd_face:"
        - "http://web-svc.emojivoto-{{$i}}/leaderboard"
        - "http://web-svc.emojivoto-{{$i}}/api/vote?choice=:see_no_evil:"
{{- end -}}
{{ end }}

{{- define "bookinfoURLs" }}
{{- $count := .Values.wrk2.app.count | int }}
{{- range $i, $e := until $count }}
        - "http://productpage.bookinfo-{{$i}}:9080/"
        - "http://productpage.bookinfo-{{$i}}:9080/"
        - "http://productpage.bookinfo-{{$i}}:9080/productpage?u=test"
        - "http://productpage.bookinfo-{{$i}}:9080/"
        - "http://productpage.bookinfo-{{$i}}:9080/"
        - "http://productpage.bookinfo-{{$i}}:9080/productpage?u=normal"
        - "http://productpage.bookinfo-{{$i}}:9080/"
        - "http://productpage.bookinfo-{{$i}}:9080/"
        - "http://productpage.bookinfo-{{$i}}:9080/"
        - "http://productpage.bookinfo-{{$i}}:9080/productpage?u=test"
        - "http://productpage.bookinfo-{{$i}}:9080/"
        - "http://productpage.bookinfo-{{$i}}:9080/productpage?u=normal"
        - "http://productpage.bookinfo-{{$i}}:9080/"
        - "http://productpage.bookinfo-{{$i}}:9080/"
        - "http://productpage.bookinfo-{{$i}}:9080/"
        - "http://productpage.bookinfo-{{$i}}:9080/"
        - "http://productpage.bookinfo-{{$i}}:9080/productpage?u=test"
        - "http://productpage.bookinfo-{{$i}}:9080/"
        - "http://productpage.bookinfo-{{$i}}:9080/productpage?u=normal"
        - "http://productpage.bookinfo-{{$i}}:9080/"
{{- end -}}
{{ end }}

{{- define "serviceInvocationURLs" }}
{{- $count := .Values.wrk2.app.count | int }}
{{- range $i, $e := until $count }}
        - "http://invoker.invoker-{{$i}}/test01"
        - "http://invoker.invoker-{{$i}}/test02"
        - "http://invoker.invoker-{{$i}}/test03"
        - "http://invoker.invoker-{{$i}}/test04"
        - "http://invoker.invoker-{{$i}}/test05"
        - "http://invoker.invoker-{{$i}}/test06"
        - "http://invoker.invoker-{{$i}}/test07"
        - "http://invoker.invoker-{{$i}}/test08"
        - "http://invoker.invoker-{{$i}}/test09"
        - "http://invoker.invoker-{{$i}}/test10"
        - "http://invoker.invoker-{{$i}}/test11"
        - "http://invoker.invoker-{{$i}}/test12"
        - "http://invoker.invoker-{{$i}}/test13"
        - "http://invoker.invoker-{{$i}}/test14"
        - "http://invoker.invoker-{{$i}}/test15"
        - "http://invoker.invoker-{{$i}}/test16"
        - "http://invoker.invoker-{{$i}}/test17"
        - "http://invoker.invoker-{{$i}}/test18"
        - "http://invoker.invoker-{{$i}}/test19"
        - "http://invoker.invoker-{{$i}}/test20"
{{- end -}}
{{ end }}

{{- define "daprKVURLs" }}
{{- $count := .Values.wrk2.app.count | int }}
{{- range $i, $e := until $count }}
        - "http://dapr-kv.dapr-kv-{{$i}}/read/test"
        - "http://dapr-kv.dapr-kv-{{$i}}/read/test"
        - "http://dapr-kv.dapr-kv-{{$i}}/read/test"
        - "http://dapr-kv.dapr-kv-{{$i}}/read/test"
        - "http://dapr-kv.dapr-kv-{{$i}}/read/test"
        - "http://dapr-kv.dapr-kv-{{$i}}/read/test"
        - "http://dapr-kv.dapr-kv-{{$i}}/read/test"
        - "http://dapr-kv.dapr-kv-{{$i}}/read/test"
        - "http://dapr-kv.dapr-kv-{{$i}}/read/test"
        - "http://dapr-kv.dapr-kv-{{$i}}/read/test"
        - "http://dapr-kv.dapr-kv-{{$i}}/read/test"
        - "http://dapr-kv.dapr-kv-{{$i}}/read/test"
        - "http://dapr-kv.dapr-kv-{{$i}}/read/test"
        - "http://dapr-kv.dapr-kv-{{$i}}/read/test"
        - "http://dapr-kv.dapr-kv-{{$i}}/read/test"
        - "http://dapr-kv.dapr-kv-{{$i}}/read/test"
        - "http://dapr-kv.dapr-kv-{{$i}}/read/test"
        - "http://dapr-kv.dapr-kv-{{$i}}/read/test"
        - "http://dapr-kv.dapr-kv-{{$i}}/read/test"
        - "http://dapr-kv.dapr-kv-{{$i}}/read/test"
{{- end -}}
{{ end }}
