# Written by Darryl

function get-all-files {
    param($filter)
    # Selecting all files in directory
    $files = Get-Item *
    
    # Removing all directories from list
    $files = $files | Where-Object {($_.attributes -notlike "Directory") -and ($_.Name -clike $filter)}
    
    return $files
}

function get-input {
    param($prompt)
    $fileSearch = Read-Host -Prompt $prompt


    if ($fileSearch -eq "") {
        Write-Host "No input detected" -ForegroundColor Red
        $fileSearch = get-input $prompt
    }

    return $fileSearch
}

function print-filenames{
    param($files)

    for($i = 0; $i -lt $files.Length; $i++)
    {
        Write-Host $files[$i].Name
    }
}


function print-filenames-edit{
    param($files, $fileSearch, $replaceItem)

    for($i = 0; $i -lt $files.Length; $i++)
    {
        $temp = $files[$i].Name
        $filenamefrag = $temp -csplit $fileSearch
        
        Write-Host -NoNewline $filenamefrag[0] -ForegroundColor Yellow

        if ($filenamefrag.Length -ne 1){
            Write-Host -NoNewline $replaceItem -ForegroundColor Red
        }

        for($j = 1; $j -lt $filenamefrag.Length; $j++)
        {
            if($j -ne 1)
            {
                Write-Host -NoNewline $fileSearch -ForegroundColor Yellow
            }
    
            Write-Host -NoNewline $filenamefrag[$j] -ForegroundColor Yellow
        }

        Write-Host
    }
}

function rename-filenames{
    param($files, $fileSearch, $replaceItem)

    Write-Host "Renamed:" -ForegroundColor Green

    for($i = 0; $i -lt $files.Length; $i++)
    {
        $temp = $files[$i].Name
        $filenamefrag = $temp -csplit $fileSearch

        if ($filenamefrag.Length -eq 1){
            Write-Host $files[$i].Name -ForegroundColor Cyan
            continue
        }

        $rebuiltFilename = $filenamefrag[0]
        $rebuiltFilename += $replaceItem

        for($j = 1; $j -lt $filenamefrag.Length; $j++)
        {
            if($j -ne 1)
            {
                $rebuiltFilename += $fileSearch
            }
    
            $rebuiltFilename += $filenamefrag[$j]
        }

        $files[$i] | Rename-Item -NewName $rebuiltFilename
        Write-Host "$rebuiltFilename" -ForegroundColor Cyan
    }
}



# Initial Filtering
$fileSearch = get-input "Filenames to search"
Write-Host

$files = @(get-all-files("*" + $fileSearch +"*"))

Write-Host "Files Found:" -ForegroundColor Green
print-filenames $files
Write-Host


# Get Proposed Change
$toReplace = get-input "String to replace"
print-filenames-edit $files $toReplace $toReplace

# Read Proposed Changes
Write-Host
$replace = Read-Host "Replacement"
Write-Host "Files to Rename:" -ForegroundColor Green
print-filenames-edit $files $toReplace $replace
Write-Host


# Confirm Changes
while($true){
    $confirmrn = get-input "Confirm change (y/n)"
    if ($confirmrn -like "y*" -or $confirmrn -like "n*"){
        break
    }

    Write-Host "Invalid response"
}

if ($confirmrn -like 'n*') {
    exit
}


# Write Changes
rename-filenames $files $toReplace $replace