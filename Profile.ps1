Function Prompt {
    $Cwd = (Get-Location).Path
    $CwdArray = $Cwd.split('\')
    $CwdLength = $CwdArray.Count
    $Disk = $CwdArray[0]
    $CurrentPath = "$($CwdArray[$CwdLength-2])\$($CwdArray[$CwdLength-1])"
    Write-Host -NoNewLine -ForeGroundColor Black -BackGroundColor DarkCyan " $(Get-Date -Format("yyyy-MM-dd hh:mm:ss.fff")) "
    Write-Host -ForeGroundColor Black -BackGroundColor DarkGreen " $($Disk) $($CurrentPath) "
    Write-Host "Don't Panic > " -NoNewLine
    return " "
}