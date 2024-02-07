# Define the path of the input and output files
$inputFilePath = "C:\path\to\your\inputfile.txt"
$outputFilePath = "C:\path\to\your\outputfile.txt"

# Read the contents of the file
$content = Get-Content $inputFilePath

# Define a regular expression for IP addresses
$ipRegex = '\b\d{1,3}(\.\d{1,3}){3}\b'

# Find all matches in the file content
$ipAddresses = Select-String -InputObject $content -Pattern $ipRegex -AllMatches | % { $_.Matches } | % { $_.Value }

# Write the IP addresses to the output file
$ipAddresses | Out-File $outputFilePath
