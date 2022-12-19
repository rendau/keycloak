FROM quay.io/keycloak/keycloak:20.0.0 as builder

ENV KC_HEALTH_ENABLED=true
# ENV KC_METRICS_ENABLED=true

ENV KC_DB=postgres
ENV KC_TRANSACTION_XA_ENABLED=false

WORKDIR /opt/keycloak
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore
RUN /opt/keycloak/bin/kc.sh build

# ------------------------------

FROM quay.io/keycloak/keycloak:20.0.0
COPY --from=builder /opt/keycloak/ /opt/keycloak/

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
