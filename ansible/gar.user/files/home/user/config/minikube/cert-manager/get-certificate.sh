kubectl get secret mk-tls -o jsonpath='{.data.ca\.crt}' | base64 --decode > ca.crt
