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
    return $input
}

# Initial Filtering
$input = get-input

get-all-files("*" + $input +"*")