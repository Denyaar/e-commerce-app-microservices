#FROM quay.io/keycloak/keycloak:21.0 as builder
FROM quay.io/keycloak/keycloak:26.5.6 as builder

# Configure a database vendor
ENV KC_DB=postgres
 
WORKDIR /opt/keycloak
 
USER root
 
# Set the timezone to CAT (Harare)
RUN ln -sf /usr/share/zoneinfo/Africa/Harare /etc/localtime && echo "Africa/Harare" > /etc/timezone
 
# Switch back to the non-root user
USER 1000

COPY spi/keycloak-captcha-spi-1.0-SNAPSHOT.jar /opt/keycloak/providers/zw.co.ecocashholdings.keycloak-recaptcha-provider.jar

COPY spi/libs/* /opt/keycloak/providers/

#COPY server.keystore conf/server.keystore
#COPY star_ecocashholdings_co_zw.crt .
#COPY ecocashholdings.co.zw.key .
 
#RUN openssl pkcs12 -export -in star_ecocashholdings_co_zw.crt -inkey ecocashholdings.co.zw.key -out temp_keystore.p12 -name server -passout pass:password

#RUN keytool -importkeystore -srckeystore temp_keystore.p12 -srcstoretype PKCS12 -srcstorepass password -destkeystore conf/server.keystore -deststoretype JKS -deststorepass password

#RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore
# Copy SSL certificate and key
#COPY star_ecocashholdings_co_zw.crt /opt/keycloak/conf/server.crt
#COPY ecocashholdings.co.zw.key /opt/keycloak/conf/server.key
# Optionally, if you have intermediate certificates
# COPY intermediate.crt /opt/keycloak/conf/intermediate.crt
 
# Continue with other necessary configurations
 
RUN /opt/keycloak/bin/kc.sh build
 
#FROM quay.io/keycloak/keycloak:latest
#FROM quay.io/keycloak/keycloak:21.0.2
FROM quay.io/keycloak/keycloak:26.5.6
COPY --from=builder /opt/keycloak/ /opt/keycloak/


COPY ./themes/my-theme/ /opt/keycloak/themes/my-theme
COPY ./themes/ecopay/ /opt/keycloak/themes/ecopay
COPY ./themes/open-api-theme/ /opt/keycloak/themes/open-api-theme
#COPY eip_open_api.json  /opt/keycloak/data/import/eip-open-api.json


# Set the timezone to CAT (Harare)
USER root
RUN ln -sf /usr/share/zoneinfo/Africa/Harare /etc/localtime && echo "Africa/Harare" > /etc/timezone
USER 1000
 
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
