#!/usr/bin/env bash

advisor build-config get
jq '.sbom' target/.advisor/build-config.json > sbom-cdx.json
trivy sbom --skip-db-update --quiet --format json --scanners vuln sbom-cdx.json > trivy-report.json 2> trivy-check.log
cve_count=$(jq '[.Results[]?.Vulnerabilities[]?] | length' trivy-report.json)
echo "Found ${cve_count} known CVEs"
