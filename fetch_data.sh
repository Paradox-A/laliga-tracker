#!/bin/bash
# Requires FOOTBALL_DATA_API_TOKEN env var set (free key from football-data.org)
set -e
curl -s -H "X-Auth-Token: $FOOTBALL_DATA_API_TOKEN" "https://api.football-data.org/v4/competitions/PD/standings" -o standings.json
curl -s -H "X-Auth-Token: $FOOTBALL_DATA_API_TOKEN" "https://api.football-data.org/v4/competitions/PD/matches" -o matches.json
curl -s -H "X-Auth-Token: $FOOTBALL_DATA_API_TOKEN" "https://api.football-data.org/v4/competitions/PD/scorers?limit=50" -o scorers.json

# LaLiga's own site — real yellow cards, red cards, and assists data
# embedded as __NEXT_DATA__ JSON in the raw HTML, no API key needed
curl -s "https://www.laliga.com/en-GB/stats/laliga-easports/scorers" -o ll_scorers.html
curl -s "https://www.laliga.com/en-GB/stats/laliga-easports/yellow-cards" -o ll_yellow.html
curl -s "https://www.laliga.com/en-GB/stats/laliga-easports/red-cards" -o ll_red.html
curl -s "https://www.laliga.com/en-GB/stats/laliga-easports/assists" -o ll_assists.html

python3 build_site.py
echo "Rebuilt site/index.html"
