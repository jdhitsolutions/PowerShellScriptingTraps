---
external help file: MySystemStatus-help.xml
Module Name: MySystemStatus
online version:
schema: 2.0.0
---

# Get-MySystemService

## SYNOPSIS

Get system service information

## SYNTAX

### name (Default)
```
Get-MySystemService [-Computername] <String[]> [-Name <String[]>] [<CommonParameters>]
```

### status
```
Get-MySystemService [-Computername] <String[]> [-Status <ServiceControllerStatus>] [<CommonParameters>]
```

### start
```
Get-MySystemService [-Computername] <String[]> [-StartType <ServiceStartMode[]>] [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Computername
Enter name of a computer or computers to query.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: cn

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Enter the name or names of services to query

```yaml
Type: String[]
Parameter Sets: name
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartType
{{Fill StartType Description}}

```yaml
Type: ServiceStartMode[]
Parameter Sets: start
Aliases:
Accepted values: Boot, System, Automatic, Manual, Disabled

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status
{{Fill Status Description}}

```yaml
Type: ServiceControllerStatus
Parameter Sets: status
Aliases:
Accepted values: Stopped, StartPending, StopPending, Running, ContinuePending, PausePending, Paused

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
