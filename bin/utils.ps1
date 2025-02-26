function Get-RedirectedVersion {
    param (
        [string]$url,            # 需要检查的 URL
        [string]$regexPattern    # 用于匹配版本号的正则表达式
    )

    try
    {
        # 发送 HEAD 请求，获取重定向 URL
        $response = Invoke-WebRequest -Uri $url -Method Head -ErrorAction Stop

        if ($response.StatusCode -eq 200) 
        {
            $redirectUrl = $response.BaseResponse.ResponseUri.AbsoluteUri

            # 使用正则表达式匹配版本号
            if ($redirectUrl -match $regexPattern)
            {
                return $Matches[1]  # 返回匹配到的版本号
            }
            else
            {
                throw "Failed to extract version number from redirect URL: $redirectUrl"
            }
        } 
        else
        {
            throw "Request failed with status code $($response.StatusCode)"
        }
    } 
    catch
    {
        throw "An error occurred: $_"
    }
}