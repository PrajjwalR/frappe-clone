# 🆓 Free Frappe Deployment Guide
## Setup Free Database + Redis for Render

### Step 1: Create Free PostgreSQL Database (Supabase)

1. Go to [supabase.com](https://supabase.com)
2. Click **"Start your project"** → Sign up with GitHub
3. Click **"New Project"**
   - Organization: Create new or use existing
   - Name: `frappe-db`
   - Database Password: Create a strong password (SAVE THIS!)
   - Region: Choose closest to you
   - Click **"Create new project"**
4. Wait 2-3 minutes for database to initialize
5. Go to **Settings** → **Database** → Find **Connection String**
6. Copy the **"URI"** connection string (looks like):
   ```
   postgresql://postgres.[project-ref]:[password]@aws-0-us-west-1.pooler.supabase.com:6543/postgres
   ```
7. **SAVE THIS URL** - you'll need it later!

---

### Step 2: Create Free Redis Cache (Upstash)

1. Go to [upstash.com](https://upstash.com)
2. Click **"Get Started"** → Sign up with GitHub
3. Click **"Create Database"**
   - Name: `frappe-redis`
   - Type: **Regional**
   - Region: Choose closest to you
   - Click **"Create"**
4. Click on your new database
5. Scroll down to **"REST API"** section
6. Copy the **"UPSTASH_REDIS_REST_URL"** (looks like):
   ```
   https://us1-merry-cat-12345.upstash.io
   ```
7. **SAVE THIS URL** - you'll need it later!

---

### Step 3: Configure Render Environment Variables

1. Go to your **Render Dashboard** → Your Frappe web service
2. Click **"Environment"** tab on the left
3. Add these environment variables (click **"Add Environment Variable"**):

   | Key | Value |
   |-----|-------|
   | `DATABASE_URL` | Paste your Supabase PostgreSQL URL |
   | `REDIS_URL` | Paste your Upstash Redis URL |
   | `FRAPPE_SITE_NAME` | `frappe.onrender.com` |

4. Click **"Save Changes"**

---

### Step 4: Update Your Code

I'll create the startup script and update your Dockerfile automatically.

---

### Step 5: Deploy

1. Commit and push changes to GitHub
2. Render will auto-deploy
3. Wait 3-5 minutes
4. Visit your URL: `https://frappe-clone.onrender.com`
5. **You should see the Frappe login page!** 🎉

---

## Default Login Credentials

- **Username**: `Administrator`
- **Password**: Check deploy logs for generated password

---

## Troubleshooting

If you see errors, check Render logs:
- Go to your service → **"Logs"** tab
- Look for initialization messages
- Site creation takes 2-3 minutes on first deploy

---

## Need Help?

If anything doesn't work, send me:
1. Screenshot of Render logs
2. The error message you see
3. Which step failed
