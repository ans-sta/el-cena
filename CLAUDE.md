# el-cena — norādes Claude Code darbam

Elektrības cenu displejs (Nord Pool LV). Pilnais konteksts par mājām un
Home Assistant pusi dzīvo `~/dev/tools/homeassistant/CLAUDE.md` — šeit tikai
tas, kas vajadzīgs lapas darbam.

## Arhitektūra: viens avots, trīs izvietojumi

- `index.html` — vienīgais UI avots, divi datu režīmi pēc blakus esošā
  `elektriba-config.js`: publiskais (repo tukšais aizvietotājs → `cenas.json`)
  un mājas HA (`config/www/elektriba-config.js` ar tokenu — git repo tas
  NEKAD nenonāk).
- `cenas.json` — GitHub Actions (`atjauno-cenas.yml` → `atjauno_cenas.py`)
  3× dienā no Elering publiskā API. Elering CORS neatdod — lapa datus drīkst
  ņemt tikai no sava domēna.
- Izvietošana: `git push` (Pages atjaunojas ~1 min) + `./izvieto.sh` (nokopē
  lapu un ikonas uz abu māju HA `config/www`; mājas `elektriba-config.js`
  NEAIZTIKT). Pēc push pavilkt arī šo darba kopiju, ja strādāts citur.

## Dizaina sistēma (nepārkāpt bez vajadzības)

- Izkārtojumi: ainava (2 kolonnas + grafiks apakšā) / portrets (stabs,
  vērtējums VIRS cenas). Izmēru līmeņi: telefons <600 px (lielie burti,
  grafiks 1/3 — svētā 2/3 proporcija), planšete ≥600 px (kompakti, grafiks
  35 %), garš (attiecība >1.5) vai plats (≥1100 px) datora logs — elastīgs
  grafiks līdz 55 %.
- MINI režīms: logs zemāks par 460 px — bez grafika, 2 tuvākās rindas,
  vertikāli centrēts (datora “widget” logs, guļus telefons).
- Fontiem dubultdeklarācija `font-size:Xvmin; font-size:min(Xvmin,Ypx)` —
  vecais iPad Safari `min()` neprot un paliek pie vmin. Viss JS ir ES5
  (vecie Safari uz sienas planšetēm).
- Decimāldaļas kāpne: <1 c → 95 % (`.zem-viena`), 1–10 c → 75 %
  (`.viencipara`), ≥10 c → 55 %.
- Krāsas `COLORS` blokā validētas pret CVD; auksts = lēts, karsts = dārgs.
- Portretā lēto logu rindas ir pogas (skats uz rindas laiku ±30 min, min
  4,5 h); grafiks bīdāms/tālummaināms ar pirkstiem; 2 min bez pieskāriena —
  atpakaļ uz AUTO.

## Testēšana

Lokāli: `python3 -m http.server` šajā mapē + Playwright. Obligātie skati:
360×640 (telefons), 768×1024 (planšete portretā), 1024×768 (siena), garš
logs (830×1800), mini (900×420). JS sintakse: `node --check` pret `<script>`
saturu.

## Keši

GitHub Pages `index.html` ~10 min; māju HA `/local` — 31 diena (pārlāde ar
`?v=` vai Fully Kiosk Clear cache; iPad pats pārlādējas 03:33). `cenas.json`
lapa pati apiet ar `?t=`.
