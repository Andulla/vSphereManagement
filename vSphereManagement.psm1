﻿enum Ensure
{
    Absent
    Present
}

<#
   This resource manages the Custom Attributes within a VMware vSphere vCenter environment.
#>

[DscResource()]
class vSphereCustomAttribute
{
    [DscProperty(Key)]
    [string]$Name

    [void] Set()
    {
    }

    [bool] Test()
    {
        return $true
    }

    [vSphereCustomAttribute] Get()
    {
        $caconfig = [hashtable]::new()
        $caconfig.Add('Name', $this.Name)
        return $caconfig
    }
}

<#
   This resource manages the Distributed Switches within a VMware vSphere vCenter environment.
#>

[DscResource()]
class vSphereDistributedSwitch
{
    [DscProperty(Key)]
    [string]$Name

    [void] Set()
    {
    }

    [bool] Test()
    {
        return $true
    }

    [vSphereDistributedSwitch] Get()
    {
        $dsconfig = [hashtable]::new()
        $dsconfig.Add('Name', $this.Name)
        return $dsconfig
    }
}

<#
   This resource manages the local Switches within a VMware vSphere vCenter environment.
#>

[DscResource()]
class vSphereLocalSwitch
{
    [DscProperty(Key)]
    [string]$Name

    [void] Set()
    {
    }

    [bool] Test()
    {
        return $true
    }

    [vSphereLocalSwitch] Get()
    {
        $lsconfig = [hashtable]::new()
        $lsconfig.Add('Name', $this.Name)
        return $lsconfig
    }
}

<#
   This resource manages the ResourePool within a VMware vSphere vCenter environment.
#>

[DscResource()]
class vSphereResourcePool
{
    [DscProperty(Key)]
    [string]$Name

    [void] Set()
    {
    }

    [bool] Test()
    {
        return $true
    }

    [vSphereResourcePool] Get()
    {
        $rpconfig = [hashtable]::new()
        $rpconfig.Add('Name', $this.Name)
        return $rpconfig
    }
}

<#
   This resource manages the Folder within a VMware vSphere vCenter environment.
#>

[DscResource()]
class vSphereFolder
{
    [DscProperty(Key)]
    [string]$Name

    [void] Set()
    {
    }

    [bool] Test()
    {
        return $true
    }

    [vSphereFolder] Get()
    {
        $folderconfig = [hashtable]::new()
        $folderconfig.Add('Name', $this.Name)
        return $folderconfig
    }
}

<#
   This resource manages the Datastores within a VMware vSphere vCenter environment.
#>

[DscResource()]
class vSphereDatastore
{
    [DscProperty(Key)]
    [string]$Name

    [void] Set()
    {
    }

    [bool] Test()
    {
        return $true
    }

    [vSphereDatastore] Get()
    {
        $dsconfig = [hashtable]::new()
        $dsconfig.Add('Name', $this.Name)
        return $dsconfig
    }
}

<#
   This resource manages the Clusters within a VMware vSphere vCenter environment.
#>

[DscResource()]
class vSphereCluster
{
    [DscProperty(Key)]
    [string]$Name

    [void] Set()
    {
    }

    [bool] Test()
    {
        return $true
    }

    [vSphereCluster] Get()
    {
        $clusterconfig = [hashtable]::new()
        $clusterconfig.Add('Name', $this.Name)
        return $clusterconfig
    }
}

<#
   This resource manages the Virtual Machines within a VMware vSphere vCenter environment.
#>

[DscResource()]
class vSphereVM
{
    [DscProperty(Key)]
    [string]$Name

    [void] Set()
    {
    }

    [bool] Test()
    {
        return $true
    }

    [vSphereVM] Get()
    {
        $vmconfig = [hashtable]::new()
        $vmconfig.Add('Name', $this.Name)
        return $vmconfig
    }
}

<#
   This resource manages the ESXi host within a VMware vSphere vCenter environment.
#>

[DscResource()]
class vSphereESXi
{
    [DscProperty(Key)]
    [string]$Name

    [void] Set()
    {
    }

    [bool] Test()
    {
        return $true
    }

    [vSphereESXi] Get()
    {
        $esxiconfig = [hashtable]::new()
        $esxiconfig.Add('Name', $this.Name)
        return $esxiconfig
    }
}


<#
   This resource manages the Datacenter within a VMware vSphere vCenter environment.
#>

[DscResource()]
class vSphereDatacenter
{
    [DscProperty(Key)]
    [string]$Name
    
    [DscProperty(Mandatory)]
    [Ensure] $Ensure

    [DscProperty(mandatory)]
    [string]$vCenter
    
    [DscProperty(mandatory)]
    [string]$vCenterUser
    
    [DscProperty(mandatory)]
    [string]$vCenterPW
    
    [bool]$ConnectedTovCenter

    [void] Set()
    {
      Write-Verbose "Set Function"
      try {   # Connect to vCenter
        if (!$this.ConnectedTovCenter) { $this.ConnectMeTovSphere() }
        if ($this.Ensure -eq [Ensure]::Present) {

                $dc = Get-Datacenter -Name $this.Name -verbose:$false -ErrorAction SilentlyContinue | select -First 1

                if ($dc -eq $null) {
                    Write-Verbose "Creating Datcenter: $($this.Name)"
                    $result = $this.CreateDatacenter()
                    if ($result -eq $true) {
                        Write-Verbose 'Datacenter created successfully'
                    } else {
                        throw 'There was a problem creating the Datacenter'
                    }
                } 
                else {
                    # Nothing else to reconfigure for a Datacenter
                }
            } else {
                # Not removing a datacenter. Only throw a message for that.
                Write-Verbose "Removing Datacenter: $($this.Name)"
            }

        } catch {
            Write-Verbose 'There was a problem setting the resource'
            Write-Verbose "$($_.InvocationInfo.ScriptName)($($_.InvocationInfo.ScriptLineNumber)): $($_.InvocationInfo.Line)"
        }
    }

    [bool] Test()
    {
        $checksPassed = $true
        Write-Verbose "Test Function"
        try {
            if (!$this.ConnectedTovCenter) { $this.ConnectMeTovSphere() }

            $datacenter = Get-Datacenter -Name $this.Name -verbose:$false -ErrorAction SilentlyContinue | select -First 1

            # Datacenter exists
            if ($datacenter -ne $null) {
                Write-Verbose -Message "Datacenter: $($this.Name) was found"
            } else {
                Write-Verbose -Message "Datacenter: $($this.Name) was not found"
            }
            if ($this.Ensure -eq [Ensure]::Present) {
                if ($datacenter -eq $null) { return $false }
            } else {
                if ($datacenter -eq $null) { return $true } else { return $false }
            }

            if ($checksPassed -eq $true) {
                Write-Verbose 'All Checks passed'
                return $true
            } else {
                Write-Verbose 'All Checks did not pass'
                return $false
            }
            
        } catch {
            Write-Verbose 'There was a problem testing the resource'
            Write-Verbose "$($_.InvocationInfo.ScriptName)($($_.InvocationInfo.ScriptLineNumber)): $($_.InvocationInfo.Line)"
            return $false
        }
    }

    [vSphereDatacenter] Get()
    {  
        Write-Verbose "Get Function"
        $dcconfig = [hashtable]::new()
        $dcconfig.Add('Name', $this.Name)
        $dcconfig.Add('Ensure', $this.Ensure)

        # Connect to vCenter
        if (!$this.ConnectedTovCenter) { $this.ConnectMeTovSphere() }

        $dc = FindDC -Name $this.VMName

        try {
            if ($dc -ne $null) {
                $dcconfig.Add('Ensure','Present')
            } else {
                $dcconfig.Add('Ensure','Absent')
            }
        } catch {
            $exception = $_
            Write-Verbose 'Error occurred'
            while ($exception.InnerException -ne $null) {
                $exception = $exception.InnerException
                Write-Verbose $exception.message
            }
        }
        return $dcconfig
    }
    
    # DSC Resource helpers

    [bool] FindDC([string]$Name)
    {
        if (!$this.ConnectedTovCenter) { ConnectMeTovSphere }

        Write-Verbose "Trying to find Datacenter: $Name"
        $dc = Get-Datacenter -Name $Name -verbose:$false -ErrorAction SilentlyContinue
        if ($dc -ne $null) {
            return $true
        } else {
            return $false
        }
    }
    
    
  
     [bool] CreateDatacenter() {
        
        $dc = $null
        Write-Verbose "Datacenter: $($this.Name)"

        $folder = Get-Folder -Name Datacenters

        $dc = New-Datacenter -Name $this.Name `
                             -Location $folder `
                              -verbose:$false
        
        if ($dc -ne $null) 
        {
            return $true
        } else 
        {
            return $false
        }
    }

    [bool] ConnectMeTovSphere()
    {
        if (!$this.ConnectedTovCenter)
        {
            if ((Get-PSSnapin -Registered -Name 'VMware.VimAutomation.Core') -ne $null)
            {
                try {
                    Add-PSSnapin 'VMware.VimAutomation.Core'
                    Write-Verbose 'Added VMware.VimAutomation.Core snapin'
                } catch {
                    throw 'There was a problem loading snapin Vmware.VimAutomation.Core.'
                }
            } else {
                throw 'Vmware.VimAutmation.Core snapin is not installed on this system!'
            }

            try {
                Write-Verbose "Trying to connect to $($this.vCenter) with $($this.vCenterUser)"
                Connect-VIServer -Server $($this.vCenter) `
                                 -User $($this.vCenterUser) `
                                 -Password $($this.vCenterPW) `
                                 -Force -verbose
                Write-Verbose "Connected to vCenter: $($this.vCenter)"
                $this.ConnectedTovCenter = $true
                return $true
            } catch {
                throw "There was a problem connecting to vCenter: $($this.vCenter)"
                $this.ConnectedTovCenter = $false
                return $false
            }
        }
        return $true
    }

    
} # DSC module to manage a VMware vSphere environment with DSC and PowerCLI.