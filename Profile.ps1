Function Prompt {
    # Variables
    $PsVersion = $PsVersionTable.PsVersion.Major.ToSTring()
    $PsWriteOut = " PS: $PSVersion "
    $DateWriteOut = " $(Get-Date -Format("yyyy-MM-dd hh:mm:ss"))"
    $PwdWriteOut = " "
    $GitWriteOut = $Null 

    # Logic for getting Path by OS
    if ($IsWindows) {
        $Cwd = (Get-Location).Path
        $CwdArray = $Cwd.split('\')
        $CwdLength = $CwdArray.Count
        $Disk = $CwdArray[0]
        $PwdWriteOut = " $Disk $( $CwdArray[$CwdLength-2])\$($CwdArray[$CwdLength-1]) "
    } elseif ($IsLinux -or $IsMacOs) {
        $Cwd = (Get-Location).Path
        $CwdArray = $Cwd.split('/')
        $CwdLength = $CwdArray.Count
        $PwdWriteOut = " $($CwdArray[$CwdLength-2])/$($CwdArray[$CwdLength-1]) "
    }

    # Logic for getting Git Branch Status
    $BranchInfo = try { 
        $Branch = Invoke-Expression "git branch" -ErrorAction Stop
        "Branch: $($Branch.substring(2, $Branch.length-2))"
    } catch { $Null }
    $BranchStatus += try { 
        $Status = Invoke-Expression "git status -s" -ErrorAction Stop
        if ($Null -ne $Status) {
            "Status: Uncommitted changes."
        } else {
            "Status: Up to date."
        }
    } catch { "Error connecting to repo."}
    if ($BranchInfo) { $GitWriteOut = " $BranchInfo $BranchStatus "}

   # Prompt Output 
    Write-Host -NoNewLine -ForeGroundColor White -BackGroundColor Red $PsWriteOut
    Write-Host -NoNewLine -ForeGroundColor Black -BackGroundColor DarkCyan $DateWriteOut 
    Write-Host -NoNewLine -ForeGroundColor Black -BackGroundColor DarkGreen $PwdWriteOut 
    Write-Host -ForegroundColor Black -BackgroundColor DarkYellow $GitWriteOut
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

    $PwLength = 20
    if ($Length -gt 0) {
        $PwLength = $Length
    }
    $Output = ''

    try { 
        # Get Word List
        $WordListUri = "https://raw.githubusercontent.com/oprogramador/most-common-words-by-language/master/src/resources/english.txt"
        $RawList = Invoke-WebRequest -Method Get -Uri $WordListUri 
        $WordList = $RawList.Content.split("`n") | Where-Object { $_.Length -in @(4,5,6) }
        
        While($Output.Length -le $PwLength) {
            $Output += $WordList | Get-Random
            $Output += "-"
        }
        $Output = $Output -replace "-$", ""

        $NumReplaceList = 'eiot'.ToCharArray()
        $NumReplacer = $NumReplaceList | Where-Object { $_ -in $Output.ToCharArray() }
        $NumReplacer = $NumReplacer | Get-Random
        Switch ($NumReplacer) {
            "e" { $Output = $Output -replace 'e', '3'; break;}
            "i" { $Output = $Output -replace 'i', '1'; break;}
            "o" { $Output = $Output -replace 'o', '0'; break;}
            "t" { $Output = $Output -replace 't', '7'; break;}
        }

        $AlphaReplaceList = 'ahls'.ToCharArray()
        $AlphaReplacer = $AlphaReplaceList | Where-Object { $_ -in $Output.ToCharArray() }
        $AlphaReplacer = $AlphaReplacer | Get-Random
        Switch ($AlphaReplacer) {
            "a" { $Output = $Output -replace 'a', '@'}
            "h" { $Output = $Output -replace 'h', '#'}
            "l" { $Output = $Output -replace 'l', '!'}
            "s" { $Output = $Output -replace 's', '$'}
        }
    } catch {
        Write-Error $_
        # could not get word list
        $CharList = 'abcdefghijklmnopqrstuvwxyz'
        $CharList += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        $CharList += '1234567890'
        $CharList += '!@#$%^&*()-=_+[]{};:,./<>?'
        While($Output.length -lt $PwLength) {
            $Output += $CharList.ToCharArray() | Get-Random
        }
    }

    return $Output
}
