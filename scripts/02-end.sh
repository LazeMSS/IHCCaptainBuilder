set -e
export LC_ALL=C

source /common.sh
install_cleanup_trap

set +x
echo_green -e "\nStarting IHC Captain cleanup script\n"
set -x

# clean packages
apt-get --yes autoclean  || true
apt-get --yes clean  || true

# clean log2ram if any
rm -rf /var/hdd.log/* || true
rm -rf /opt/ihccaptain/tmp/hdd.ihccaptain/* || true
rm -rf /opt/ihccaptain/tmp/ihccaptain/* || true

# clean logs - hardcore
rm -rf /tmp/*  || true
journalctl --vacuum-time=1s  || true
journalctl --vacuum-size=1M  || true
find /var/log/ -type f -print0 | xargs -0 truncate --size 0  || true

# clean dns resolver
cp /dev/null /etc/resolv.conf || true

# clean ihc captain data folders
find /opt/ihccaptain/data/ -type f -not -name "serverconfig.json" -delete || true
rm -rf /opt/ihccaptain/monitor/*.pid || true

# Cleanup root home dir
rm -f /root/.lesshst  || true
rm -f /root/.ssh/known_hosts  || true
truncate -s 0 /root/.bash_history || true
rm -rf /root/.npm  || true

# remove the common file from custompizer
rm -f /common.sh || true

set +x
echo_green -e "\nIHC Captain cleanup script completed\n"
set -x

#wait
sleep 5 || true
