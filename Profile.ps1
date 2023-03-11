Function Prompt {
    $PSVersion = $PsVersionTable.PsVersion.ToSTring()
    $Cwd = (Get-Location).Path
    $CwdArray = $Cwd.split('\')
    $CwdLength = $CwdArray.Count
    $Disk = $CwdArray[0]
    $CurrentPath = "$($CwdArray[$CwdLength-2])\$($CwdArray[$CwdLength-1])"
    $GitBranch = try { 
        $Branch = Invoke-Expression "git branch" -ErrorAction Stop
        Write-Host $Branch
        $Branch.substring(2, $Branch.length-2)
    } catch { $Null }
    
    $GitStatus = try { 
        $Status = Invoke-Expression "git status -s" -ErrorAction Stop
        if ($Null -ne $Status) {
            "Unpushed changes."
        } else {
            "Up to date."
        }
    } catch { "Error connecting to repo."}

    Write-Host -NoNewLine -ForeGroundColor White -BackGroundColor Red " PS: $PSVersion "
    Write-Host -NoNewLine -ForeGroundColor Black -BackGroundColor DarkCyan " $(Get-Date -Format("yyyy-MM-dd hh:mm:ss.fff")) "
    Write-Host -NoNewLine -ForeGroundColor Black -BackGroundColor DarkGreen " $($Disk) $($CurrentPath) "
    if ($GitBranch) {
       Write-Host -ForegroundColor Black -BackgroundColor DarkYellow " Branch: $GitBranch Status: $GitStatus"
    } else {
        Write-Host ""
    }
   
    Write-Host "Don't Panic > " -NoNewLine
    return " "
}