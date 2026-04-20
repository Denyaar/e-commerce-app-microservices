FROM maven:3.9.9-eclipse-temurin-21 AS otp-spi-builder

WORKDIR /build

COPY keycloak-otp-spi/pom.xml keycloak-otp-spi/pom.xml
COPY keycloak-otp-spi/src keycloak-otp-spi/src

RUN mvn -q -f keycloak-otp-spi/pom.xml clean package

FROM quay.io/keycloak/keycloak:26.5.6

# Copy custom OTP SPI built from source
COPY --from=otp-spi-builder /build/keycloak-otp-spi/target/keycloak-otp-spi.jar /opt/keycloak/providers/

# Copy custom theme
COPY --chown=keycloak:keycloak keycloak/themes/ /opt/keycloak/themes/

# Build Keycloak with the custom providers
RUN /opt/keycloak/bin/kc.sh build
