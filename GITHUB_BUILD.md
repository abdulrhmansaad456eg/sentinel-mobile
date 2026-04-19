# GitHub Actions Build Guide

Build your APK in the cloud - no local Flutter or Android Studio needed!

## Setup (One-Time)

### 1. Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `sentinel-mobile` (or any name)
3. Make it **Public** (free GitHub Actions) or **Private** (limited free minutes)
4. Click **Create repository**

### 2. Push Your Code

Open terminal in your project folder and run:

```bash
cd c:\Users\party\sentinel_mobile

git init
git add .
git commit -m "Initial commit"

git branch -M main

git remote add origin https://github.com/YOUR_USERNAME/sentinel-mobile.git

git push -u origin main
```

Replace `YOUR_USERNAME` with your actual GitHub username.

### 3. That's It!

GitHub Actions will automatically:
- Build your APK on every push
- Upload the APK as a downloadable artifact
- Store it for 90 days

## Getting Your APK

### Method 1: Download from GitHub (Recommended)

1. Go to your GitHub repo
2. Click **Actions** tab
3. Click the latest workflow run
4. Scroll down to **Artifacts** section
5. Click `release-apk` to download

### Method 2: Manual Trigger

1. Go to your GitHub repo
2. Click **Actions** tab
3. Click **Build APK** workflow
4. Click **Run workflow** → **Run workflow**
5. Wait ~5 minutes
6. Download the APK from artifacts

### Method 3: Create a Release (With Tag)

```bash
git tag v1.0.0
git push origin v1.0.0
```

GitHub will automatically create a release with the APK attached!

## Build Status

[![Build APK](https://github.com/YOUR_USERNAME/sentinel-mobile/actions/workflows/build_apk.yml/badge.svg)](https://github.com/YOUR_USERNAME/sentinel-mobile/actions/workflows/build_apk.yml)

(After first build, add this badge to your README)

## Troubleshooting

**Build fails?**
- Check the **Actions** tab for error logs
- Common fix: Update Flutter version in `.github/workflows/build_apk.yml`

**APK not found?**
- Make sure the workflow completed successfully (green checkmark)
- Artifacts are available in the workflow summary page

**Want faster builds?**
- The workflow uses Ubuntu (fastest)
- Build takes ~5-8 minutes
- No action needed from you - fully automatic

## Free Limits

- **Public repos**: Unlimited free builds
- **Private repos**: 2000 minutes/month (about 250 builds)

## Security

Your code and APK are safe:
- GitHub Actions runs in isolated containers
- APK is only accessible to you
- No external services involved

---

**You only need:**
- GitHub account (free)
- Git (you probably have it)
- ~5 minutes to upload code

**You DON'T need:**
- Flutter SDK
- Android Studio
- Java/JDK
- Any local disk space for SDKs
