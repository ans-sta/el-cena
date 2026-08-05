# el-cena — elektrības cenas displejs

Nord Pool nākamās dienas elektrības cenas Latvijas zonai (c/kWh ar PVN) —
viena HTML lapa, domāta sienas planšetēm un telefoniem kioska režīmā.

**Adrese:** https://el-cena.stabingis.lv

## Viens avots, trīs izvietojumi

`index.html` ir vienīgais UI avots un strādā divos režīmos:

| Izvietojums | Datu avots | Kā nonāk tur |
|---|---|---|
| el-cena.stabingis.lv (GitHub Pages) | `cenas.json` (Elering publiskais API) | `git push` — Pages pats |
| M19 mājas HA (`/local/elektriba.html`) | HA nordpool sensors | `./izvieto.sh` |
| Lauciņu mājas HA | HA nordpool sensors | `./izvieto.sh` |

Režīmu izvēlas `elektriba-config.js`: repo versija ir tukšs aizvietotājs
(publiskais režīms), mājas `config/www/` mapēs ir versija ar HA tokenu —
tā git repo nekad nenonāk.

## Faili

- `index.html` — visa lapa: cena ar vērtējumu, lēto logu saraksts (portretā
  rindas ir pogas, kas pārbīda grafiku uz attiecīgo laiku, skats ≥4,5 h),
  bīdāms/tālummaināms grafiks, tēmas pārslēgs uz pulksteņa.
- `cenas.json` — publiskā režīma cenu krājums (~9 dienas + rītdiena), ko
  1–2× dienā atjauno GitHub Actions darbs `atjauno-cenas.yml`
  (`atjauno_cenas.py`; EUR/MWh × 1,21 / 10 → c/kWh ar PVN).
- `izvieto.sh` — nokopē `index.html` uz abu māju HA `config/www/`.

Datu avots — [Elering publiskais API](https://dashboard.elering.ee/)
(Nord Pool day-ahead cenas). Lapā nav nekādu atslēgu. Personisks,
nekomerciāls projekts.
