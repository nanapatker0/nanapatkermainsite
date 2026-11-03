$root = $PSScriptRoot
$uri = 'http://localhost:8080/'
$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add($uri)
$listener.Start()

Write-Host "Serving $root at $uri"

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $requestPath = $context.Request.Url.AbsolutePath

    $relative = $requestPath.TrimStart('/')
    $resolved = if ([string]::IsNullOrWhiteSpace($relative)) { Join-Path $root 'i\vihaan-weds-kavya.html' } else { Join-Path $root $relative }

    if (-not (Test-Path $resolved -PathType Leaf)) {
        if ([string]::IsNullOrWhiteSpace($relative)) {
            $resolved = Join-Path $root 'i\vihaan-weds-kavya.html'
        } else {
            $response = $context.Response
            $response.StatusCode = 404
            $response.ContentType = 'text/plain'
            $buffer = [System.Text.Encoding]::UTF8.GetBytes('Not found')
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
            $response.OutputStream.Close()
            continue
        }
    }

    $extension = [System.IO.Path]::GetExtension($resolved).ToLowerInvariant()
    $mime = switch ($extension) {
        '.html' { 'text/html; charset=utf-8' }
        '.js' { 'application/javascript; charset=utf-8' }
        '.css' { 'text/css; charset=utf-8' }
        '.jpg' { 'image/jpeg' }
        '.jpeg' { 'image/jpeg' }
        '.png' { 'image/png' }
        '.gif' { 'image/gif' }
        '.svg' { 'image/svg+xml' }
        '.webp' { 'image/webp' }
        '.m4a' { 'audio/mp4' }
        '.json' { 'application/json; charset=utf-8' }
        default { 'application/octet-stream' }
    }

    $response = $context.Response
    $response.StatusCode = 200
    $response.ContentType = $mime

    $bytes = [System.IO.File]::ReadAllBytes($resolved)
    $response.ContentLength64 = $bytes.Length
    $response.OutputStream.Write($bytes, 0, $bytes.Length)
    $response.OutputStream.Close()
}

$listener.Stop()
