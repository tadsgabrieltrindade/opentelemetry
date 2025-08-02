#!/bin/bash

endpoints=(
    "http://localhost:8080/"
    "http://localhost:8081/users/2"
    "http://localhost:8082/user-details/2"
    "http://localhost:8080/test"
    "http://localhost:8081/users/1"
    "http://localhost:8082/user-details/1"
    "http://localhost:8080/fiap"
    "http://localhost:8081/users/99"
    "http://localhost:8082/user-details/99"
)

index=0
total=${#endpoints[@]}

while true; do
    url=${endpoints[$index]}
    echo "Requesting: $url"
    curl -s -w "\nStatus: %{http_code}\n" "$url" || echo "Erro ao acessar $url"

    index=$(( (index + 1) % total ))
    sleep 1
done