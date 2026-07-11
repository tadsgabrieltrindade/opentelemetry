# Lista de endpoints e métodos associados (formato: "METHOD URL")
$requests = @(
  "GET http://localhost:8080/",
  "GET http://localhost:8081/users/2",
  "GET http://localhost:8082/user-details/2",
  "GET http://localhost:8081/users/1",
  "GET http://localhost:8082/user-details/1",
  "GET http://localhost:8081/users/3",
  "GET http://localhost:8082/user-details/3",
  "GET http://localhost:8080/99",
  "GET http://localhost:8081/users/error",
  "GET http://localhost:8082/user-details/fiap",
  "POST http://localhost:8081/users",
  "PATCH http://localhost:8081/users/2",
  "DELETE http://localhost:8081/users/2",
  "POST http://localhost:8082/user-details",
  "PATCH http://localhost:8082/user-details/2",
  "DELETE http://localhost:8082/user-details/2",
  "POST http://localhost:8081/users",
  "PATCH http://localhost:8081/users/2",
  "DELETE http://localhost:8081/users/2",
  "POST http://localhost:8082/user-details",
  "PATCH http://localhost:8082/user-details/2",
  "DELETE http://localhost:8082/user-details/2"
)

# Dados de exemplo para POST e PATCH
$postData = '{"name": "João", "email": "joao@example.com"}'
$patchData = '{"email": "novoemail@example.com"}'

$index = 0
$total = $requests.Count

while ($true) {
  $entry = $requests[$index]
  $method, $url = $entry -split ' ', 2

  Write-Host "`nRequesting [$method] $url"

  try {
    switch ($method) {
      "GET" {
        $response = Invoke-WebRequest -Uri $url -Method Get -UseBasicParsing
      }
      "POST" {
        $response = Invoke-WebRequest -Uri $url -Method Post -ContentType "application/json" -Body $postData -UseBasicParsing
      }
      "PATCH" {
        $response = Invoke-WebRequest -Uri $url -Method Patch -ContentType "application/json" -Body $patchData -UseBasicParsing
      }
      "DELETE" {
        $response = Invoke-WebRequest -Uri $url -Method Delete -UseBasicParsing
      }
      default {
        Write-Host "Método HTTP não suportado: $method"
        $response = $null
      }
    }

    if ($response) {
      Write-Host $response.Content
      Write-Host "Status: $($response.StatusCode)"
    }
  } catch {
    if ($_.Exception.Response) {
      Write-Host "Status: $([int]$_.Exception.Response.StatusCode)"
    } else {
      Write-Host "Erro ao acessar $url"
    }
  }

  $index = ($index + 1) % $total
  Start-Sleep -Seconds 1
}
