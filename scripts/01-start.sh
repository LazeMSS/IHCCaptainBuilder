set -e
export LC_ALL=C

source /common.sh
install_cleanup_trap

set +x
echo_green -e "\nStarting IHC Captain installer script\n"

# get the installer script (new for now)
if [ -n "$BUILDBETAIMG" ]; then
  wget -q -O installIHC.sh "jemi.dk/ihc/files/install-new" || true
  chmod +x ./installIHC.sh ||true
  # build the image as beta
  ./installIHC.sh beta buildimg $XTRABUILDPARAM || true
else
  wget -q -O installIHC.sh "jemi.dk/ihc/files/install" || true
  chmod +x ./installIHC.sh ||true
  # build the image as beta
  ./installIHC.sh buildimg $XTRABUILDPARAM || true
fi

rm installIHC.sh || true

# set the date if possible to make the default log files start from the build time of the image
(date --set="$(curl -s "http://worldtimeapi.org/api/timezone/Europe/Copenhagen.txt" | grep "^datetime:" | cut -d " " -f2)") || true
date +"%F %T" > /etc/fake-hwclock.data || true

echo_green -e "\nIHC Captain installer script completed\n"

sleep 5 || true
set -x
