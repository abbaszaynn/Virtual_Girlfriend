# Flutter SDK Installation Guide for Windows

## 🎯 The Problem

You have:
- ✅ Flutter plugin in Android Studio
- ❌ Flutter SDK (the actual Flutter framework)

**Result:** Terminal says "flutter is not recognized"

---

## 📥 Step 1: Download Flutter SDK

### Option A: Direct Download (Recommended)

1. **Go to Flutter's official website:**
   ```
   https://docs.flutter.dev/get-started/install/windows
   ```

2. **Download the latest stable release:**
   - Click the **"Download Flutter SDK"** button
   - You'll get a `.zip` file (around 1.5 GB)
   - Example: `flutter_windows_3.x.x-stable.zip`

### Option B: Using Git (Advanced)

```powershell
# If you have Git installed
git clone https://github.com/flutter/flutter.git -b stable C:\Flutter
```

---

## 📂 Step 2: Extract Flutter SDK

1. **Choose a location** (NOT in Program Files or temp folder):
   - Recommended: `C:\Flutter`
   - Alternative: `C:\src\flutter`
   - Or any location **without spaces** in the path

2. **Extract the ZIP file:**
   - Right-click the downloaded `flutter_windows_x.x.x-stable.zip`
   - Select **"Extract All..."**
   - Choose destination: `C:\`
   - This creates: `C:\Flutter\` folder

3. **Verify extraction:**
   - Open `C:\Flutter\` folder
   - You should see folders: `bin`, `dev`, `packages`, etc.

---

## 🔧 Step 3: Add Flutter to PATH

This is the **most important step** to fix "flutter is not recognized"!

### Method 1: Using Windows Settings (GUI)

1. **Open System Environment Variables:**
   - Press `Windows + R`
   - Type: `sysdm.cpl`
   - Press Enter

2. **Navigate to Environment Variables:**
   - Click **"Advanced"** tab
   - Click **"Environment Variables..."** button at the bottom

3. **Edit PATH variable:**
   - Under **"User variables"** (top section)
   - Find and select **"Path"**
   - Click **"Edit..."**

4. **Add Flutter to PATH:**
   - Click **"New"**
   - Type: `C:\Flutter\bin`
   - Click **"OK"**

5. **Save everything:**
   - Click **"OK"** on Environment Variables window
   - Click **"OK"** on System Properties window

6. **Restart your computer** (or at least close all terminals/Android Studio)

### Method 2: Using PowerShell (Command Line)

```powershell
# Run PowerShell as Administrator
# Right-click PowerShell → "Run as administrator"

# Add Flutter to User PATH
[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", "User") + ";C:\Flutter\bin",
    "User"
)

# Verify it was added
echo $env:Path
```

---

## ✅ Step 4: Verify Installation

### Test in Command Prompt or PowerShell:

1. **Open a NEW terminal** (important - close old ones first!)
   - Press `Windows + R`
   - Type: `cmd` or `powershell`
   - Press Enter

2. **Run Flutter commands:**

```powershell
# Check Flutter version
flutter --version

# You should see something like:
# Flutter 3.x.x • channel stable
# Framework • revision xxxxx
# Engine • revision xxxxx
# Tools • Dart 3.x.x
```

3. **Run Flutter Doctor:**

```powershell
flutter doctor
```

**Expected output:**
```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.x.x, on Microsoft Windows)
[!] Android toolchain - develop for Android devices
[!] Chrome - develop for the web
[✓] Visual Studio - develop Windows apps
[✓] Android Studio (version 2023.x)
[✓] Connected device (1 available)
[✓] Network resources
```

Don't worry if some items show [!] - we'll fix those next.

---

## 🔧 Step 5: Run Flutter Doctor & Fix Issues

```powershell
# See detailed issues
flutter doctor -v
```

### Common Issues & Fixes:

#### Issue 1: Android Toolchain - Android licenses not accepted

**Fix:**
```powershell
flutter doctor --android-licenses

# Type 'y' for each license
# Press Enter to accept all
```

#### Issue 2: Android SDK not found

**Fix:**
1. Open Android Studio
2. Go to **Tools → SDK Manager**
3. Note the **Android SDK Location** path
4. Run:
```powershell
flutter config --android-sdk "C:\Users\YourName\AppData\Local\Android\Sdk"
```

#### Issue 3: cmdline-tools component is missing

**Fix:**
1. Open Android Studio
2. **Tools → SDK Manager**
3. Go to **SDK Tools** tab
4. Check ✅ **"Android SDK Command-line Tools (latest)"**
5. Click **Apply** → **OK**

---

## 🎨 Step 6: Configure Flutter in Android Studio

1. **Open Android Studio**

2. **Set Flutter SDK Path:**
   - **File → Settings** (or `Ctrl+Alt+S`)
   - Go to **Languages & Frameworks → Flutter**
   - Set **Flutter SDK path:** `C:\Flutter`
   - Click **Apply** → **OK**

3. **Restart Android Studio**

4. **Verify in Android Studio:**
   - Open Terminal in Android Studio (bottom panel)
   - Type: `flutter --version`
   - Should show Flutter version (no error!)

---

## 🚀 Step 7: Test Your Setup

### Quick Test:

```powershell
# Navigate to your project
cd E:\AI gF\craveai

# Clean and get dependencies
flutter clean
flutter pub get

# Check for connected devices
flutter devices

# Run the app
flutter run
```

---

## 🐛 Troubleshooting

### Problem: "flutter is not recognized" (even after PATH setup)

**Solutions:**

1. **Close ALL terminals and Android Studio**
   - PATH changes require restart of applications
   - Sometimes need a full computer restart

2. **Verify PATH was added correctly:**
```powershell
# In PowerShell, run:
echo $env:Path

# Look for: C:\Flutter\bin
```

3. **Try adding to System PATH instead of User PATH:**
   - Repeat Step 3, but edit **System variables** → **Path** (bottom section)

4. **Check Flutter bin exists:**
```powershell
# Should show flutter.bat
dir C:\Flutter\bin
```

### Problem: "Waiting for another flutter command to release the startup lock"

**Fix:**
```powershell
# Delete the lock file
del C:\Flutter\bin\cache\lockfile
```

### Problem: Slow first run / downloads stuck

**Fix:**
```powershell
# Pre-download Flutter dependencies
flutter precache

# Or download specific platforms
flutter precache --android
```

---

## 📋 Quick Reference - All Commands

```powershell
# Installation verification
flutter --version
flutter doctor
flutter doctor -v

# Accept licenses
flutter doctor --android-licenses

# Project commands
cd E:\AI gF\craveai
flutter clean
flutter pub get
flutter run

# Check devices
flutter devices

# Update Flutter
flutter upgrade

# See all Flutter commands
flutter help
```

---

## ✅ Success Checklist

After following all steps, verify:

- [ ] Flutter SDK extracted to `C:\Flutter`
- [ ] `C:\Flutter\bin` added to PATH
- [ ] Terminal/PowerShell restarted
- [ ] `flutter --version` works in terminal
- [ ] `flutter doctor` shows mostly green checkmarks
- [ ] Android Studio recognizes Flutter SDK path
- [ ] Can run `flutter pub get` in your project
- [ ] Ready to run `flutter run`! 🎉

---

## 🎯 Final Test

Run these commands in order:

```powershell
# 1. Check Flutter
flutter --version

# 2. Navigate to project
cd E:\AI gF\craveai

# 3. Get dependencies
flutter pub get

# 4. Run health check
flutter doctor

# 5. Run the app (with emulator or device connected)
flutter run
```

If all commands work without errors, **you're all set!** 🚀

---

## 📞 Still Having Issues?

**Common mistake:** Not restarting terminal/Android Studio after adding to PATH

**Solution:** 
1. Close everything
2. Restart computer
3. Try again

**If still not working:**
- Double-check PATH contains exactly: `C:\Flutter\bin`
- Make sure no typos in the path
- Ensure Flutter folder actually exists at `C:\Flutter`

---

## 🔗 Useful Links

- **Flutter Installation:** https://docs.flutter.dev/get-started/install/windows
- **Flutter Doctor:** https://docs.flutter.dev/get-started/install/windows#run-flutter-doctor
- **Flutter Documentation:** https://docs.flutter.dev
- **Common Issues:** https://docs.flutter.dev/get-started/flutter-for/android-devs

---

**Good luck! You're just a few steps away from running your app! 🚀**
