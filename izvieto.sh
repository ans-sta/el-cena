#!/bin/sh
# Izvieto index.html uz abām mājām kā /local/elektriba.html.
# Mājas elektriba-config.js (ar tokenu) NETIEK aiztikts — tas dzīvo tikai
# katras mājas config/www/ mapē. Publisko lapu izvieto pats git push (Pages).
set -e
cd "$(dirname "$0")"
cp index.html /Users/minim4/dev/tools/homeassistant/config/www/elektriba.html
echo "M19: nokopēts"
scp -q index.html kri@100.76.73.33:/Users/kri/dev/tools/homeassistant/config/www/elektriba.html
echo "Lauciņi: nokopēts"
echo "Planšetēm kešs: pārlāde ar ?v= vai Fully Kiosk Clear cache; iPad pats 03:33."
