test -f /root/.ssh || mkdir -p /root/.ssh ; chmod 700 /root/.ssh
test -f ${PERSISTENT_DATA_DIR}/id_ecdsa || ssh-keygen -t ecdsa -b 521 -N '' -f ${PERSISTENT_DATA_DIR}/id_ecdsa
test -f /root/.ssh/id_ecdsa || ln -sf ${PERSISTENT_DATA_DIR}/id_ecdsa /root/.ssh/id_ecdsa
alias ppk="cat ${PERSISTENT_DATA_DIR}/id_ecdsa.pub"
echo "NOTE: Use 'ppk' to print the public key for the container."
