#!/bin/sh
# Palaiž GitHub darbu “Atjauno cenas”, ja publiskajā cenas.json vēl nav
# rītdienas. Kāpēc: GitHub ieplānotos (cron) darbus kavē par 3–9 h (mērīts
# 2026-09..11; 2026-11-02 13:20 darbs līdz 22:00 nebija sācies), bet ar
# workflow_dispatch palaists darbs izpildās ~10 s.
#
# Palaiž M19 Mac mini launchd (lv.stabingis.el-cena-atjauno.plist šajā mapē,
# uzstādīts ~/Library/LaunchAgents) 14:15, 15:15, 16:30 Rīgas laikā. GitHub
# cron paliek kā rezerve. Žurnāls: ~/Library/Logs/el-cena-atjauno.log
# Pārbaudei: CENAS_URL=http://… ./palaid-atjauno.sh
set -u
URL="${CENAS_URL:-https://el-cena.stabingis.lv/cenas.json}"
LOG="$HOME/Library/Logs/el-cena-atjauno.log"
GH=/opt/homebrew/bin/gh

zurnals() { echo "$(date '+%Y-%m-%d %H:%M:%S') $*" >> "$LOG"; }

# rītdienas periodu skaits cenas.json (Rīgas datums); tukšs, ja nevar nolasīt
if json=$(/usr/bin/curl -fsS --max-time 30 "$URL?t=$(date +%s)" 2>&1); then
  n=$(printf '%s' "$json" | /usr/bin/python3 -c '
import json, sys, datetime as dt
from zoneinfo import ZoneInfo
R = ZoneInfo("Europe/Riga")
rit = dt.datetime.now(R).date() + dt.timedelta(days=1)
print(sum(1 for s, _ in json.load(sys.stdin)["periodi"]
          if dt.datetime.fromtimestamp(s, R).date() == rit))
' 2>/dev/null)
else
  zurnals "cenas.json nevar paņemt ($json) — palaižu darbu tāpat"
  n=""
fi

if [ "${n:-0}" -ge 90 ] 2>/dev/null; then
  zurnals "rītdiena jau ir ($n periodi) — nekas nav jādara"
  exit 0
fi

if out=$("$GH" workflow run atjauno-cenas.yml -R ans-sta/el-cena 2>&1); then
  zurnals "rītdienas nav (${n:-?} periodi) — darbs palaists: $out"
else
  zurnals "KĻŪDA: gh workflow run neizdevās: $out"
  exit 1
fi
