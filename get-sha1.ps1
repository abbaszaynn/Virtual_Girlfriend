# SHA-1 Fingerprint Getter for Android Debug Keystore

Write-Host "Searching for Android debug keystore..." -ForegroundColor Yellow

# Check common locations
$keystorePaths = @(
    "$env:USERPROFILE\.android\debug.keystore",
    "e:\AI gF\craveai\android\app\debug.keystore"
)

$foundKeystore = $null

foreach ($path in $keystorePaths) {
    if (Test-Path $path) {
        Write-Host "Found keystore at: $path" -ForegroundColor Green
        $foundKeystore = $path
        break
    }
}

if (-not $foundKeystore) {
    Write-Host "Debug keystore not found in common locations." -ForegroundColor Red
    Write-Host "Creating one at: $env:USERPROFILE\.android\debug.keystore" -ForegroundColor Yellow
    
    # Create .android directory if it doesn't exist
    $androidDir = "$env:USERPROFILE\.android"
    if (-not (Test-Path $androidDir)) {
        New-Item -ItemType Directory -Path $androidDir -Force | Out-Null
    }
    
    Write-Host "`nFor now, you can use this PLACEHOLDER SHA-1 for testing:" -ForegroundColor Cyan
    Write-Host "DA:39:A3:EE:5E:6B:4B:0D:32:55:BF:EF:95:60:18:90:AF:D8:07:09" -ForegroundColor White
    Write-Host "`nNote: You'll need to replace this with your real SHA-1 later.`n" -ForegroundColor Yellow
    exit
}

# Now try to find keytool
Write-Host "`nSearching for keytool..." -ForegroundColor Yellow

$possibleJavaPaths = @(
    "C:\Program Files\Java",
    "C:\Program Files (x86)\Java",
    "C:\Program Files\Android\Android Studio\jbr\bin",
    "$env:LOCALAPPDATA\Android\Sdk\jre\bin",
    "$env:ProgramFiles\Java"
)

$keytoolPath = $null

foreach ($javaPath in $possibleJavaPaths) {
    if (Test-Path $javaPath) {
        $keytool = Get-ChildItem -Path $javaPath -Recurse -Filter "keytool.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($keytool) {
            $keytoolPath = $keytool.FullName
            Write-Host "Found keytool at: $keytoolPath" -ForegroundColor Green
            break
        }
    }
}

if (-not $keytoolPath) {
    Write-Host "keytool not found. Using placeholder SHA-1 for now:" -ForegroundColor Yellow
    Write-Host "DA:39:A3:EE:5E:6B:4B:0D:32:55:BF:EF:95:60:18:90:AF:D8:07:09" -ForegroundColor White
    Write-Host "`nInstall Android Studio to get keytool, then run this script again.`n" -ForegroundColor Yellow
    exit
}

# Run keytool to get SHA-1
Write-Host "`nGetting SHA-1 fingerprint..." -ForegroundColor Yellow

try {
    $output = & "$keytoolPath" -list -v -keystore "$foundKeystore" -alias androiddebugkey -storepass android -keypass android 2>&1
    
    # Extract SHA-1
    $sha1 = $output | Select-String "SHA1:" | ForEach-Object { $_.ToString().Split(":")[1].Trim() }
    
    if ($sha1) {
        Write-Host "`n===================================" -ForegroundColor Green
        Write-Host "YOUR SHA-1 FINGERPRINT:" -ForegroundColor Green
        Write-Host $sha1 -ForegroundColor White
        Write-Host "===================================" -ForegroundColor Green
        Write-Host "`nCopy the above SHA-1 and paste it into Google Cloud Console!`n" -ForegroundColor Cyan
    } else {
        Write-Host "Could not extract SHA-1 from output." -ForegroundColor Red
    }
} catch {
    Write-Host "Error running keytool: $_" -ForegroundColor Red
}
