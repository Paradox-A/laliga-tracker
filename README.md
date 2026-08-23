# LaLiga 2026-27 Tracker

A static tracker for LaLiga (Spain's top flight), mirroring the Premier League tracker, with three tabs:
- **League Table**: full standings, color-coded by European qualification zone (Champions League, Europa League, Conference League) and relegation zone, plus a "European Race" view of the top 8 and a "Relegation Watch" view of what each bottom-table team needs to reach safety.
- **Club Stats**: clean sheets, home/away form splits, biggest wins & heaviest losses — all derived from match results.
- **Player Stats**: Pichichi (top scorer) race, plus expandable lists for Most Goals, Most Assists, Most Goals & Assists, Most Yellow Cards, and Most Red Cards.

## Data sources
- [football-data.org](https://www.football-data.org/) free API (LaLiga competition code `PD`) — standings, matches, goals/penalties.
- **laliga.com's own stats pages** — real yellow cards, red cards, and assists data. Unlike the Premier League tracker (which uses a clean JSON API) or the Championship tracker (which has no free source for these at all), LaLiga's site serves this data server-rendered, embedded in a `<script id="__NEXT_DATA__">` JSON blob in the raw HTML. `build_site.py` fetches the plain HTML page and regex-extracts that JSON — no browser or auth needed, but it's a scrape of an embedded payload rather than a documented API, so it could break if LaLiga changes their frontend framework or page structure.

No free source was found for individual goalkeeper clean sheets, so that section isn't included (club-level clean sheets, under Club Stats, are unaffected since those come from match results).

## Regenerating

```bash
export FOOTBALL_DATA_API_TOKEN=your_token_here
./fetch_data.sh
git add index.html
git commit -m "Refresh standings"
git push
```

Not live-updating — rebuild after each matchday (or whenever) to refresh the table.
