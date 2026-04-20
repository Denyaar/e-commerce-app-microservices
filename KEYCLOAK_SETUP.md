# Quick Start: EcoCash Keycloak Setup

## 1️⃣ Build the OTP SPI

```bash
cd /Users/tendaimupezeni/Projects/ZEcocash-Projects/developer-portal/keycloak-otp-spi
mvn clean package
```

## 2️⃣ Create Keycloak Database

```bash
docker exec -it ms_pd_sql psql -U root -d postgres -c "CREATE DATABASE keycloak;"
```

## 3️⃣ Configure Environment

Create `.env` file with your Twilio and SMTP credentials:

```bash
# Copy example and edit
cp .env.example .env
nano .env
```

## 4️⃣ Start Keycloak

```bash
docker-compose up -d keycloak
```

## 5️⃣ Access Admin Console

🌐 **URL:** http://localhost:8443

👤 **Login:**
- Username: `mupezeni`
- Password: `Mupezeni0102?`

## 6️⃣ Configure Authentication Flow

1. **Authentication** → **Flows**
2. **Copy** "Browser" flow → Name: "Browser with OTP"
3. **Add execution** → "EcoCash OTP Authentication"
4. Set to **REQUIRED**
5. **Bind** → Set as Browser Flow

## 7️⃣ Apply Custom Theme

1. **Realm Settings** → **Themes**
2. **Login theme** → `ecocash`
3. **Save**

## 8️⃣ Add User Phone Number

1. **Users** → Select user
2. **Attributes** tab
3. Add: `phoneNumber` = `+263771234567`
4. **Save**

## ✅ Test Login

http://localhost:8443/realms/master/account

---

## 📱 OTP Delivery Methods

- **SMS:** Requires `phoneNumber` attribute + Twilio config
- **Email:** Requires user email + SMTP config

## 🎨 Theme Features

- ✨ EcoCash-branded dark theme
- 📱 Responsive design
- 🔐 OTP verification page
- 🔑 Password reset pages
- 🎯 Custom styling with #0052A5 and #E30613 colors

## 🔧 Quick Commands

```bash
# View logs
docker logs -f ms_keycloak

# Restart Keycloak
docker-compose restart keycloak

# Rebuild SPI
cd /Users/tendaimupezeni/Projects/ZEcocash-Projects/developer-portal/keycloak-otp-spi && mvn clean package && cd -
docker-compose restart keycloak

# Check theme files
docker exec ms_keycloak ls /opt/keycloak/themes/ecocash

# Check SPI
docker exec ms_keycloak ls /opt/keycloak/providers/

# Check database
docker exec -it ms_pd_sql psql -U root -l
```

## 📋 Checklist

- [ ] SPI built successfully
- [ ] Keycloak database created
- [ ] `.env` file configured
- [ ] Keycloak started (check logs)
- [ ] Admin console accessible
- [ ] OTP flow configured
- [ ] Custom theme applied
- [ ] User phone number added
- [ ] Login tested successfully

## ⚠️ Common Issues

**Keycloak won't start:**
- Check PostgreSQL is running: `docker ps | grep postgres`
- Check database exists: `docker exec -it ms_pd_sql psql -U root -l`

**OTP not sending:**
- Verify `.env` credentials
- Check logs: `docker logs ms_keycloak | grep OTP`

**Theme not showing:**
- Clear browser cache
- Try incognito mode
- Restart Keycloak

**SPI not loading:**
- Verify JAR built: `ls /Users/tendaimupezeni/Projects/ZEcocash-Projects/developer-portal/keycloak-otp-spi/target/keycloak-otp-spi.jar`
- Restart Keycloak after building

---

📖 **Full documentation:** See `keycloak/README.md`