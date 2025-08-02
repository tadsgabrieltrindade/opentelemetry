#!/bin/bash

# Lista de endpoints e métodos associados (formato: "METHOD URL")
requests=(
  "GET http://localhost:8080/"
  "GET http://localhost:8081/users/2"
  "GET http://localhost:8082/user-details/2"
  "GET http://localhost:8081/users/1"
  "GET http://localhost:8082/user-details/1"
  "GET http://localhost:8081/users/3"
  "GET http://localhost:8082/user-details/3"
  "GET http://localhost:8080/99"
  "GET http://localhost:8081/users/error"
  "GET http://localhost:8082/user-details/fiap"
  "POST http://localhost:8081/users"
  "PATCH http://localhost:8081/users/2"
  "DELETE http://localhost:8081/users/2"
  "POST http://localhost:8082/user-details"
  "PATCH http://localhost:8082/user-details/2"
  "DELETE http://localhost:8082/user-details/2"
  "POST http://localhost:8081/users"
  "PATCH http://localhost:8081/users/2"
  "DELETE http://localhost:8081/users/2"
  "POST http://localhost:8082/user-details"
  "PATCH http://localhost:8082/user-details/2"
  "DELETE http://localhost:8082/user-details/2"
)

# Dados de exemplo para POST e PATCH
post_data='{"name": "João", "email": "joao@example.com"}'
patch_data='{"email": "novoemail@example.com"}'

index=0
total=${#requests[@]}

while true; do
  entry=${requests[$index]}
  method=$(echo $entry | awk '{print $1}')
  url=$(echo $entry | awk '{print $2}')

  echo -e "\nRequesting [$method] $url"

  case "$method" in
    GET)
      curl -s -X GET -w "\nStatus: %{http_code}\n" "$url"
      ;;
    POST)
      curl -s -X POST -H "Content-Type: application/json" -d "$post_data" -w "\nStatus: %{http_code}\n" "$url"
      ;;
    PATCH)
      curl -s -X PATCH -H "Content-Type: application/json" -d "$patch_data" -w "\nStatus: %{http_code}\n" "$url"
      ;;
    DELETE)
      curl -s -X DELETE -w "\nStatus: %{http_code}\n" "$url"
      ;;
    *)
      echo "Método HTTP não suportado: $method"
      ;;
  esac

  index=$(( (index + 1) % total ))
  sleep 1
done