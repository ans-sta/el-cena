#!/bin/sh
# Izvieto lapu uz abām mājām: index.html kā /local/elektriba.html + ikonas.
# Mājas elektriba-config.js (ar tokenu) NETIEK aiztikts — tas dzīvo tikai
# katras mājas config/www/ mapē. Publisko lapu izvieto pats git push (Pages).
set -e
cd "$(dirname "$0")"
IKONAS="favicon.svg favicon-32.png apple-touch-icon.png ikona-192.png ikona-512.png manifest.json"
M19=/Users/minim4/dev/tools/homeassistant/config/www
cp index.html "$M19/elektriba.html"
cp $IKONAS "$M19/"
echo "M19: nokopēts (lapa + ikonas)"
scp -q index.html kri@100.76.73.33:/Users/kri/dev/tools/homeassistant/config/www/elektriba.html
scp -q $IKONAS kri@100.76.73.33:/Users/kri/dev/tools/homeassistant/config/www/
echo "Lauciņi: nokopēts (lapa + ikonas)"
echo "Planšetēm kešs: pārlāde ar ?v= vai Fully Kiosk Clear cache; iPad pats 03:33."
