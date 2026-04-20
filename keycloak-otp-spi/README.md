# EcoCash Keycloak OTP Authenticator SPI

Custom Keycloak authentication provider that implements OTP (One-Time Password) verification via SMS (Twilio) and Email (SMTP).

## Features

- ✅ OTP generation and validation
- ✅ SMS delivery via Twilio
- ✅ Email delivery via SMTP
- ✅ Configurable via environment variables
- ✅ 6-digit OTP codes
- ✅ 5-minute expiry time
- ✅ Custom EcoCash-themed emails

## Build

```bash
mvn clean package
```

The JAR file will be created in `target/keycloak-otp-spi.jar`

## Installation

1. Copy the JAR to Keycloak providers directory:
   ```bash
   cp target/keycloak-otp-spi.jar /opt/keycloak/providers/
   ```

2. Rebuild Keycloak (for production mode):
   ```bash
   /opt/keycloak/bin/kc.sh build
   ```

3. Restart Keycloak

## Configuration

### Environment Variables

#### Twilio (SMS)
- `TWILIO_ACCOUNT_SID` - Your Twilio Account SID
- `TWILIO_AUTH_TOKEN` - Your Twilio Auth Token
- `TWILIO_PHONE_NUMBER` - Your Twilio phone number (E.164 format)

#### SMTP (Email)
- `SMTP_HOST` - SMTP server host (default: smtp.gmail.com)
- `SMTP_PORT` - SMTP server port (default: 587)
- `SMTP_USERNAME` - SMTP username
- `SMTP_PASSWORD` - SMTP password
- `SMTP_FROM_EMAIL` - From email address (default: noreply@ecocash.co.zw)
- `SMTP_FROM_NAME` - From name (default: EcoCash)
- `SMTP_USE_TLS` - Use TLS (default: true)

## Usage

1. In Keycloak Admin Console, go to **Authentication** → **Flows**
2. Create a new flow or edit existing (e.g., "Browser" flow)
3. Add execution: **EcoCash OTP Authentication**
4. Set requirement to **REQUIRED** or **ALTERNATIVE**

## User Attributes

Users must have one of these attributes:
- `phoneNumber` - For SMS OTP (E.164 format, e.g., +263771234567)
- `email` - For Email OTP

The authenticator will prefer SMS if both are available and Twilio is configured.