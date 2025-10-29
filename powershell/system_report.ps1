# System Report Script — Windows PowerShell

Write-Host "System Summary for $env:COMPUTERNAME" -ForegroundColor Cyan
$now = Get-Date -Format 'HH:mm tt on dddd'
Write-Host "It is $now`n"

# CPU
$cpu = Get-CimInstance Win32_Processor
Write-Host "CPU:" $cpu.Name "($($cpu.NumberOfCores) cores @ $($cpu.MaxClockSpeed) MHz)`n"

# Memory
$mem = Get-CimInstance Win32_PhysicalMemory
$total = ($mem | Measure-Object -Property Capacity -Sum).Sum / 1GB
Write-Host "Total RAM:" [math]::Round($total,2) "GB`n"

# OS Info
$os = Get-CimInstance Win32_OperatingSystem
Write-Host "OS:" $os.Caption "Version:" $os.Version "`n"

# GPU
$gpu = Get-CimInstance Win32_VideoController
Write-Host "GPU:" $gpu.Name "`n"

# Disk
$disk = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }
foreach ($d in $disk) {
  $free = [math]::Round(($d.FreeSpace / $d.Size) * 100, 1)
  Write-Host "Drive $($d.DeviceID): $($d.Size/1GB -as [int]) GB total, $free% free"
}

# Network
$net = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }
foreach ($n in $net) {
  Write-Host "`nNetwork Adapter:" $n.Description
  Write-Host "IP:" ($n.IPAddress -join ", ")
  Write-Host "DNS:" ($n.DNSServerSearchOrder -join ", ")
}
