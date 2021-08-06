# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
param ($InputFile, $Direction = "Both");


function RunMain {
    param([string] $InputFile, [string] $Direction);

    Write-Output("Start loading file $($InputFile) direction $($Direction)");

    if([string]::IsNullOrEmpty($InputFile)){ Write-Error("Input file not supplied"); return;}

    [string[]] $ips = Get-Content $InputFile;

    if($ips.Count -eq 0){ Write-Error("File is empty"); return;}
    if($ips.Count -gt 10000){ Write-Error("Too many items (>10000) in list"); return;}

    [string] $rulename = [System.IO.Path]::GetFileNameWithoutExtension($InputFile);
    if($Direction -eq "Both"){
        UpsertRule -RuleDisplayName $rulename -Direction "Outbound" -RemoteAddressList $ips;
        UpsertRule -RuleDisplayName $rulename -Direction "Inbound" -RemoteAddressList $ips;
    }
    else{
        UpsertRule -RuleDisplayName $rulename -Direction $Direction -RemoteAddressList $ips;
    }
    Write-Output("Done.");
}

function UpsertRule{
    param ([string] $RuleDisplayName, [string] $Direction, [string[]] $RemoteAddressList);

    [string] $rulename = -join($RuleDisplayName, "_", $Direction);
    $fwRule = Get-NetFirewallRule | Where-Object {$_.Name -eq $Rulename} | Select-Object -First 1;

    if($null -eq $fwRule){
        New-NetFirewallRule -Action Block -Direction $Direction -Enabled true -Profile Any -InterfaceType Any -Name $rulename -DisplayName $RuleDisplayName;
        Write-Output("New rule created");
    }

    Set-NetFirewallRule -Name $rulename -RemoteAddress $RemoteAddressList;
}


RunMain -InputFile $InputFile -Direction $Direction;