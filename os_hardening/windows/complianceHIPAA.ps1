##This script backs up registry hives before any keys are added or updated and then sets the recommended values to meet HIPAA compliance##
#https://github.com/OrganizedMayhem/PowerShell-Compliance-Scripts/blob/master/Compliance.ps1

#Line 3334 starts Additional Changes
mkdir C:\Backup-Script

reg export HKLM\Software C:\Backup-Script\SystemBackup.reg
#Creates Green HIPAA Directory for Reg Backups


#Backs Up Registry before changes are made


## 1.21 1198  Audit: Audit the use of backup and restore privilege setting (Critical)
$registrypath = "HKLM:/SYSTEM/CurrentControlSet/Control/Lsa"
$name = "FullPrivilegeAuditing"
$value = "00"

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## 1.24 1358 Retention Method for Application Log
$registrypath = "HKLM:/System/CurrentControlSet/Services/Eventlog/Application"
$name = "DefaultInboundAction"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## 1.25 1391 Recover Console: Allow Automatic Administrative Logon

$registrypath = "HKLM:/Software/Microsoft/Windows NT/CurrentVersion/Setup/RecoveryConsole"
$name = "SecurityLevel"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      New-Item -Path $registrypath
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (1.26) 1392 Recovery console: Allow floppy copy and access to all drives and all folders

$registrypath = "HKLM:/Software/Microsoft/Windows NT/CurrentVersion/Setup/RecoveryConsole"
$name = "SetCommand"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      New-Item -Path $registrypath
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (1.35) 4050  'SQL Server VSS Writer' service
#Expected value is 4 (Disabled), Currently Set to Automatic (2)
$registrypath = "HKLM:/System/CurrentControlSet/Services/SqlWriter"
$name = "Start"
$value = 2

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath   
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (2.1) 1156  'Audit: Shut Down system immediately if unable to log security audits
#
$registrypath = "HKLM:/System/CurrentControlSet/Control/Lsa"
$name = "CrashOnAuditFail"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (2.2) 1170 MSS: (AutoReboot) Allow Windows to automatically restart after a system crash
# 0 = Disabled, 1 = Enabled, Key not found are all acceptable
$registrypath = "HKLM:/System/CurrentControlSet/Control/CrashControl"
$name = "AutoReboot"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (2.6) 3786  Microsoft 'Volume Shadow Copy Service Provider' service
# Automatic (2), Automatic Delayed Start (21), Manual (3), Disabled (4) - All are acceptable
$registrypath = "HKLM:System/CurrentControlSet/Services/swprv"
$name = "Start"
$value = 3

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (2.9) 8441  'Hyper-V Volume Shadow Copy Requestor' Service
# Automatic (2), Automatic Delayed Start (21), Manual (3), Disabled (4), *Manual is expected
$registrypath = "HKLM:System/CurrentControlSet/Services/vmicvss"
$name = "Start"
$value = 3

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (2.10) 8457  Microsoft File Server Shadow Copy Agent
# Automatic (2), Automatic Delayed Start (21), Manual (3), Disabled (4) - All are acceptable
$registrypath = "HKLM:/System/CurrentControlSet/Services/fssagent"
$name = "Start"
$value = 3

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (2.11) 8686  Data Duplication Volume Shadow Copy
# Automatic (2), Automatic Delayed Start (21), Manual (3), Disabled (4) - All are acceptable
$registrypath = "HKLM:/System/CurrentControlSet/Services/ddpvssvc"
$name = "Start"
$value = 4

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (4.4) 3724 Performance Logs and Alerts service
# (3) is expected
$registrypath = "HKLM:/System/CurrentControlSet/Services/pla"
$name = "Start"
$value = 3

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (4.73) 3731 'System Event Notification' service
# Expected Value is Automatic (2)
$registrypath = "HKLM:/System/CurrentControlSet/Services/SENS"
$name = "Start"
$value = 2

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (4.74) 3962 Windows Firewall: Display a notification (Domain)
#
$registrypath = "HKLM:/Software/Policies/Microsoft/WindowsFirewall/DomainProfile"
$name = "DisableNotifications"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (4.75) 3964  'Windows Firewall: Display a notification (Private)' setting
#
$registrypath = "HKLM:/Software/Policies/Microsoft/WindowsFirewall/PrivateProfile"
$name = "DisableNotifications"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (4.76) 3965 Windows Firewall: Display a notification (Public)
#
$registrypath = "HKLM:/Software/Policies/Microsoft/WindowsFirewall/PublicProfile"
$name = "DisableNotifications"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

##(11.42) 3927 Install Updates and Shut Down' option within the 'Shut Down Windows Dialog Box Setting

$registrypath = "HKLM:/Software/Policies/Microsoft/Windows/WindowsUpdate/AU"
$name = "NoAUShutdownOption"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

##  (11.45) 7529 Windows 'Automatic Updates' (WSUS) setting

$registrypath = "HKLM:/Software/Policies/Microsoft/Windows/WindowsUpdate/AU"
$name = "AUOptions"
$value = 3

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

##  (13.4) 3920 Turn off Internet download for Web publishing and online ordering wizards

$registrypath = "HKLM:/Software/Microsoft/Windows/CurrentVersion/Policies/Explorer"
$name = "NoWebServices"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## ##  (13.4) 3920 Turn off Internet download for Web publishing and online ordering wizards
$registrypath = "HKLM:/Software/Microsoft/Windows/CurrentVersion/Policies/Explorer"
$name = "NoWebServices"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (13.5) 3922 Turn off downloading of print drivers over HTTP
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows NT/Printers"
$name = "DisableWebPnPDownload"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (14.28) 4156  'Notify antivirus programs when opening attachments' Group Policy
$registrypath = "HKLM:/Software/Microsoft/Windows/CurrentVersion/Policies/Attachments"
$name = "ScanWithAntiVirus"
$value = 3

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }



## (14.50) 8188  'Boot-Start Driver Initialization Policy' setting
# Good, Unknown and bad but critical (3) is expected
$registrypath = "HKLM:/System/CurrentControlSet/Policies/EarlyLaunch"
$name = "DriverLoadPolicy"
$value = 3

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $valuee
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (14.52) 8273 Turn off Data Execution Prevention for Explorer
# Disabled (0), Enabled (1), Not configured. All are acceptable
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows/Explorer"
$name = "NoDataExecutionPrevention"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (17.1) 1181  'Simple Network Management Protocol (SNMP)' service (Windows)
# Disabled (4) or not configured are the expected settings
$registrypath = "HKLM:/System/CurrentControlSet/Services/SNMP"
$name = "Start"
$value = 4

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (17.8) 8233 Network Security:Restrict NTLM: Audit Incoming NTLM Traffic
# Disabled (0), Enable Auditing for Domain Accounts (1), Enable Auditing for all accounts (2), Not configured...All are acceptable
$registrypath = "HKLM:/System/CurrentControlSet/Control/LSA/MSV1_0"
$name = "AutidReceivingNTLMTraffic"
$value = 2

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (17.9) 8234 Network Security:Restrict NTLM: Audit Incoming NTLM Authentication in this Domain
# Disable (0), Enable for Domain accounts to domain servers (1), Enable for Domain Accounts (3), Enable for Domain Servers (5), Enable All (7)..all acceptable
$registrypath = "HKLM:/System/CurrentControlSet/Services/NetLogon/Parameters"
$name = "AuditNTLMInDomain"
$value = 7

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (17.11) 8244 Configure 'Network Security:Restrict NTLM: NTLM authentication in this domain'
# Must be set. Disable (0), Deny for domain acct to domain servers (1), Deny for domain accts (3), Deny for Domain Servers (5), Deny all (7)
$registrypath = "HKLM:/System/CurrentControlSet/Services/NetLogon/Parameters"
$name = "RestrictNTLMInDomain"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (18.1) 1463 MSS: (WarningLevel) Percentage threshold for the security event log at which the system will generate a warning
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/Eventlog/Security"
$name = "WarningLevel"
$value = 45

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


##  (20.2) 4741  'MSS: (DisableIPSourceRoutingIPv6) IP source routing protection level (protects against packet spoofing)'
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/Tcpip6/Parameters"
$name = "DisableIPSourceRouting"
$value = 2

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (20.17) 1172 MSS: (DisableIPSourceRouting) IP source routing protection level (protects against packet spoofing)
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/Tcpip/Parameters"
$name = "DisableIPSourceRouting"
$value = 2

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (20.18) 1193 MSS: Allow ICMP redirects to override OSPF generated routes (EnableICMPRedirect)
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/Tcpip/Parameters"
$name = "EnableICMPRedirect"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (20.27) 8243 Configure Network Security:Restrict NTLM: Outgoing NTLM traffic to remote servers
#  Allow All (0), Audit all (1), Deny All(2), Not configured, are all acceptable

$registrypath = "HKLM:/System/CurrentControlSet/Control/Lsa/MSV1_0"
$name = "RestrictSendingNTLMTraffic"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (20.29) 1177 Enable IPSec to protect Kerberos RSVP Traffic (NoDefaultExempt)' registry
$registrypath = "HKLM:/System/CurrentControlSet/Services/IPSec"
$name = "NoDefaultExempt"
$value = 

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (20.30) 1184 MSS: (PerformRouterDiscovery) Allow IRDP to detect and configure Default Gateway Access (Could lead to DoS)
# Disabled (0), Enabled (1), Enabled only if DHCP sends the Perform Router Discovery Option (2).. All are acceptable inc not configured
$registrypath = "HKLM:/System/CurrentControlSet/Services/Tcpip/Parameters"
$name = "PerformRouterDiscovery"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (20.32) 1195 MSS: (NoNameReleaseOnDemand) Allow the computer to ignore NetBIOS name release requests except from the 'WINS servers
# 
$registrypath = "HKLM:/SYSTEM/CurrentControlSet/Services/Netbt/Parameters"
$name = "NoNameReleaseOnDemand"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (20.38) 1462 MSS: (KeepAliveTime) How often keep-alive packets are sent in milliseconds (300,000 is recommended)
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/Tcpip/Parameters"
$name = "KeepAliveTime"
$value = 300000

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (20.40) 4742 MSS: (TCPMaxDataRetransmissions) IPv6 How many times unacknowledged data is retransmitted
# Recommended setting is 1-3
$registrypath = "HKLM:/SYSTEM/CurrentControlSet/Services/Tcpip6/Parameters"
$name = "TCPMaxDataRetransmissions"
$value = 2

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (20.43) 1449  'MSS: (TcpMaxDataRetransmissions) How many times unacknowledged data is retransmitted (3 = Rec, 5 = Default)
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/Tcpip/Parameters"
$name = "TcpMaxDataRetransmissions"
$value = 2

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }
  

## (21.7) 3963  'Windows Firewall: Apply local connection security rules (Private)'
# NIST, HIPAA. 'Key not found' or Yes are required to pass
$registrypath = "HKLM:/Software/Policies/Microsoft/WindowsFirewall/PrivateProfile"
$name = "AllowLocalIPssecPolicyMerge"
$value = 

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.8) 3966  'Windows Firewall: Apply local connection security rules (Public)
# HIPAA, NIST
$registrypath = "HKLM:/Software/Policies/Microsoft/WindowsFirewall/PublicProfile"
$name = "AllowLocalIpsecPolicyMerge"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.15) 4058  'Windows Network List' service
# Expected Values to Pass (2-Automatic,21 - Automatic-Delayed, 3-Manual)
$registrypath = "HKLM:/SYSTEM/CurrentControlSet/Services/netprofm"
$name = "Start"
$value = 3

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.28) 3945 Windows Firewall: Apply local firewall rules (Domain)
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/WindowsFirewall/DomainProfile"
$name = "AllowLocalPolicyMerge"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.29) 3950 Windows Firewall: Firewall state (Public)' 
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/WindowsFirewall/PublicProfile"
$name = "EnableFirewall"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.30) 3951 Windows Firewall: Firewall state (Private)
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/WindowsFirewall/PrivateProfile"
$name = "EnableFirewall"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.31) 3952 Windows Firewall: Firewall state (Domain)
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/WindowsFirewall/DomainProfile"
$name = "EnableFirewall"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.32) 3959  'Windows Firewall: Apply local firewall rules (Private)' setting
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/WindowsFirewall/PrivateProfile"
$name = "AllowLocalPolicyMerge"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.33) 3960 Windows Firewall: Apply local firewall rules (Public)
# Block (1), Allow (0) 
$registrypath = "HKLM:/Software/Policies/Microsoft/WindowsFirewall/PublicProfile"
$name = "DefaultInboundAction"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.37) 3948 Windows Firewall: Inbound connections (Private)
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/WindowsFirewall/PrivateProfile"
$name = "DefaultInboundAction"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.38) 3949  'Windows Firewall: Inbound connections (Domain)' setting
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/WindowsFirewall/DomainProfile"
$name = "DefaultInboundAction"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.39) 5261 Windows Firewall: Allow unicast response (Private)
# 
$registrypath = "HKLM:/SOFTWARE/Policies/Microsoft/WindowsFirewall/PrivateProfile"
$name = "DisableUnicastResponsesToMulticastBroadcast"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.40) 5262 Windows Firewall: Allow unicast response (Public)
# 
$registrypath = "HKLM:/SOFTWARE/Policies/Microsoft/WindowsFirewall/PublicProfile"
$name = "DisableUnicastResponsesToMulticastBroadcast"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.49) 8157 Windows Firewall: Allow unicast response (Domain)
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/WindowsFirewall/PrivateProfile"
$name = "DefaultOutboundAction"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.52) 8164 Windows Firewall: Outbound connections (Public)
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/WindowsFirewall/PublicProfile"
$name = "DefaultOutboundAction"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.57) 8160 Windows Firewall: Log File Size (Private)
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/WindowsFirewall/PrivateProfile/Logging"
$name = "LogFileSize"
$value = 8160

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.58) 8161  Windows Firewall: Log file path and name (Private)
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/WindowsFirewall/PrivateProfile/Logging"
$name = "LogFilePath"
$value = "%systemroot%/system32/logfiles/firewall/Privatefw.log"

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.59) 8162 Windows Firewall: Log Successful Connections (Private)
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/WindowsFirewall/PrivateProfile/Logging"
$name = "LogSuccessfulConnections"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.60) 8163 Windows Firewall: Log dropped packets (Private)
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/WindowsFirewall/PrivateProfile/Logging"
$name = "LogDroppedpackets"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.61) 8165  'Windows Firewall: Log dropped packets (Public)' setting
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/WindowsFirewall/PublicProfile/Logging"
$name = "LogDroppedPackets"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.62) 8166 Windows Firewall: Log file path and name (Public)
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/WindowsFirewall/PublicProfile/Logging"
$name = "LogFilePath"
$value = "%systemroot%/system32/logfiles/firewall/Publicfw.log"

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.63) 8167  'Windows Firewall: Log Successful Connections (Public)' setting
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/WindowsFirewall/PublicProfile/Logging"
$name = "LogSuccessfulConnections"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.64) 8168 Windows Firewall: Log File Size (Public)
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/WindowsFirewall/PublicProfile/Logging"
$name = "LogFileSize"
$value = 16384

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.65) 8384 Windows Firewall Service
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/MpsSvc"
$name = "Start"
$value = 2

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.69) 5352 WLAN AutoConfig
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/WLANSVC"
$name = "Start"
$value = 2

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.75) 1153  Network Access: Do not allow Anonymous Enumeration of SAM Accounts & Shares
# 
$registrypath = "HKLM:/System/CurrentControlSet/Control/LSA"
$name = "RestrictAnonymous"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (21.76) 1169 MSS: (AutoAdminLogon) Enable Automatic Logon (not recommended)
# 
$registrypath = "HKLM:/Software/Microsoft/Windows NT/CurrentVersion/Winlogon"
$name = "AutoAdminLogon"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }



## (21.77) 1196 MSS: (ScreenSaverGracePeriod) The time in seconds before the screen saver grace period expires
# 
$registrypath = "HKLM:/Software/Microsoft/Windows NT/CurrentVersion/WinLogon"
$name = "ScreenSaverGracePeriod"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (21.78) 1197  'Network access: Do not allow anonymous enumeration of SAM accounts'
# 
$registrypath = "HKLM:/System/CurrentControlSet/Control/LSA"
$name = "RestrictAnonymousSAM"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (21.79) 1377 Interactive Logon: Require Domain Controller authentication to unlock
# 
$registrypath = "HKLM:/Software/Microsoft/Windows NT/CurrentVersion/WinLogon"
$name = "ForceUnlockLogon"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.80) 1378 Interactive Logon: Smart Card Removal Behavior
# 
$registrypath = "HKLM:/Software/Microsoft/Windows NT/CurrentVersion/WinLogon"
$name = "ScRemoveOption"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.81) 1383 Network Access: Let Everyone permissions apply to anonymous users
# 
$registrypath = "HKLM:/System/CurrentControlSet/Control/LSA"
$name = "EveroneIncludesAnonymous"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.82) 1386 Network Access: Sharing and security model for local accounts
# 
$registrypath = "HKLM:/System/CurrentControlSet/Control/LSA"
$name = "ForceGuest"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.83) 1387 Network Security: LAN Manager Authentication Level
# 
$registrypath = "HKLM:/System/CurrentControlSet/Control/Lsa"
$name = "LmCompatibilityLevel"
$value = 5

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.84) 1514 Restrictions for Unauthenticated RPC clients
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows NT/RPC"
$name = "RestrictRemoteClients"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.85) 2605 User Account Control: Behavior of the elevation prompt for standard users
# 
$registrypath = "HKLM:/Software/Microsoft/Windows/CurrentVersion/Policies/System"
$name = "ConsentPromptBehaviorUser"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

##  (21.88) 3891 Always prompt for password upon connection' setting (Terminal Services)
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows NT/Terminal Services"
$name = "fPromptForPassword"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

##  (21.89) 5265 Network security: Allow LocalSystem NULL session fallback
# 
$registrypath = "HKLM:/System/CurrentControlSet/Control/LSA/MSV1_0"
$name = "allownullsessionfallback"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.90) 5266 Network security: Allow Local System to use computer identity for NTLM
# 
$registrypath = "HKLM:/System/CurrentControlSet/Control/Lsa"
$name = "UseMachineID"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath 
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.92) 2606 User Account Control: Switch to the secure desktop when prompted for elevation
# 
$registrypath = "HKLM:/Software/Microsoft/Windows/CurrentVersion/Policies/System"
$name = "PromptOnSecureDesktop"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (21.127) Simple Network Management Protocol (SNMP) trap
# Default Value is 3 (Manual), Any start value passes NIST inc. Not set
$registrypath = "HKLM:/System/CurrentControlSet/Services/SNMPTRAP"
$name = "Start"
$value = 3

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (22.12) 8435  'Printer Extensions and Notifications'
# Disabled (4) or not found pass
$registrypath = "HKLM:/System/CurrentControlSet/Services/PrintNotify"
$name = "Start"
$value = 4

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (22.13) 8436 Hyper-V Time Synchronization
# Any set value passes. Default = Manual (3)
$registrypath = "HKLM:/System/CurrentControlSet/Services/vmictimesync"
$name = "Start"
$value = 3

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (22.14) 8442 Network Connectivity Assistant
# Set value was Manual, Disabled (4) is expected. 
$registrypath = "HKLM:/System/CurrentControlSet/Services/NcaSvc"
$name = "Start"
$value = 4

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (22.15) 8444 Credential Manager
# Set value was Manual (3)
$registrypath = "HKLM:/System/CurrentControlSet/Services/VaultSvc"
$name = "Start"
$value = 4

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (22.16) 8450 Hyper-V Heartbeat
# Any value passes, Set value was Manual (3)
$registrypath = "HKLM:/System/CurrentControlSet/Services/vmicheartbeat"
$name = "Start"
$value = 3

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (22.17) 8451 Active Directory Web
# Disabled or Not found are acceptable values
$registrypath = "HKLM:/System/CurrentControlSet/Services/ADWS"
$name = "Start"
$value = 4

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (22.18) 8452 Hyper-V Data Exchange
# Disabled or not set are acceptable
$registrypath = "HKLM:/System/CurrentControlSet/Services/vmickvpexchange"
$name = "Start"
$value = 4

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (22.19) 8453 Device Install' Service
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/DeviceInstall"
$name = "Start"
$value = 4

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (22.20) 8454 Hyper-V Remote Desktop Virtualization
# Any set value passes
$registrypath = "HKLM:/System/CurrentControlSet/Services/vmicrdv"
$name = "Start"
$value = 3

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (22.21) 8455 Hyper-V Guest Shutdown
# Set value was manual (3)
$registrypath = "HKLM:/System/CurrentControlSet/Services/vmicshutdown"
$name = "Start"
$value = 4

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (22.22) 8456 DS Role Server
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/DsRoleSvc"
$name = "Start"
$value = 4

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (22.23) 8458  'Windows Store' Service (WSService)
# Set value was manual
$registrypath = "HKLM:/System/CurrentControlSet/Services/WSService"
$name = "Start"
$value = 4

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (22.24) 8463 KDC Proxy Server
# Set value was manual (3)
$registrypath = "HKLM:/System/CurrentControlSet/Services/KPSSVC"
$name = "Start"
$value = 4

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (22.25) 8470 Microsoft iSCSI Software Target
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/WinTarget"
$name = "Start"
$value = 4

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (22.28) 1191 Remote Registry
# Set value was automatic (2)
$registrypath = "HKLM:/System/CurrentControlSet/Services/RemoteRegistry"
$name = "Start"
$value = 4

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (22.43) 1472  Network Connections
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/Netman"
$name = "Start"
$value = 4

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (22.44) 1475 Remote Access Auto Connection Manager
# set value was manual
$registrypath = "HKLM:/System/CurrentControlSet/Services/RasAuto"
$name = "Start"
$value = 4

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }



## (22.45) 1476 Remote Access Connection Manager (RasMan)
# Set value was manual
$registrypath = "HKLM:/System/CurrentControlSet/Services/RasMan"
$name = "Start"
$value = 4

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (22.46) 1479 Remote Procedure Call (RPC) Locater' service
# set value was manual
$registrypath = "HKLM:/System/CurrentControlSet/Services/RpcLocator"
$name = "Start"
$value = 4

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (22.50) 3720 IPSEC Services' service
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/PolicyAgent"
$name = "Start"
$value = 4

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (22.52) 2042MSS: (AutoShareServer) Lanman 'Default administrative shares
# Any value passes Compliance
$registrypath = "HKLM:/System/CurrentControlSet/Services/LanManServer/Parameters"
$name = "AutoShareServer"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (22.130) 2603 'User Account Control: Only elevate executables that are signed and validated'
# 
$registrypath = "HKLM:/Software/Microsoft/Windows/CurrentVersion/Policies/System"
$name = "ValidateAdmin"
$value = 

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (23.1) 1052 'Devices: Allowed to format and eject removable media' setting (NTFS formatted devices)
# 
$registrypath = "HKLM:/Software/Microsoft/Windows NT/CurrentVersion/WinLogon"
$name = "AllocateDASD"
$value = 

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (23.3) 1183  'Disable Autorun for all drives' setting for the HKLM key
# 
$registrypath = "HKLM:/Software/Microsoft/Windows/CurrentVersion/Policies/explorer"
$name = "Nodrivetypeautorun"
$value = 255

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (23.4) 4067 'Portable Device Enumerator' service Failed
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/WPDBusEnum"
$name = "Start"
$value = 3

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }



## (24.38) 7502  [GPO-based] 'Application: Maximum log size' setting (in KB)
# Greater than or equal to 32768
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows/EventLog/Application"
$name = "MaxSize"
$value = 32768

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (24.39) 7503 [GPO-based] 'Security: Maximum log size' (in KB)
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows/EventLog/Security"
$name = "MaxSize"
$value = 196608

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (24.40) 7504 [GPO-based] 'System: Maximum log size' setting (in KB)
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows/EventLog/System"
$name = "MaxSize"
$value = 32768

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (24.41) 9014  'Setup: Maximum Log Size (KB)' setting
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows/EventLog/Setup"
$name = "MaxSize"
$value = 32768

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (24.77) 1367 'Audit: Audit the access of global system objects' setting
# 
$registrypath = "HKLM:/System/CurrentControlSet/Control/Lsa"
$name = "AuditBaseObjects"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (24.152) 1964  'Event Log' service
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/EventLog"
$name = "Start"
$value = 2

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (24.153) 3784  'Windows Error Reporting' service
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/WerSvc"
$name = "Start"
$value = 2

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (25.1) 3899 'Solicited Remote Assistance' policy setting (Terminal Services)
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows NT/Terminal Services"
$name = "fAllowToGetHelp"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (25.2) 3900 Offer Remote Assistance' setting (Terminal Services)
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows NT/Terminal Services"
$name = "fAllowUnsolicited"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (27.1) 1431 'Domain controller: Allow server operators to schedule tasks' setting
# 
$registrypath = "HKLM:/System/CurrentControlSet/Control/Lsa"
$name = "SubmitControl"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (27.7) 8443  'Power' Service
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/Power"
$name = "Start"
$value = 2

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

##(28.1) 3944 Application: Control Event Log behavior when the log file reaches its Max Size
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows/EventLog/Application"
$name = "Retention"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

##(28.6) 9013 Setup: Control Event Log behavior when the log file reaches its max Size
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows/EventLog/Setup"
$name = "Retention"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

##(28.7) 1048 Shutdown: Clear virtual memory pagefile
# 
$registrypath = "HKLM:/System/CurrentControlSet/Control/Session Manager/Memory Management"
$name = "ClearPageFileAtShutdown"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

##(28.8) 1362 Retention Method for Security Log' setting
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/EventLog/Security"
$name = "Retention"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (28.9) 1365 Retention Method for System Log
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/EventLog/System"
$name = "Retention"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (28.11) 3942 System: Control Event Log behavior when the log file reaches its maximum size' Group Policy setting
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows/EventLog/System"
$name = "Retention"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (28.12) 3943 Security: Control Event Log behavior when the log file reaches its maximum size
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows/EventLog/Security"
$name = "Retention"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (28.16) 3797 Volume Shadow Copy Service (VSS)'
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/VSS"
$name = "Start"
$value = 3

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

##(29.1) 1152 Allow undock without having to logon
# 
$registrypath = "HKLM:/Software/Microsoft/Windows/CurrentVersion/Policies/System"
$name = "UndockWithoutLogon"
$value = 2

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (29.2) 1369 Shutdown: Allow system to be shut down without having to log on
# 
$registrypath = "HKLM:/Software/Microsoft/Windows/CurrentVersion/Policies/System"
$name = "ShutdownwithoutLogon"
$value = 0 

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

##(29.3) 1433 Status of the 'Interactive logon: Require smart card' setting
# 
$registrypath = "HKLM:/Software/Microsoft/Windows/CurrentVersion/Policies/System"
$name = "ScForceOption"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

##  (29.7) 8381 Smart card removal policy
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/SCPolicySvc"
$name = "Start"
$value = 3

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (34.1) 9043 Default Protections for Internet Explorer
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/EMET/Defaults"
$name = "ie"
$value = "iexplore.exe"

If(-not(Test-Path -Path $registrypath))
  {
      New-Item -Path $registrypath
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (34.2) 9057 Status of the 'System ASLR' setting
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/EMET/SysSettings"
$name = "ASLR"
$value = 3

If(-not(Test-Path -Path $registrypath))
  {
      
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (34.3) 9058 System DEP' setting for 'Application Opt-Out'
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/EMET/SysSettings"
$name = "DEP"
$value = 2

If(-not(Test-Path -Path $registrypath))
  {
      
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (34.4) 9059 System SEHOP setting for Application Opt-Out
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/EMET/SysSettings"
$name = "SEHOP"
$value = 2

If(-not(Test-Path -Path $registrypath))
  {
      
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (34.5) 9064  Default Protections for Popular Software
# 
#$registrypath = "HKLM:/"
#$name = ""
#$value = 

If(-not(Test-Path -Path $registrypath))
  {
      
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (34.6) 9065 Default Protections for Recommended Software
# 
#$registrypath = ""
#$name = ""
#$value = 

If(-not(Test-Path -Path $registrypath))
  {
      
     New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
 Else
   {
       Set-ItemProperty -Path $registrypath -Name $name -Value $value
   }

##(34.9) 1458 MSS: (SafeDLLSearchMode) Enable Safe DLL search mode (recommended)
# 
$registrypath = "HKLM:/System/CurrentControlSet/Control/Session Manager"
$name = "SafeDllSearchMode"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (35.2) 1154 Network access: Do not allow storage of credentials or .NET passports for network authentication
# 
$registrypath = "HKLM:/System/CurrentControlSet/Control/Lsa"
$name = "DisableDomainCreds"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


##(35.3) 1155  Interactive Logon: Number of Previous Logons to Cache (in case domain controller is not available)
# 
$registrypath = "HKLM:/Software/Microsoft/Windows NT/CurrentVersion/WinLogon"
$name = "CachedLogonCount"
$value = 3

If(-not(Test-Path -Path $registrypath))
  {
      
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (35.4) 2585 Status of the 'Network access: Do not allow storage of passwords and credentials for
# 
$registrypath = "HKLM:/System/CurrentControlSet/Control/Lsa"
$name = "DisableDomainCreds"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (35.5) 4119 Status of the 'Allow indexing of encrypted files' Group Policy setting
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows/Windows Search"
$name = "AllowIndexingEncryptedStoresOrItems"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (35.8) 8462 Encrypted File System Service
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/EFS"
$name = "Start"
$value = 3

If(-not(Test-Path -Path $registrypath))
  {
      
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (35.10) 3875 Do not allow drive redirection' setting (Terminal Services)
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows NT/Terminal Services"
$name = "fDisableCdm"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (35.11) 3921 Turn off the 'Publish to Web' task for files and folders' group policy
# 
$registrypath = "HKLM:/Software/Microsoft/Windows/CurrentVersion/Policies/Explorer"
$name = "NOPublishingWizard"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (35.26) 3907 Status of the 'Windows Messenger Customer Experience Improvement Program' policy
# 1 = Disabled, 2 = Enabled (2 expected)
$registrypath = "HKLM:/Software/Policies/Microsoft/Messenger/Client"
$name = "CEIP"
$value = 2

If(-not(Test-Path -Path $registrypath))
  {
      
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (35.27) 3908 Status of the 'Turn off Search Companion content file updates' service
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/SearchCompanion"
$name = "DisableContentFileUpdates"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (37.6) 3919 Turn off printing over HTTP
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows NT/Printers"
$name = "DisableHTTPPrinting"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (37.7) 4007 Windows Extensible Authentication Protocol' (EAP) service
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/EapHost"
$name = "Start"
$value = 3

If(-not(Test-Path -Path $registrypath))
  {
      
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (37.8) 9008 Status of the 'Do not display network selection UI' setting
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows/System"
$name = "DontDisplayNetworkSelectionUI"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (37.13) 1185 System cryptography: Use FIPS compliant algorithms for encryption, hashing, and signing
# 
$registrypath = "HKLM:/System/CurrentControlSet/Control/Lsa/FIPSAlgorithmPolicy"
$name = "Enabled"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (37.14) 1388 Status of the 'Network Security: LDAP client signing requirements' setting
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/LDAP"
$name = "LDAPClientIntegrity"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


##(37.21) 1370 Domain member: Digitally encrypt or sign secure channel data (always)'
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/Netlogon/Parameters"
$name = "RequireSignOrSeal"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (37.22) 1371 Domain member: Digitally encrypt secure channel data (when possible)
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/Netlogon/Parameters"
$name = "SealSecureChannel"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (37.23) 1372 Domain member: Digitally sign secure channel data (when possible)' setting
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/Netlogon/Parameters"
$name = "SignSecureChannel"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (37.24) 1375 Domain member: Require strong (Windows 2000 or later) session key
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/Netlogon/Parameters"
$name = "RequireStrongKey"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (37.25) 1379 Microsoft network client: Digitally Sign Communications (if server agrees)'
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/LanmanWorkstation/Parameters"
$name = "EnableSecuritySignature"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (37.26) 1381 Microsoft network server: Digitally Sign Communications (if Client agrees)
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/LanmanServer/Parameters"
$name = "EnableSecuritySignature"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (37.27) 1389 'Network Security: Minimum session security for NTLM SSP based (including secure RPC) clients
# 
$registrypath = "HKLM:/System/CurrentControlSet/Control/Lsa/MSV1_0"
$name = "ntlmminclientsec"
$value = 536870912

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (37.28) 1390 Network Security: Minimum session security for NTLM SSP based (including secure RPC) servers
# 
$registrypath = "HKLM:/System/CurrentControlSet/Control/Lsa/MSV1_0"
$name = "ntlmminserversec"
$value = 536870912

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }


## (37.29) 1959 'Cryptographic Services' service
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/CryptSvc"
$name = "Start"
$value = 2

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (37.30) 2635 Set Client Connection Encryption Level' setting (Terminal Services)
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows NT/Terminal Services"
$name = "MinEncryptionLevel"
$value = 3

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (37.31) 8231 Configure 'Network Security:Configure encryption types allowed for Kerberos'
# 16 = AES_256_HMAC_SHA1, 8 = AES_128_HMAC_SHA1, Future Encryption Types = 2147483616, 24 = AES_128_HMAC_SHA1 and AES_256_HMAC_SHA1, 
$registrypath = "HKLM:/Software/Microsoft/Windows/CurrentVersion/Policies/System/Kerberos"
$name = "SupportedEncryptionTypes"
$value = 2147483640

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (37.32) 8252 Allow unencrypted traffic' setting (WinRM service)
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows/WinRM/Service"
$name = "AllowUnencryptedTraffic"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

##(37.33) 8253 Allow unencrypted traffic' setting (WinRM client)
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows/WinRM/Client"
$name = "AllowUnencryptedTraffic"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (37.34) 1149 Microsoft network client: Digitally sign communications (always)
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/LanmanWorkstation/Parameters"
$name = "RequireSecuritySignature"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (37.35) 1189 Status of the 'Microsoft network server: Digitally sign communication (always)'
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/lanmanserver/Parameters"
$name = "requiresecuritysignature"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

##  (38.24) 1436 System cryptography: Force strong key protection for user keys stored on the computer
# 0 = User input is not required when new keys are stored and used
# 1 = User input is prompted when the first key is first used
# 2 = User must enter a password each time they use a key
# key not found
# all options will pass NIST
$registrypath = "HKLM:/Software/Policies/Microsoft/Cryptography"
$name = "ForceKeyProtection"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (40.2) 3737 Status of the 'Windows Time' service
# Should be set to Automatic
$registrypath = "HKLM:/System/CurrentControlSet/Services/W32Time"
$name = "Start"
$value = 2

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (40.4) 5264 Microsoft network server: Server SPN target name validation level
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/LanManServer/Parameters"
$name = "SMBServerNameHardeningLevel"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (40.5) 4056 Windows Net.Tcp Port Sharing' service
# All Start Values pass NIST
$registrypath = "HKLM:/System/CurrentControlSet/Services/NetTcpPortSharing"
$name = "Start"
$value = 2

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (41.16) 1597 DCOM: Machine Access Restrictions in Security Descriptor Definition
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows NT/DCOM"
$name = "MachineAccessRestriction"
$value = 

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (41.17) 1598 DCOM: Machine Launch Restrictions in Security Descriptor Definition Language (SDDL) syntax
# Blank or key not found are acceptable
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows NT/DCOM"
$name = "MachineLaunchRestriction"
$value = 

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (41.31) 2582 User Account Control: Detect application installations and prompt for elevation
# all options will pass. Disabled/Enabled/Notset/not found
$registrypath = "HKLM:/Software/Microsoft/Windows/CurrentVersion/Policies/System"
$name = "EnableInstallerDetection"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

##(41.32) 2583 User Account Control: Run all administrators in Admin Approval Mode' 
# All values pass (Enabled or Disabled)
$registrypath = "HKLM:/Software/Microsoft/Windows/CurrentVersion/Policies/System"
$name = "EnableLUA"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (41.33) 2584 User Account Control: Only elevate UIAccess applications that are installed in secure locations
# All values pass
$registrypath = "HKLM:/Software/Microsoft/Windows/CurrentVersion/Policies/System"
$name = "EnableSecureUIAPaths"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (41.34) 2587 User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode
# 
$registrypath = "HKLM:/Software/Microsoft/Windows/CurrentVersion/Policies/System"
$name = "ConsentPromptBehaviorAdmin"
$value = 5

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (41.37) 3940 User Account Control: Virtualize file and registry write failures to per-user
# Enabled or Disabled Passes
$registrypath = "HKLM:/Software/Microsoft/Windows/CurrentVersion/Policies/System"
$name = "EnableVirtualization"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

##(41.39) 1361 Prevent local guests group from accessing security log'
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/Eventlog/Security"
$name = "RestrictGuestAccess"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }
   
## (41.75) 1162 Devices: Restrict floppy access to locally logged-on user only'
# Doesnt need to be set (1/2/not set or found)
$registrypath = "HKLM:/Software/Microsoft/Windows NT/CurrentVersion/WinLogon"
$name = "Allocatefloppies"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (41.76) 1163 Prevent users from installing printer drivers
# 
$registrypath = "HKLM:/System/CurrentControlSet/Control/Print/Providers/LanMan Print Services/Servers"
$name = "addprinterdrivers"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (41.77) 1176 Devices: Restrict CD-ROM Access to Locally Logged-On User Only'
# 
$registrypath = "HKLM:/Software/Microsoft/Windows NT/CurrentVersion/WinLogon"
$name = "AllocateCDRoms"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (41.81) 5267 Network security: Allow PKU2U authentication requests to this computer to use online ID's
# 
$registrypath = "HKLM:/System/CurrentControlSet/Control/Lsa/pku2u"
$name = "AllowOnlineID"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (41.251) 3993 Smartcard Certificate Propagation
# All values are acceptable
$registrypath = "HKLM:/System/CurrentControlSet/Services/CertPropSvc"
$name = "Start"
$value = 3

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (41.254) 7501 Registry policy processing option: Process even if the Group Policy
# Enabled/Disabled or not found are acceptable
#$registrypath = "HKLM:/Software/Policies/Microsoft/Windows/Group Policy/{35378EAC-683F-11D2-A89A-00C04FBBCFA2}"
#$name = "NoGPOListChanges"
#$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (41.255) 8198 Windows Installer: Set Always install with elevated privileges
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows/Installer"
$name = "AlwaysInstallElevated"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (42.1) 3876  Do not allow passwords to be saved' policy setting (Terminal Services)
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows NT/Terminal Services"
$name = "DisablePasswordSaving"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (42.9) 1430 Status of the 'Terminal Services' service
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/TermService"
$name = "Start"
$value = 4

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (42.11) 3892 [Netmeeting] 'Disable Remote Desktop Sharing'
# Enabled or Disabled
$registrypath = "HKLM:/Software/Policies/Microsoft/Conferencing"
$name = "NoRDS"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

##
# 
#$registrypath = ""
#$name = ""
#$value = 

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (42.12) 4085 Terminal Services Gateway Service
# All Value are acceptable
$registrypath = "HKLM:/System/CurrentControlSet/Services/TSGateway"
$name = "Start"
$value = 2

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (42.14) 9024 Apply UAC restrictions to local accounts on network logons'
# 
$registrypath = "HKLM:/Software/Microsoft/Windows/CurrentVersion/Policies/System"
$name = "LocalAccountTokenFilterPolicy"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (42.25) 3727  Remote Procedure Call (RPC)
# 
#$registrypath = "HKLM:/System/CurrentControlSet/Services/RpcSs"
#$name = "Start"
#$value = 2

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (42.26) 3793 Special Administration Console Helper
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/sacsvr"
$name = "Start"
$value = 3

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (42.27) 3988 Windows Remote Management Service
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/WinRM"
$name = "Start"
$value = 2

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (42.28) 4035 Remote Desktop Services UserMode Port Redirector
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/UmRdpService"
$name = "Start"
$value = 2

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (42.31) 1510 Routing and Remote Access
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/RemoteAccess"
$name = "Start"
$value = 2

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (43.16) 1484 Telephony' service
# all values are acceptable
$registrypath = "HKLM:/System/CurrentControlSet/Services/TapiSrv"
$name = "3"
$value = 

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (43.17) 1965 Human Interface Device Access
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/HidServ"
$name = "Start"
$value = 3

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (44.17) 8143 Security Options 'Interactive logon: Machine account lockout threshold
# Greater than or equal to 0
$registrypath = "HKLM:/Software/Microsoft/Windows/CurrentVersion/Policies/System"
$name = "MaxDevicePasswordFailedAttempts"
$value = 3

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (44.18) 8145 Security Options 'Interactive logon: Machine inactivity limit'(Seconds)
# Greater than or equal to 0
$registrypath = "HKLM:/Software/Microsoft/Windows/CurrentVersion/Policies/System"
$name = "InactivityTimeoutSecs"
$value = 30

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (44.28) 9025 'WDigest Authentication'
# 
$registrypath = "HKLM:/System/CurrentControlSet/Control/SecurityProviders/WDigest"
$name = "UseLogonCredential"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (44.40) 8248 Disallow Digest authentication' setting (WinRM client)
# Enabled or Disabled (Enabled is more secure)
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows/WinRM/Client"
$name = "AllowDigest"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (44.41) 8249 Allow Basic authentication' setting (WinRM client)
# Enabled or Disabled Pass
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows/WinRM/Client"
$name = "AllowBasic"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (44.42) 8250 Status of the 'Allow Basic authentication' setting (WinRM service)
# 
$registrypath = "HKLM:/Software/Policies/Microsoft/Windows/WinRM/Service"
$name = "AllowBasic"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (44.47) 1376 Interactive Logon: Do not require CTRL+ALT+DEL
# 
$registrypath = "HKLM:/Software/Microsoft/Windows/CurrentVersion/Policies/System"
$name = "DisableCAD"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (44.56) 1164 Network Security: Do not store LAN Manager password hash value on next password change
# 
$registrypath = "HKLM:/System/CurrentControlSet/Control/Lsa"
$name = "NoLMHash"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (44.57) 1380 Microsoft network client: Send Unencrypted Password to Connect to Third-Party SMB Server
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/LanmanWorkstation/Parameters"
$name = "EnablePlainTextPassword"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (44.80) 1374 Domain member: Maximum machine account password age'
# Greater than or equal to 0
$registrypath = "HKLM:/System/CurrentControlSet/Services/Netlogon/Parameters"
$name = "MaximumPasswordAge"
$value = 90

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (44.87) 1200 Status of the 'Domain Controller: Refuse machine account password changes'
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/Netlogon/Parameters"
$name = "RefusePasswordChange"
$value = 1

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

## (44.89) 1373 Status of the 'Domain member: Disable machine account password changes'
# Enabled or Disabled are acceptable
$registrypath = "HKLM:/System/CurrentControlSet/Services/Netlogon/Parameters"
$name = "DisablePasswordChange"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }

##### Additional Changes #####

## 
# 
$registrypath = "HKLM:/System/CurrentControlSet/Services/Lanmanserver/Parameters"
$name = "AutoShareWKS"
$value = 0

If(-not(Test-Path -Path $registrypath))
  {
      New-ItemProperty -Path $registrypath -Name $name -Value $value
  }
Else
  {
      Set-ItemProperty -Path $registrypath -Name $name -Value $value
  }
