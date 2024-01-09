Function Prompt {
    $PSVersion = $PsVersionTable.PsVersion.Major.ToSTring()
    $Cwd = (Get-Location).Path
    $CwdArray = $Cwd.split('\')
    $CwdLength = $CwdArray.Count
    $Disk = $CwdArray[0]
    $CurrentPath = "$($CwdArray[$CwdLength-2])\$($CwdArray[$CwdLength-1])"
    $GitBranch = try { 
        $Branch = Invoke-Expression "git branch" -ErrorAction Stop
        $Branch.substring(2, $Branch.length-2)
    } catch { $Null }
    
    $GitStatus = try { 
        $Status = Invoke-Expression "git status -s" -ErrorAction Stop
        if ($Null -ne $Status) {
            "Uncommitted changes."
        } else {
            "Up to date."
        }
    } catch { "Error connecting to repo."}

    Write-Host -NoNewLine -ForeGroundColor White -BackGroundColor Red " PS: $PSVersion "
    Write-Host -NoNewLine -ForeGroundColor Black -BackGroundColor DarkCyan " $(Get-Date -Format("yy-MM-dd hh:mm:ss")) "
    Write-Host -NoNewLine -ForeGroundColor Black -BackGroundColor DarkGreen " $($Disk):$($CurrentPath) "
    if ($GitBranch) {
       Write-Host -ForegroundColor Black -BackgroundColor DarkYellow " Branch: $GitBranch Status: $GitStatus"
    } else {
        Write-Host ""
    }
   
    Write-Host "Don't Panic > " -NoNewLine
    return " "
}

Function ConvertFrom-MD {
    param(
        $Directory
    )
    Write-Host "`r`n Evaluating MD Files."
    $MDFiles = Get-ChildItem *.md

    If ($Null -ne $Directory) {
        $MDFiles = Get-ChildItem "$Directory\*.md"
    }

    ForEach($File in $MDFiles) {
        Write-Host "   - File: $($File.FullName)"
        Invoke-Expression "md-to-pdf '$($File.FullName)'"
    }
}

Function Create-Password {
    param (
        $Length
    )

    $PwLength = 14
    if ($Length -gt 0) {
        $PwLength = $Length
    }

    $Output = ''

    While($Output.length -lt $PwLength) {
        $Output += 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()_+-='.ToCharArray() | Get-Random
    }

    return $Output
}