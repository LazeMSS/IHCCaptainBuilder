set -e
export LC_ALL=C

source /common.sh
install_cleanup_trap

set +x

# get the installer script
if $BUILDBETAIMG ; then
  echo_green -e "\nStarting IHC Captain BETA installer script\n"
  if [ -n "$XTRABUILDPARAM" ]; then
    echo_green -e "\nExtra build params: $XTRABUILDPARAM\n"
  fi
  wget -q -O installIHC.sh "jemi.dk/ihc/files/install-new" || true
  chmod +x ./installIHC.sh ||true
  # build the image as beta with xtra params if any
  ./installIHC.sh buildimg beta $XTRABUILDPARAM || true
else
  echo_green -e "\nStarting IHC Captain installer script\n"
  if [ -n "$XTRABUILDPARAM" ]; then
    echo_green -e "\nExtra build params: $XTRABUILDPARAM\n"
  fi
  wget -q -O installIHC.sh "jemi.dk/ihc/files/install" || true
  chmod +x ./installIHC.sh ||true
  ./installIHC.sh buildimg $XTRABUILDPARAM || true
fi

rm installIHC.sh || true

# set the date if possible to make the default log files start from the build time of the image
(date --set="$(curl -s "http://worldtimeapi.org/api/timezone/Europe/Copenhagen.txt" | grep "^datetime:" | cut -d " " -f2)") || true
date +"%F %T" > /etc/fake-hwclock.data || true

echo_green -e "\nIHC Captain installer script completed\n"

sleep 5 || true
set -x
