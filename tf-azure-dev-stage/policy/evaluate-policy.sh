#!/bin/bash
set -e

PLAN_JSON=${1:-"tfplan.json"}
POLICY_DIR=${2:-"policy"}

echo "=========================================="
echo "    Running OPA Terraform Policy Check    "
echo "=========================================="

# Check if OPA CLI is available, install if needed (supports Linux & Windows self-hosted agents)
if ! command -v opa &> /dev/null && ! command -v opa.exe &> /dev/null && [ ! -f "opa.exe" ] && [ ! -f "/usr/local/bin/opa" ]; then
    echo "OPA not found in PATH. Downloading OPA binary..."
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]] || [[ "$AGENT_OS" == "Windows_NT" ]]; then
        curl -s -L -o opa.exe https://openpolicyagent.org/downloads/latest/opa_windows_amd64.exe
        chmod +x opa.exe 2>/dev/null || true
    else
        curl -s -L -o /usr/local/bin/opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64_static 2>/dev/null || curl -s -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64_static
        chmod 755 /usr/local/bin/opa 2>/dev/null || chmod +x opa
    fi
fi

OPA_CMD="opa"
if ! command -v opa &> /dev/null; then
    if [ -f "/usr/local/bin/opa" ]; then
        OPA_CMD="/usr/local/bin/opa"
    elif [ -f "./opa.exe" ] || command -v opa.exe &> /dev/null; then
        OPA_CMD="./opa.exe"
    elif [ -f "./opa" ]; then
        OPA_CMD="./opa"
    fi
fi

if [ ! -f "$PLAN_JSON" ]; then
    echo "ERROR: Plan JSON file '$PLAN_JSON' not found!"
    exit 1
fi

echo "Evaluating plan '$PLAN_JSON' against policy in '$POLICY_DIR'..."

VIOLATIONS=$($OPA_CMD eval --format raw --data "$POLICY_DIR" --input "$PLAN_JSON" "data.terraform.analysis.deny")

if [ "$VIOLATIONS" != "[]" ] && [ -n "$VIOLATIONS" ]; then
    echo "--------------------------------------------------------"
    echo "POLICY CHECK FAILED! Found policy violations:"
    echo "$VIOLATIONS" | jq . 2>/dev/null || echo "$VIOLATIONS"
    echo "--------------------------------------------------------"
    exit 1
fi

echo "OPA Policy Check Passed! No violations found."
exit 0
