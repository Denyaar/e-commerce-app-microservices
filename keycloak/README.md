# EcoCash Keycloak Custom Authentication Setup

Complete implementation of Keycloak with custom OTP authentication (SMS/Email) and EcoCash-themed login pages.

## Features

✅ **Custom OTP Authentication**
- SMS delivery via Twilio
- Email delivery via SMTP
- 6-digit OTP codes with 5-minute expiry
- Automatic OTP validation

✅ **PostgreSQL Database**
- Keycloak data persisted in PostgreSQL
- Connection to existing `ms_pd_sql` container
- Automatic database initialization

✅ **Custom EcoCash Theme**
- Dark-themed login pages matching EcoCash brand
- Custom OTP verification page
- Password reset/update pages
- Responsive design
- EcoCash color scheme (#0052A5, #E30613)

## Project Structure

```
keycloak/
├── themes/
│   └── ecocash/
│       ├── theme.properties
│       └── login/
│           ├── login.ftl                    # Main login page
│           ├── login-otp.ftl                # OTP verification page
│           ├── login-reset-password.ftl     # Password reset page
│           ├── login-update-password.ftl    # Update password page
│           ├── template.ftl                 # Base template
│           ├── messages/
│           │   └── messages_en.properties   # English messages
│           └── resources/
│               └── css/
│                   └── styles.css           # Custom EcoCash styles
│
../ZEcocash-Projects/developer-portal/keycloak-otp-spi/
├── pom.xml                                  # Maven configuration
└── src/main/java/com/ecocash/keycloak/otp/
    ├── OTPConfig.java                       # Configuration constants
    ├── OTPGenerator.java                    # OTP generation & validation
    ├── SMSService.java                      # Twilio SMS integration
    ├── EmailService.java                    # SMTP email integration
    ├── OTPAuthenticator.java                # Main authenticator
    └── OTPAuthenticatorFactory.java         # SPI factory
```

## Prerequisites

1. **Java 25** - For building the SPI
2. **Maven** - For building the SPI
3. **Docker & Docker Compose** - For running services
4. **PostgreSQL** - Already running in `ms_pd_sql` container
5. **Twilio Account** (optional) - For SMS OTP
6. **SMTP Server** (optional) - For Email OTP

## Setup Instructions

### Step 1: Configure Environment Variables

Create a `.env` file in the project root:

```bash
cp .env.example .env
```

Edit `.env` and add your credentials:

```env
# Twilio Configuration (for SMS OTP)
TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=your_auth_token
TWILIO_PHONE_NUMBER=+1234567890

# SMTP Configuration (for Email OTP)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your_email@gmail.com
SMTP_PASSWORD=your_app_password
SMTP_FROM_EMAIL=noreply@ecocash.co.zw
SMTP_FROM_NAME=EcoCash
SMTP_USE_TLS=true
```

### Step 2: Build the OTP SPI

```bash
cd ../ZEcocash-Projects/developer-portal/keycloak-otp-spi
mvn clean package
```

This will create `target/keycloak-otp-spi.jar`

### Step 3: Initialize Keycloak Database

Connect to PostgreSQL and create the Keycloak database:

```bash
docker exec -it ms_pd_sql psql -U root -d postgres
```

```sql
CREATE DATABASE keycloak;
\q
```

### Step 4: Start Keycloak

```bash
docker-compose up -d keycloak
```

Wait for Keycloak to start (check logs):

```bash
docker logs -f ms_keycloak
```

### Step 5: Access Keycloak Admin Console

Open: http://localhost:8443

Login with:
- Username: `mupezeni`
- Password: `Mupezeni0102?`

### Step 6: Configure OTP Authentication Flow

1. Go to **Authentication** → **Flows**
2. Click **Copy** on the "Browser" flow → Name it "Browser with OTP"
3. In the copied flow, remove or disable the default **Username Password Form**
4. Click **Add execution** → Select "EcoCash Username Password Form"
5. Set that execution to **REQUIRED**
6. Click **Add execution** → Select "EcoCash OTP Authentication"
7. Set that execution to **REQUIRED**
8. Click **Bind** at the top → Set as **Browser Flow**

### Step 7: Set Custom Theme

1. Go to **Realm Settings** → **Themes**
2. Set **Login theme** to `ecocash`
3. Click **Save**

### Step 8: Configure User Attributes

For users to receive OTP, they need:

**For SMS OTP:**
- Add attribute: `phoneNumber` = `+263771234567` (E.164 format)

**For Email OTP:**
- User must have an email address

To add user attributes:
1. Go to **Users** → Select user
2. Click **Attributes** tab
3. Add key: `phoneNumber`, Value: `+263771234567`
4. Click **Add** then **Save**

## Testing

### Test SMS OTP

1. Create a user with `phoneNumber` attribute
2. Try to login at: http://localhost:8443/realms/master/account
3. After username/password, you'll receive SMS with OTP code
4. Enter the 6-digit code

### Test Email OTP

1. Create a user with email address (no phone number)
2. Try to login
3. After username/password, you'll receive email with OTP code
4. Enter the 6-digit code

### Test Password Reset

1. Click "Forgot password?" on login page
2. Enter username/email
3. Receive reset email
4. Follow link to reset password

## Troubleshooting

### Keycloak won't start

Check logs:
```bash
docker logs ms_keycloak
```

Common issues:
- PostgreSQL not running: `docker-compose up -d postgres`
- Database not created: Follow Step 3
- Port 8443 in use: Change port in docker-compose.yml

### OTP not sending

Check environment variables are set:
```bash
docker exec ms_keycloak env | grep TWILIO
docker exec ms_keycloak env | grep SMTP
```

Check logs:
```bash
docker logs ms_keycloak | grep OTP
```

### Theme not applying

1. Verify theme files exist:
   ```bash
   docker exec ms_keycloak ls /opt/keycloak/themes/ecocash
   ```

2. Clear browser cache and try incognito mode

3. Restart Keycloak:
   ```bash
   docker-compose restart keycloak
   ```

### SPI not loading

1. Verify JAR exists:
   ```bash
   docker exec ms_keycloak ls /opt/keycloak/providers/
   ```

2. Rebuild and restart:
   ```bash
   cd ../ZEcocash-Projects/developer-portal/keycloak-otp-spi
   mvn clean package
   docker-compose restart keycloak
   ```

## Development

### Rebuild SPI

```bash
cd ../ZEcocash-Projects/developer-portal/keycloak-otp-spi
mvn clean package
docker-compose restart keycloak
```

### Update Theme

Theme files are mounted as volume, so changes are reflected after browser refresh (no restart needed).

For template changes (`.ftl` files), clear browser cache.

## Configuration Options

### OTP Settings

Edit `OTPConfig.java` to customize:
- `OTP_LENGTH` - Length of OTP code (default: 6)
- `OTP_EXPIRY_MINUTES` - Expiry time (default: 5 minutes)

### Email Template

Edit `EmailService.java` → `buildEmailHTML()` method to customize email design.

### SMS Message

Edit `SMSService.java` → `sendOTP()` method to customize SMS message.

## Security Notes

- Store credentials in `.env` file, never commit to git
- Use app-specific passwords for Gmail SMTP
- Enable 2FA on Twilio account
- Use strong passwords for Keycloak admin
- Enable HTTPS in production
- Rotate OTP secrets regularly

## Production Deployment

For production:

1. **Enable HTTPS:**
   ```yaml
   KC_HOSTNAME_STRICT: "true"
   KC_HTTPS_ENABLED: "true"
   ```

2. **Use production database:**
   ```yaml
   KC_DB_URL: jdbc:postgresql://prod-db:5432/keycloak
   ```

3. **Remove dev mode:**
   ```yaml
   command:
     - "start"
     - "--optimized"
   ```

4. **Enable proper logging:**
   ```yaml
   KC_LOG_LEVEL: info
   ```

5. **Build optimized image:**
   ```bash
   docker-compose exec keycloak /opt/keycloak/bin/kc.sh build
   ```

## Support

For issues or questions:
- Check Keycloak logs: `docker logs ms_keycloak`
- Check SPI logs for OTP-related issues
- Verify environment variables are set correctly
- Test Twilio/SMTP credentials independently

## License

Internal use only - EcoCash Developer Portal
