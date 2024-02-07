# Define the network adapter name
$adapterName = "YourAdapterName" # Replace with your actual network adapter name

# Define log file path
$logFile = "C:\NetworkTrafficLog.txt"

# Event Log Details
$eventSource = "NetworkTrafficLogger"
$eventLogType = "Application" # You can use other log types like System, Security, etc., based on your requirement

# Check and create the event source if it does not exist
if (-not [System.Diagnostics.EventLog]::SourceExists($eventSource)) {
    New-EventLog -LogName $eventLogType -Source $eventSource
}

# Function to collect and log network traffic data
function Log-NetworkTraffic {
    # Get current date and time
    $dateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    # Collect network traffic statistics
    $stats = Get-NetAdapterStatistics -Name $adapterName
    
    # Extract received and sent bytes
    $bytesReceived = $stats.ReceivedBytes
    $bytesSent = $stats.SentBytes
    
    # Prepare log entry
    $logEntry = "$dateTime | Received: $bytesReceived bytes, Sent: $bytesSent bytes"
    
    # Append log entry to the file
    Add-Content -Path $logFile -Value $logEntry
    
    # Log to Windows Event Log
    $eventLogMessage = "Network traffic at $dateTime - Received: $bytesReceived bytes, Sent: $bytesSent bytes"
    Write-EventLog -LogName $eventLogType -Source $eventSource -EntryType Information -EventId 1 -Message $eventLogMessage
}

# Schedule task to run every hour
$trigger = New-JobTrigger -Once -At (Get-Date).AddMinutes(60) -RepetitionInterval (New-TimeSpan -Hours 1) -RepetitionDuration ([TimeSpan]::MaxValue)
Register-ScheduledJob -Name "LogNetworkTraffic" -ScriptBlock ${function:Log-NetworkTraffic} -Trigger $trigger

# Initial run
Log-NetworkTraffic
