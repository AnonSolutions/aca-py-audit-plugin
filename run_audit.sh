
export DOCKERHOST=${APPLICATION_URL-$(docker run --rm --net=host eclipse/che-ip)}
export LEDGER_URL=http://${DOCKERHOST}:9000
export DID_SEED=d_000000000000000000000000390822

curl -d "{\"seed\":\"${DID_SEED}\", \"role\":\"TRUST_ANCHOR\", \"alias\":\"Audit.Agent\"}" -X POST http://localhost:9000/register

sleep 5

./run_docker start \
 --endpoint http://${DOCKERHOST}:8020 \
 --inbound-transport http 0.0.0.0 8020 \
 --outbound-transport http --admin 0.0.0.0 8021 \
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
 --plugin aca-py-audit-plugin \
 --plugin aca_py_audit_plugin \
 --genesis-url ${LEDGER_URL}/genesis \
 --seed ${DID_SEED} \
 --webhook-url http://${DOCKERHOST}:8022/webhooks \
 --trace-target log \
 --trace-tag acapy.events \
 --trace-label Audit.Agent.trace
