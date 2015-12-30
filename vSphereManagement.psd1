@{

# Script module or binary module file associated with this manifest.
RootModule = '.\vSphereManagement.psm1'

#DscResourcesToExport = 'vSphereDatacenter'
DscResourcesToExport = @('vSphereDatacenter','vSphereFolder')

# Version number of this module.
ModuleVersion = '1.0'

# ID used to uniquely identify this module
GUID = '784d5d68-83b5-4c43-9120-a4267908360c'

# Author of this module
Author = 'Andreas Wilke'

# Company or vendor of this module
CompanyName = 'Unknown'

# Copyright statement for this module
Copyright = '(c) 2015 Andreas Wilke. All rights reserved.'

# Description of the functionality provided by this module
# Description = ''

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.0'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''
}