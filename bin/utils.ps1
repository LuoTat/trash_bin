function Get-RedirectedUrl {
    param (
        [string]$url    # 需要检查的 URL
    )

    $handler = New-Object System.Net.Http.HttpClientHandler
    $handler.AllowAutoRedirect = $false
    $client = New-Object System.Net.Http.HttpClient($handler)
    $client.DefaultRequestHeaders.UserAgent.ParseAdd(
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0"
    )

    # 获取重定向 URL
    $response = $client.GetAsync($url).Result

    if ($response.StatusCode -notin 301, 302, 303, 307, 308) {
        throw "Unexpected status code $($response.StatusCode) from $url"
    }

    $redirectUrl = $response.Headers.Location.AbsoluteUri

    if ($redirectUrl) {
        return $redirectUrl
    }
    else {
        throw "Redirect response has no Location header: $url"
    }
}