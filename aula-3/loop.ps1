$endpoints = @(
    "http://localhost:8080/",
    "http://localhost:8081/users/2",
    "http://localhost:8082/user-details/2",
    "http://localhost:8080/test",
    "http://localhost:8081/users/1",
    "http://localhost:8082/user-details/1",
    "http://localhost:8080/fiap",
    "http://localhost:8081/users/99",
    "http://localhost:8082/user-details/99"
)

$index = 0
$total = $endpoints.Count

while ($true) {
    $url = $endpoints[$index]
    Write-Host "Requesting: $url"

    try {
        $response = Invoke-WebRequest -Uri $url -Method Get -UseBasicParsing
        Write-Host $response.Content
        Write-Host "Status: $($response.StatusCode)"
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
