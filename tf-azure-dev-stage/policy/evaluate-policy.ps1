param(
    [string]$PlanJson = "tfplan.json",
    [string]$PolicyDir = "policy"
)

$ErrorActionPreference = "Stop"

Write-Host "=========================================="
Write-Host " Running OPA Policy Check (PowerShell)   "
Write-Host "=========================================="

if (-not (Get-Command opa -ErrorAction SilentlyContinue) -and -not (Test-Path "opa.exe")) {
    Write-Host "Downloading OPA for Windows..."
    Invoke-WebRequest -Uri "https://openpolicyagent.org/downloads/latest/opa_windows_amd64.exe" -OutFile "opa.exe"
}

$opaBin = if (Get-Command opa -ErrorAction SilentlyContinue) { "opa" } elseif (Test-Path ".\opa.exe") { ".\opa.exe" } else { "opa" }

if (-not (Test-Path $PlanJson)) {
    Write-Error "Plan JSON file '$PlanJson' not found!"
    exit 1
}

$violations = & $opaBin eval --format raw --data $PolicyDir --input $PlanJson "data.terraform.analysis.deny"

if ($violations -and $violations -ne "[]") {
    Write-Host "POLICY CHECK FAILED! Violations detected:" -ForegroundColor Red
    Write-Host $violations
    exit 1
}

Write-Host "OPA Policy Check Passed! No violations found." -ForegroundColor Green
