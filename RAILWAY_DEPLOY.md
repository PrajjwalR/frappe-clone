# 🚂 Deploy Frappe to Railway - Step by Step

## Why Railway?
- ✅ $5 free credit (lasts weeks)
- ✅ PostgreSQL with full permissions
- ✅ Redis included
- ✅ Multi-service support (perfect for Frappe)
- ✅ No credit card needed initially

---

## Step 1: Create Railway Account

1. Go to [railway.app](https://railway.app)
2. Click **"Start a New Project"** or **"Login with GitHub"**
3. Authorize Railway to access your GitHub repos

---

## Step 2: Create New Project

1. Click **"New Project"**
2. Select **"Deploy from GitHub repo"**
3. Choose your repository: **`PrajjwalR/frappe-clone`**
4. Railway will detect the Dockerfile automatically

---

## Step 3: Add Database & Redis

### Add PostgreSQL:
1. In your project dashboard, click **"+ New"**
2. Select **"Database"** → **"Add PostgreSQL"**
3. Wait for it to provision (~30 seconds)

### Add Redis:
1. Click **"+ New"** again
2. Select **"Database"** → **"Add Redis"**
3. Wait for it to provision (~30 seconds)

---

## Step 4: Configure Environment Variables

1. Click on your **frappe-clone** service (the web app)
2. Go to **"Variables"** tab
3. Click **"+ New Variable"** and add these:

### Railway Auto-Variables (Already Available):
- `DATABASE_URL` - Automatically set by Railway PostgreSQL
- `REDIS_URL` - Automatically set by Railway Redis

### Manual Variables to Add:
| Variable Name | Value |
|---------------|-------|
| `FRAPPE_SITE_NAME` | `frappe.railway.app` |
| `PORT` | `8000` |

4. Click **"Deploy"** or wait for auto-deploy

---

## Step 5: Wait for Deployment

1. Go to **"Deployments"** tab
2. Click on the latest deployment
3. Watch the logs - you should see:

```
====================================
🚀 Starting Frappe initialization...
====================================
📋 Environment Variables:
  - PORT: 8000
  - DATABASE_URL: ✅ Set
  - REDIS_URL: ✅ Set

✅ Database is ready!
📦 Creating new Frappe site...
✅ Site created successfully!
🎉 Initialization Complete!
```

**Deployment takes ~5-7 minutes** (database setup is slow first time)

---

## Step 6: Access Your Frappe Site

1. Go to **"Settings"** tab
2. Find **"Domains"** section
3. You'll see a URL like: `https://frappe-clone-production.up.railway.app`
4. Click it!

### Login Credentials:
- **Username**: `Administrator`
- **Password**: `admin`

---

## 🎉 Success!

You should now see the full Frappe login page and ERPNext interface!

---

## Troubleshooting

### If deployment fails:
1. Check logs in **"Deployments"** tab
2. Look for specific error messages
3. Most common issue: not enough free credit (check billing)

### If site doesn't load:
1. Wait 2 more minutes (initialization can be slow)
2. Check logs for "Site created successfully"
3. Try accessing via direct Railway domain

### If you see 404:
- Site is still initializing - wait and refresh

---

## Cost Estimate

With $5 free credit:
- PostgreSQL: ~$1/month
- Redis: ~$0.50/month  
- Web service: ~$1-2/month

**Total: ~$2.50-3.50/month = Your $5 lasts ~6-8 weeks!**

After free credit expires, you can:
- Add credit card for paid tier
- Delete project
- Export data and move elsewhere
