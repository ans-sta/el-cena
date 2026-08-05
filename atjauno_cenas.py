#!/usr/bin/env python3
"""Paņem Nord Pool day-ahead cenas (LV zona) no Elering publiskā API un
ieraksta cenas.json, ko lasa index.html.

Elering (Igaunijas pārvades operators) cenas servē bez atslēgām:
https://dashboard.elering.ee/api/nps/price — EUR/MWh bez PVN, epohas sekundes.
Lapa rāda c/kWh AR PVN, tāpēc pārrēķins ×1.21/10 (tas pats, ko HA nordpool
sensors dara ar saviem iestatījumiem LV/EUR/PVN/centi).

Krājums: ~9 dienas atpakaļ (nedēļas kvartiļu rēķinam lapā vajag 7 pilnas
dienas) + rītdiena, kad tā jau publicēta (~13:30–14:00 Rīgas laikā).
"""
import json
import sys
import urllib.request
import datetime as dt
from collections import Counter

PVN = 1.21
DIENAS_ATPAKAL = 9
ZONA = "lv"
FAILS = "cenas.json"

now = dt.datetime.now(dt.timezone.utc)
start = (now - dt.timedelta(days=DIENAS_ATPAKAL)).strftime("%Y-%m-%dT00:00:00.000Z")
end = (now + dt.timedelta(days=2)).strftime("%Y-%m-%dT00:00:00.000Z")
url = "https://dashboard.elering.ee/api/nps/price?start=" + start + "&end=" + end

req = urllib.request.Request(url, headers={
    "User-Agent": "el-cena.stabingis.lv atjauninatajs (GitHub Actions)",
    "Accept": "application/json",
})
with urllib.request.urlopen(req, timeout=60) as r:
    dati = json.load(r)

rindas = dati.get("data", {}).get(ZONA) or []
# dublikātus izmet, laiks augošā secībā
pa_laiku = {}
for p in rindas:
    if p.get("price") is None:
        continue
    pa_laiku[int(p["timestamp"])] = round(p["price"] * PVN / 10, 3)
periodi = sorted(pa_laiku.items())

# drošības pārbaudes — sabojātu atbildi NEDRĪKST ierakstīt pāri labam failam:
# darbs krīt (commit nenotiek) un vecais cenas.json paliek spēkā
if len(periodi) < 200:
    sys.exit("Par maz periodu (%d) — izskatās pēc bojātas API atbildes" % len(periodi))
sodien = now.astimezone(dt.timezone(dt.timedelta(hours=3))).date()
sodienas = [s for s, _ in periodi
            if dt.datetime.fromtimestamp(s, dt.timezone.utc).astimezone(
                dt.timezone(dt.timedelta(hours=3))).date() == sodien]
if len(sodienas) < 90:
    sys.exit("Šodienai tikai %d periodi — jābūt 96" % len(sodienas))

# perioda garums no datiem (tagad 15 min; ja tirgus mainītos, lapa sekos līdzi)
solis = Counter(b - a for (a, _), (b, _) in zip(periodi, periodi[1:])).most_common(1)[0][0]

izvade = {
    "atjaunots": now.strftime("%Y-%m-%dT%H:%M:%SZ"),
    "zona": ZONA,
    "pvn": PVN,
    "perioda_min": solis // 60,
    "periodi": [[s, v] for s, v in periodi],
}
with open(FAILS, "w") as f:
    json.dump(izvade, f, separators=(",", ":"))
print("OK:", len(periodi), "periodi,", "solis", solis // 60, "min, līdz",
      dt.datetime.fromtimestamp(periodi[-1][0], dt.timezone.utc).isoformat())
