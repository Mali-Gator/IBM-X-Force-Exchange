#This IP address scans a list of IP addresses from an input file against the IBM X-Force Exchange API and returns the risk score associated with each IP address.

# Store the API key and password in variables
# It is recommended to store the IBM API key and password as a variable so the key does not have to be coded into the script.

$apiKey = "[IBM X-FORCE EXCHANGE API KEY]"
$apiPassword = "[IBM X-FORCE EXCHANGE API PASSWORD]"

# Build the headers for the API request
$headers = @{
    "Authorization" = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($apiKey):$($apiPassword)"))
}

# Read in IP addresses from a CSV file
$ipAddresses = Import-Csv -Path "C:\[INSERT FILE PATH]\input_ip_addresses.csv"

# Initialize an array to store the results
$results = @()

# Loop through each IP address
foreach ($ipAddress in $ipAddresses) {

    # Build the URL to query
    $url = "https://api.xforce.ibmcloud.com/ipr/$($ipAddress.IP)"

    # Send a GET request to the API and store the response in a variable
    $response = Invoke-WebRequest -Uri $url -Headers $headers -ErrorAction Stop

    # Parse the JSON response
    $json = $response.Content | ConvertFrom-Json

    # Extract the information you're interested in from the JSON
    $ip_address = $ipAddress.IP
    $score = $json.score

    # Create a custom object to hold the extracted data
    $data = [PSCustomObject]@{
        "IP Address" = $ip_address
        "Score" = $score
    }

    # Add the data to the results array
    $results += $data
}

# Output the results to a CSV file
$results | Export-Csv -Path "C:\[INSERT FILE PATH]\List_scan_output.csv" -NoTypeInformation
