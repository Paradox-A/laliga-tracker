#!/bin/bash
# Requires FOOTBALL_DATA_API_TOKEN env var set (free key from football-data.org)
set -e

fetch() {
  # $1 = output file, rest = curl args (URL, headers, etc.)
  local out="$1"; shift
  curl -s "$@" -o "$out"
  if grep -q '"errorCode"' "$out" 2>/dev/null; then
    echo "ERROR: fetch failed for $out — $(cat "$out")" >&2
    exit 1
  fi
  sleep 7
}

fetch standings.json -H "X-Auth-Token: $FOOTBALL_DATA_API_TOKEN" "https://api.football-data.org/v4/competitions/PD/standings"
fetch matches.json -H "X-Auth-Token: $FOOTBALL_DATA_API_TOKEN" "https://api.football-data.org/v4/competitions/PD/matches"
fetch scorers.json -H "X-Auth-Token: $FOOTBALL_DATA_API_TOKEN" "https://api.football-data.org/v4/competitions/PD/scorers?limit=50"

# LaLiga's own site — real yellow cards, red cards, and assists data
# embedded as __NEXT_DATA__ JSON in the raw HTML, no API key needed
fetch ll_scorers.html "https://www.laliga.com/en-GB/stats/laliga-easports/scorers"
fetch ll_yellow.html "https://www.laliga.com/en-GB/stats/laliga-easports/yellow-cards"
fetch ll_red.html "https://www.laliga.com/en-GB/stats/laliga-easports/red-cards"
fetch ll_assists.html "https://www.laliga.com/en-GB/stats/laliga-easports/assists"

python3 build_site.py
echo "Rebuilt site/index.html"
