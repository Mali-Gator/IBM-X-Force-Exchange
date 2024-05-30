## This script takes a list of ip addresses in the "input_ip_addresses.csv" file and scans them against AbuseIPDB. It returns results of how many times that IP was reported to AbuseIPDB

# Store the API key and password in variables
$apiKey = [INSERT API KEY HERE]
$apiPassword = [INSERT API PASSWORD HERE]

# Ask the user to input the IP address

while ($true) {
    # Ask the user to input the IP address
    $ipAddress = Read-Host -Prompt "Enter the IP address to scan"

    if ( $ipAddress -match "^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$" ) {
        break
    } else {
        Write-Host "Invalid IP address format. Please enter a valid IP address"
    }
}


# Build the URL to query
$url = "https://api.xforce.ibmcloud.com/ipr/$ipAddress"

# Build the headers for the API request
$headers = @{
    "Authorization" = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($apiKey):$($apiPassword)"))
}

# Send a GET request to the API and store the response in a variable
$response = Invoke-WebRequest -Uri $url -Headers $headers -ErrorAction Stop

# Parse the JSON response
$json = $response.Content | ConvertFrom-Json

# Extract the information you're interested in from the JSON
$ip_address = $ipAddress
$score = $json.score


# Create a custom object to hold the extracted data
$data = [PSCustomObject]@{
    "IP Address" = $ip_address
    "Score" = $score

}

# Output the data to the terminal

Write-Output "IP Address: $ip_address"
Write-Output "Risk Score: $score"

