# Written by Darryl

function get-all-files ($filter){
    # Selecting all files in directory
    $files = Get-Item *
    
    # Removing all directories from list
    $files = $files | Where-Object {($_.attributes -notlike "Directory") -and ($_.Name -like $filter)}
    
    return $files
}

function get-input {
    $input = Read-Host -Prompt "Filenames to search" 

    if ($input -eq "") {
        Write-Host "No search detected" -ForegroundColor Red
        $input = get-input
    }

    return $input
}

function print-filenames($files, $input){
    for($i = 0; $i -lt $files.Length; $i++)
    {
        Write-Host $files[$i].Name -ForegroundColor Yellow
    }
}

# Initial Filtering
$input = get-input
Write-Host

$files = @(get-all-files("*" + $input +"*"))

Write-Host "Files Found:" -ForegroundColor Green
print-filenames($files)