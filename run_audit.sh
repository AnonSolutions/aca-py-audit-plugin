
export DOCKERHOST=${APPLICATION_URL-$(docker run --rm --net=host eclipse/che-ip)}
export LEDGER_URL=http://${DOCKERHOST}:9000

sleep 5

./run_docker start \
 --endpoint http://${DOCKERHOST}:7020 \
 --inbound-transport http 0.0.0.0 7020 \
 --outbound-transport http --admin 0.0.0.0 7021 \
 --label Faber.Agent \
 --auto-ping-connection \
 --auto-respond-messages \
 --auto-accept-invites \
 --auto-accept-requests \
 --admin-insecure-mode \
 --wallet-type indy \
 --wallet-name audit.agent390822 \
 --wallet-key audit.Agent390822 \
 --preserve-exchange-records \
 --plugin aca_py_audit_proof \
 --genesis-url ${LEDGER_URL}/genesis \
 --trace-target log \
 --trace-tag acapy.events \
 --trace-label Audit.Agent.trace
