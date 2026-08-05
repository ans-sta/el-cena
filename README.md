# el-cena — elektrības cenas displejs

Nord Pool nākamās dienas elektrības cenas Latvijas zonai (c/kWh ar PVN) —
viena HTML lapa, domāta sienas planšetēm un telefoniem kioska režīmā.

**Adrese:** https://el-cena.stabingis.lv

## Kā tas strādā

- `index.html` — visa lapa: pašreizējā cena ar vērtējumu, lēto logu saraksts
  un cenu grafiks. Portretā (telefonā) grafiks bīdāms un tālummaināms ar
  pirkstiem, un lēto logu etiķetes ir pogas, kas pārbīda skatu uz attiecīgo
  laiku. Pieskāriens pulkstenim maina tēmu (auto / tumšā / gaišā).
- `cenas.json` — cenu krājums (~9 dienas + rītdiena, kad publicēta), ko
  reizi dienā sagatavo GitHub Actions darbs `atjauno-cenas.yml`, izpildot
  `atjauno_cenas.py`.
- Datu avots — [Elering publiskais API](https://dashboard.elering.ee/)
  (Nord Pool day-ahead cenas). Pārrēķins: EUR/MWh × 1,21 / 10 → c/kWh ar PVN.

Lapā nav nekādu atslēgu vai noslēpumu — viss statisks. Personisks,
nekomerciāls projekts.
