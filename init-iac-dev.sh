test -f /root/.ssh || mkdir -p /root/.ssh ; chmod 700 /root/.ssh
test -f ${PERSISTENT_DATA_DIR}/id_rsa || ssh-keygen -t rsa -b 4096 -N '' -f ${PERSISTENT_DATA_DIR}/id_rsa
test -f /root/.ssh/id_rsa || ln -sf ${PERSISTENT_DATA_DIR}/id_rsa /root/.ssh/id_rsa
test -f /root/.aws || mkdir -p /root/.aws ; chmod 700 /root/.aws
test -f /root/.aws/config || ln -sf ${PERSISTENT_DATA_DIR}/aws-config /root/.aws/config
test -f /root/.aws/credentials || ln -sf ${PERSISTENT_DATA_DIR}/aws-credentials /root/.aws/credentials
chmod 600 /root/.aws/credentials
alias ppk="cat ${PERSISTENT_DATA_DIR}/id_rsa.pub"
alias help="cat /etc/help.txt | /usr/games/cowsay -n | /usr/games/lolcat"

help
