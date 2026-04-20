# EcoCash Keycloak OTP Configuration Guide

Complete guide for configuring OTP authentication behavior through the Keycloak Admin Console.

---

## 🎯 Configuration Options

Your OTP authenticator now supports **5 configurable options** that you can change from the Keycloak Admin Console without touching code!

### Available Settings:

| Setting | Type | Options | Default | Description |
|---------|------|---------|---------|-------------|
| **OTP Delivery Method** | Dropdown | `auto`, `sms`, `email` | `auto` | How to send OTP codes |
| **OTP Code Length** | Number | 4-8 digits | `6` | Length of generated code |
| **OTP Expiry (minutes)** | Number | 1-60 minutes | `5` | How long code is valid |
| **Allow Resend OTP** | Boolean | true/false | `true` | Let users request new code |
| **Require Phone Number** | Boolean | true/false | `false` | Enforce phone number attribute |

---

## 📋 How to Configure

### Step 1: Access Authentication Flows

1. Login to Keycloak Admin Console: http://localhost:8443
2. Go to **Authentication** → **Flows**
3. Select your flow (e.g., "Browser with OTP")
4. Click the **⚙️ gear icon** next to "EcoCash OTP Authentication"

### Step 2: Configure Settings

You'll see a configuration form with these fields:

#### 🔹 OTP Delivery Method
```
Options:
  - auto   → Try SMS first, fallback to Email
  - sms    → Only send via SMS (fail if no phone)
  - email  → Only send via Email (fail if no email)

Default: auto
```

**Use Cases:**
- `auto` - Best for most cases, flexible
- `sms` - High-security apps requiring phone verification
- `email` - Cost-effective, no SMS fees

#### 🔹 OTP Code Length
```
Range: 4-8 digits
Default: 6

Examples:
  - 4 digits: 1234
  - 6 digits: 123456 (recommended)
  - 8 digits: 12345678
```

**Use Cases:**
- `4` - Faster user input, less secure
- `6` - **Recommended** balance of security & UX
- `8` - Maximum security, slower input

#### 🔹 OTP Expiry (minutes)
```
Range: 1-60 minutes
Default: 5

Examples:
  - 1 minute  → Quick expiry, high security
  - 5 minutes → Recommended default
  - 10 minutes → More user-friendly
  - 30 minutes → Development/testing
```

**Use Cases:**
- `1-2 min` - Banking, high-security apps
- `5 min` - **Recommended** for most apps
- `10+ min` - Slower SMS delivery networks

#### 🔹 Allow Resend OTP
```
Options: true / false
Default: true
```

**When to use:**
- ✅ `true` - Production (SMS might be delayed)
- ❌ `false` - Testing (prevent OTP spam)

#### 🔹 Require Phone Number
```
Options: true / false
Default: false
```

**When to use:**
- ✅ `true` - SMS-only apps, strict identity verification
- ❌ `false` - Allow email fallback

---

## 🎮 Configuration Examples

### Example 1: Banking App (High Security)
```yaml
OTP Delivery Method: sms
OTP Code Length: 8
OTP Expiry (minutes): 2
Allow Resend OTP: false
Require Phone Number: true
```

**Why?**
- SMS only (no email fallback)
- 8-digit codes for maximum security
- 2-minute expiry (quick timeout)
- No resend (prevent abuse)
- Phone required (strict identity)

### Example 2: E-Commerce (Balanced)
```yaml
OTP Delivery Method: auto
OTP Code Length: 6
OTP Expiry (minutes): 5
Allow Resend OTP: true
Require Phone Number: false
```

**Why?**
- Auto delivery (flexible)
- 6-digit codes (standard)
- 5-minute expiry (user-friendly)
- Allow resend (better UX)
- Phone optional (email fallback)

### Example 3: Internal Portal (Low Security)
```yaml
OTP Delivery Method: email
OTP Code Length: 4
OTP Expiry (minutes): 10
Allow Resend OTP: true
Require Phone Number: false
```

**Why?**
- Email only (no SMS costs)
- 4-digit codes (faster input)
- 10-minute expiry (relaxed)
- Allow resend (flexible)
- Email only needed

### Example 4: Development/Testing
```yaml
OTP Delivery Method: email
OTP Code Length: 4
OTP Expiry (minutes): 30
Allow Resend OTP: true
Require Phone Number: false
```

**Why?**
- Email (check MailDev at localhost:1080)
- Short codes (easy to type)
- Long expiry (no rush during testing)
- Resend enabled
- No phone needed

---

## 🔄 Enable/Disable OTP Completely

### Option 1: Flow Requirement (Easy)

**In Admin Console:**

1. **Authentication** → **Flows**
2. Select your flow
3. Find "EcoCash OTP Authentication"
4. Change requirement dropdown:

```
REQUIRED     → Always ask for OTP ✅
ALTERNATIVE  → OTP is optional
DISABLED     → OTP completely off ❌
CONDITIONAL  → Use conditions
```

**This is instant** - no code rebuild needed!

### Option 2: Bind Different Flow

Keep multiple flows:
- "Browser" - No OTP
- "Browser with OTP" - With OTP

**Switch between them:**
1. **Authentication** → **Bindings**
2. Change **Browser Flow** dropdown
3. Save

---

## 🎯 Per-User Configuration

### Disable OTP for Specific Users

**Option 1: Remove Phone/Email**
```bash
# In Keycloak Admin Console:
Users → Select user → Attributes
→ Remove "phoneNumber" attribute
→ Save
```

**Option 2: User Groups**

Create different flows for different user groups:
1. Create group "Admin" → Require OTP
2. Create group "Users" → No OTP
3. Use conditional authenticators

### Enable SMS for Some, Email for Others

**Based on phoneNumber attribute:**
```yaml
# User with phone → Gets SMS
phoneNumber: +263771234567

# User without phone → Gets Email
(no phoneNumber attribute)
```

The `auto` delivery method handles this automatically!

---

## 🧪 Testing Different Configurations

### Test Quickly Without Rebuilding

1. **Change config** in Admin Console
2. **Logout** from all sessions
3. **Try login** again
4. **Check logs** for configuration:
   ```bash
   docker logs ms_keycloak | grep "OTP"
   ```

### Verify Config is Applied

Check logs when user logs in:
```bash
docker logs -f ms_keycloak
```

You'll see:
```
INFO  OTP length: 6
INFO  OTP expiry: 5 minutes
INFO  OTP method: auto
INFO  OTP sent successfully to user: john via sms
```

---

## 📱 SMS vs Email Decision Tree

```
User logs in
     ↓
Check Config "OTP Method"
     ↓
┌────┴────┐
│  AUTO?  │
└────┬────┘
     ↓ YES
Check user has phoneNumber?
     ↓
┌────┴────┐
│   YES?  │
└────┬────┘
     ↓ YES
Check Twilio configured?
     ↓
┌────┴────┐
│   YES?  │──→ Send SMS ✅
└────┬────┘
     ↓ NO
Check user has email?
     ↓
┌────┴────┐
│   YES?  │──→ Send Email 📧
└────┬────┘
     ↓ NO
     FAIL ❌
```

---

## 🔧 Troubleshooting

### Config Not Working?

1. **Rebuild SPI:**
   ```bash
   ./build-keycloak-spi.sh
   ```

2. **Clear browser cache**

3. **Check config is saved:**
   ```bash
   Authentication → Flows → Click ⚙️ gear icon
   ```

4. **Check logs:**
   ```bash
   docker logs ms_keycloak | grep "CONFIG"
   ```

### OTP Always Uses Default Values?

Make sure you clicked **Save** after configuring!

### Config UI Not Showing?

Verify `isConfigurable()` returns `true`:
```bash
# Check SPI is loaded
docker exec ms_keycloak ls /opt/keycloak/providers/
```

Should see: `keycloak-otp-spi.jar`

---

## 📊 Recommended Settings by Industry

### Banking / Finance
```yaml
Method: sms
Length: 8
Expiry: 2
Resend: false
Phone Required: true
```

### E-Commerce
```yaml
Method: auto
Length: 6
Expiry: 5
Resend: true
Phone Required: false
```

### Healthcare
```yaml
Method: sms
Length: 6
Expiry: 3
Resend: true
Phone Required: true
```

### Social Media
```yaml
Method: auto
Length: 4
Expiry: 10
Resend: true
Phone Required: false
```

### Internal Tools
```yaml
Method: email
Length: 4
Expiry: 15
Resend: true
Phone Required: false
```

---

## 🚀 Production Checklist

Before going live:

- [ ] Test OTP with real phone number
- [ ] Test OTP with real email
- [ ] Verify expiry timeout works
- [ ] Test resend functionality
- [ ] Test SMS fallback to email
- [ ] Set appropriate OTP length
- [ ] Configure reasonable expiry time
- [ ] Enable/disable resend based on security needs
- [ ] Document settings for your team
- [ ] Monitor OTP delivery rates
- [ ] Set up alerts for failed OTPs

---

## 💡 Tips

1. **Start with `auto`** - Most flexible
2. **Use 6-digit codes** - Industry standard
3. **5-minute expiry** - Good balance
4. **Enable resend** - Better UX
5. **Don't require phone** - Unless necessary
6. **Test in dev** first - Long expiry (30 min)
7. **Monitor costs** - SMS can be expensive
8. **Have fallbacks** - Email as backup

---

## 📚 Related Documentation

- **Setup Guide:** `KEYCLOAK_SETUP.md`
- **Full Documentation:** `keycloak/README.md`
- **Implementation:** `IMPLEMENTATION_SUMMARY.md`

---

**Questions?** Check the logs: `docker logs -f ms_keycloak`