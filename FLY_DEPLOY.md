# 🚀 Deploy Frappe to Fly.io - Complete Guide

## Prerequisites
✅ Fly.io account (free tier)
✅ Credit card for verification (NOT charged on free tier)
✅ flyctl CLI installed

---

## Step 1: Install Fly CLI (Already Done!)

```bash
brew install flyctl
```

---

## Step 2: Sign Up & Login

```bash
# Sign up/login to Fly.io
flyctl auth signup

# Or if you already have account
flyctl auth login
```

This will open your browser for authentication.

---

## Step 3: Create Fly App

```bash
cd /Users/prajjwalrchuahna/newOne/frappe-bench

# Launch the app (this creates fly.toml)
flyctl launch --no-deploy

# Answer the prompts:
# - App name: frappe-clone (or your choice)
# - Region: Choose closest to you (e.g., sin for Singapore, lhr for London)
# - PostgreSQL: YES
# - Redis: YES
# - Deploy now: NO
```

---

## Step 4: Configure Environment Variables

```bash
# Set Frappe site name
flyctl secrets set FRAPPE_SITE_NAME=frappe-clone.fly.dev

# Database and Redis URLs are automatically set by Fly.io
```

---

## Step 5: Review fly.toml

The `fly.toml` file should already be created. Make sure it has:

```toml
[build]
  dockerfile = "Dockerfile"

[env]
  PORT = "8000"

[[services]]
  http_checks = []
  internal_port = 8000
  processes = ["app"]
  protocol = "tcp"

  [[services.ports]]
    force_https = true
    handlers = ["http"]
    port = 80

  [[services.ports]]
    handlers = ["tls", "http"]
    port = 443
```

---

## Step 6: Deploy!

```bash
# Deploy your app
flyctl deploy

# This will:
# - Build your Docker image
# - Upload to Fly.io
# - Start your app
# - Connect to PostgreSQL and Redis
```

**Deployment takes ~5-10 minutes**

---

## Step 7: Monitor Deployment

```bash
# Watch logs in real-time
flyctl logs

# Check app status
flyctl status

# Open app in browser
flyctl open
```

---

## Step 8: Access Your Frappe Site

Your app will be available at:
```
https://frappe-clone.fly.dev
```

### Login Credentials:
- **Username**: `Administrator`
- **Password**: `admin`

---

## Fly.io Free Tier Details

### What's Included (FREE):
- ✅ 3 shared-cpu VMs  
- ✅ 3GB persistent volume storage
- ✅ 160GB outbound data transfer
- ✅ PostgreSQL database (3GB)
- ✅ Redis (256MB)

### What You Get:
- **PostgreSQL**: Included, full permissions
- **Redis**: Included, perfect for Frappe
- **Domain**: `your-app.fly.dev`
- **SSL**: Free HTTPS certificate

---

## Useful Commands

```bash
# View logs
flyctl logs

# SSH into your app
flyctl ssh console

# Check PostgreSQL
flyctl postgres connect -a frappe-clone-db

# Restart app
flyctl apps restart frappe-clone

# Scale (if needed)
flyctl scale count 1

# Delete app (if needed)
flyctl apps destroy frappe-clone
```

---

## Troubleshooting

### If deployment fails:

```bash
# Check logs
flyctl logs

# Check status
flyctl status

# Restart
flyctl apps restart
```

### If site doesn't load:
1. Wait 2-3 minutes after deployment
2. Check logs: `flyctl logs`
3. Look for "Site created successfully!"

### Common Issues:

**"Out of memory"**
```bash
# Scale to larger VM (paid)
flyctl scale vm shared-cpu-2x
```

**"Database connection failed"**
```bash
# Check database status
flyctl postgres list
```

---

## Cost Breakdown

### Free Tier (No Charges):
- App: FREE (within limits)
- PostgreSQL: FREE (3GB)
- Redis: FREE (256MB)
- Total: **$0/month** ✅

### If You Exceed Free Tier:
- Extra VM: ~$2/month
- Extra storage: ~$0.15/GB/month
- Still cheaper than Railway!

---

## Next Steps After Deployment

1. **Set up custom domain** (optional):
   ```bash
   flyctl certs add yourdomain.com
   ```

2. **Set up backups**:
   ```bash
   flyctl postgres backup
   ```

3. **Monitor usage**:
   ```bash
   flyctl dashboard
   ```

---

## Summary

Fly.io is perfect for Frappe because:
- ✅ True free tier (no time limit)
- ✅ PostgreSQL with full permissions
- ✅ Redis included
- ✅ Good for multi-service apps
- ✅ Professional infrastructure
- ✅ Easy CLI deployment

**You're all set! Follow the steps above and you'll have Frappe running in ~15 minutes!** 🎉
