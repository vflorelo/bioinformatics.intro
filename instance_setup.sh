#!/bin/bash
#step1
add-apt-repository universe
apt-get update
apt-get upgrade
apt-get install apache2-ssl-dev apache2-dev apache2-utils python3-certbot-apache certbot cockpit cockpit-bridge cockpit-ws autoconf automake build-essential gcc git libssl-dev make parallel perl python3-pip
#step2
wget http://www.noip.com/client/linux/noip-duc-linux.tar.gz
tar -zxf noip-duc-linux.tar.gz
cd noip-2.1.9-1
make install
echo "[Unit]
Description=noip2 service
[Service]
Type=forking
ExecStart=/usr/local/bin/noip2
Restart=always
[Install]
WantedBy=default.target" > /etc/systemd/system/noip2.service
systemctl daemon-reload
systemctl enable noip2.service
service noip2 restart
groupadd bioinformatics
echo "atgenomics.ddns.net" > /etc/hostname
hostname atgenomics.ddns.net
#step3
cd /usr/bin
ln -s python3 python
pip3 install powerline-shell
pip3 install gsutil
echo "
function _update_ps1() {
	PS1=\$(powerline-shell \$?)
	}
if [[ \$TERM != linux && ! \$PROMPT_COMMAND =~ _update_ps1 ]]
then
	PROMPT_COMMAND=\"_update_ps1; \$PROMPT_COMMAND\"
fi" >>  /etc/profile
#step4
for user in vdiaz rquiroz amejia hmartinez acancino ynaranjo jlmartinez slopez tzavaleta lsanchez ksouza amarina tpacheco rnunez xrodriguez mcampos roropeza vflorelo dianolasa zorbax
do
  useradd --create-home --gid bioinformatics --shell /bin/bash $user
  echo -e "${user}gbm\n${user}gbm" | passwd $user
  mkdir /home/$user/.ssh
  cp /home/ubuntu/.ssh/authorized_keys /home/$user/.ssh
  chown -R $user /home/$user/.ssh
  chgrp -R bioinformatics /home/$user/.ssh
  chmod -R 700 /home/$user/.ssh
done
