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
    param($files, $fileSearch, $replaceItem)

    for($i = 0; $i -lt $files.Length; $i++)
    {
        $temp = $files[$i].Name
        $filenamefrag = $temp -csplit $fileSearch
        
        Write-Host -NoNewline $filenamefrag[0] -ForegroundColor Yellow
        Write-Host -NoNewline $replaceItem -ForegroundColor Red

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

    for($i = 0; $i -lt $files.Length; $i++)
    {
        $temp = $files[$i].Name
        $filenamefrag = $temp -csplit $fileSearch

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
        Write-Host "Renamed: $rebuiltFilename"
    }
}



# Initial Filtering
$fileSearch = get-input "Filenames to search"
Write-Host Input is $fileSearch

$files = @(get-all-files("*" + $fileSearch +"*"))

Write-Host "Files Found:" -ForegroundColor Green
print-filenames $files $fileSearch $fileSearch

# Read Proposed Changes
Write-Host
$replace = Read-Host "String to replace with"
Write-Host "Files to Rename:" -ForegroundColor Green
print-filenames $files $fileSearch $replace
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
rename-filenames $files $fileSearch $replace