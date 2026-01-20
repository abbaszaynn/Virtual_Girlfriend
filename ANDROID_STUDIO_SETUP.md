# Running CraveAI in Android Studio

## 🚀 Complete Setup Guide

### Prerequisites Checklist

Before you start, make sure you have:

- ✅ **Android Studio** installed (latest version recommended)
- ✅ **Flutter SDK** installed
- ✅ **Android SDK** installed via Android Studio
- ✅ **Java JDK** (comes with Android Studio)

---

## Step-by-Step Setup

### Step 1: Open Project in Android Studio

1. **Launch Android Studio**
2. Click **"Open"** (not "New Project")
3. Navigate to: `E:\AI gF\craveai`
4. Click **"OK"**
5. Wait for indexing to complete (bottom right corner shows progress)

---

### Step 2: Install Flutter & Dart Plugins

If Flutter plugins aren't installed:

1. **File → Settings** (or **Ctrl+Alt+S**)
2. Go to **Plugins**
3. Search for **"Flutter"**
4. Click **Install** (Dart will auto-install)
5. Click **Restart IDE**

---

### Step 3: Configure Flutter SDK

1. **File → Settings**
2. **Languages & Frameworks → Flutter**
3. Set **Flutter SDK path**:
   - Example: `C:\Flutter` or `C:\src\flutter`
4. Click **Apply** → **OK**

**Need to install Flutter?**
```powershell
# Download Flutter SDK
# Visit: https://docs.flutter.dev/get-started/install/windows

# Extract to C:\Flutter (or any location)
# Add to PATH: C:\Flutter\bin

# Verify installation
flutter doctor
```

---

### Step 4: Get Flutter Dependencies

Open **Terminal** in Android Studio (bottom panel) or use the built-in:

```bash
# Navigate to project directory (if not already there)
cd E:\AI gF\craveai

# Install all dependencies from pubspec.yaml
flutter pub get
```

**Alternative:** Click the **"Pub get"** button that appears at the top of `pubspec.yaml` when you open it.

---

### Step 5: Set Up Environment Variables (.env file)

Your project needs a `.env` file for API keys:

1. Open the `.env` file in the project root
2. Make sure it has your API keys:

```env
SUPABASE_URL=your_supabase_url_here
SUPABASE_ANON_KEY=your_supabase_anon_key_here
ELEVENLABS_API_KEY=your_elevenlabs_api_key_here
OPENROUTER_API_KEY=your_openrouter_api_key_here
```

⚠️ **Important:** Never commit `.env` to Git (it's already in `.gitignore`)

---

### Step 6: Set Up Android Emulator

#### Option A: Create a New Emulator

1. Click **Device Manager** (phone icon on the right toolbar)
2. Click **"Create Device"**
3. Select a device (recommended: **Pixel 5** or **Pixel 6**)
4. Click **Next**
5. Select a system image:
   - **Recommended:** API 33 (Android 13) or API 34 (Android 14)
   - Click **Download** if not installed
6. Click **Next** → **Finish**
7. Click the **▶ Play** button to start the emulator

#### Option B: Use an Existing Emulator

1. Click **Device Manager**
2. Find your emulator in the list
3. Click the **▶ Play** button

#### Option C: Use a Physical Device

1. Enable **Developer Options** on your phone:
   - Go to **Settings → About Phone**
   - Tap **Build Number** 7 times
2. Enable **USB Debugging**:
   - **Settings → Developer Options → USB Debugging**
3. Connect phone via USB
4. Allow USB debugging prompt on phone
5. Phone should appear in device dropdown

---

### Step 7: Run the App

#### Method 1: Using the Run Button (Easiest)

1. Make sure your emulator is running (or phone connected)
2. Select device from dropdown at the top toolbar
3. Click the **green ▶ Run button** (or press **Shift+F10**)
4. Wait for build to complete (first build takes 2-5 minutes)

#### Method 2: Using Terminal

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Run in debug mode with hot reload
flutter run

# Run in release mode (faster, but no hot reload)
flutter run --release
```

#### Method 3: Debug Mode

1. Open `lib/main.dart`
2. Click the **▶ Debug** icon next to `void main()`
3. Select your device
4. App will run in debug mode with breakpoints enabled

---

## 🔧 Troubleshooting

### Issue 1: "Flutter SDK not found"

**Solution:**
1. Download Flutter SDK from https://flutter.dev
2. Extract to `C:\Flutter`
3. Add to PATH: `C:\Flutter\bin`
4. Restart Android Studio
5. Set SDK path in Settings

### Issue 2: "Gradle build failed"

**Solution:**
```bash
# Clean the build
flutter clean

# Get dependencies again
flutter pub get

# Try running again
flutter run
```

### Issue 3: "No connected devices"

**Solutions:**
- **Emulator:** Start emulator from Device Manager
- **Physical device:** Enable USB debugging
- **Check connection:** Run `flutter devices`

### Issue 4: "Package not found" or "Import errors"

**Solution:**
```bash
# Clear cache and rebuild
flutter clean
flutter pub get
flutter pub upgrade
```

### Issue 5: "Android licenses not accepted"

**Solution:**
```bash
# Accept all Android licenses
flutter doctor --android-licenses

# Type 'y' for each license
```

### Issue 6: Build taking too long

**First build is slow** (2-5 minutes). Subsequent builds with hot reload are much faster (3-10 seconds).

**Speed up builds:**
1. Close other heavy applications
2. Enable **Offline Mode** in Gradle:
   - **File → Settings → Build → Gradle**
   - Check **"Offline work"**
3. Increase heap size:
   - **Help → Edit Custom VM Options**
   - Add: `-Xmx4096m`

---

## 🎯 Running the App Successfully

After setup, you should see:

```
✅ Flutter SDK configured
✅ Dependencies installed (flutter pub get)
✅ .env file configured
✅ Emulator/device connected
✅ Build successful
✅ App launched!
```

### Expected First Run:

1. **Build time:** 2-5 minutes (first time only)
2. **App launches** on emulator/device
3. You see the **welcome screen**
4. You can navigate through the app

---

## 🔥 Hot Reload (Development Feature)

Once app is running:

1. Make changes to your Dart code
2. Press **"r"** in terminal or click **⚡ Hot Reload** button
3. Changes appear in app **instantly** (within 1-3 seconds)
4. No need to restart app!

**Hot Restart:** Press **"R"** (capital R) to fully restart app state

---

## 📱 Testing Your Changes

After you made the image updates:

1. **Run the app:**
   ```bash
   flutter run
   ```

2. **Navigate to "Create AI Girlfriend"**

3. **Scroll to "Appearance Preference"**

4. **Verify:**
   - ✅ See 7 circular images
   - ✅ Images scroll horizontally
   - ✅ Can select any image
   - ✅ Selected image has border + check + dot indicator

---

## 📊 Flutter Doctor (Health Check)

Before running, check your setup:

```bash
flutter doctor -v
```

**Expected output:**
```
[✓] Flutter (Channel stable, 3.x.x)
[✓] Android toolchain - develop for Android devices
[✓] Android Studio (version 2023.x)
[✓] Connected device (1 available)
[✓] Network resources
```

**Fix any [✗] or [!] issues before proceeding.**

---

## 🚀 Quick Start Commands

```bash
# 1. Navigate to project
cd E:\AI gF\craveai

# 2. Check Flutter setup
flutter doctor

# 3. Get dependencies
flutter pub get

# 4. List devices
flutter devices

# 5. Run the app
flutter run

# 6. Run in release mode
flutter run --release

# 7. Clean build (if issues)
flutter clean
flutter pub get
flutter run
```

---

## 💡 Useful Android Studio Shortcuts

| Action | Shortcut |
|--------|----------|
| Run app | **Shift+F10** |
| Debug app | **Shift+F9** |
| Hot reload | **Ctrl+S** (save) or **Ctrl+\\** |
| Hot restart | **Ctrl+Shift+\\** |
| Open terminal | **Alt+F12** |
| Find files | **Ctrl+Shift+N** |
| Find in files | **Ctrl+Shift+F** |
| Format code | **Ctrl+Alt+L** |

---

## 📋 Project Structure

```
craveai/
├── android/          ← Android-specific config
├── ios/              ← iOS-specific config  
├── lib/              ← Your Dart code (main app)
│   ├── main.dart     ← Entry point (run this)
│   ├── controllers/  ← App logic
│   ├── views/        ← UI screens
│   ├── models/       ← Data models
│   └── services/     ← API services
├── images/           ← Image assets
├── pubspec.yaml      ← Dependencies config
└── .env              ← Environment variables (API keys)
```

---

## ✅ Success Checklist

Before running for the first time:

- [ ] Android Studio installed
- [ ] Flutter SDK installed and in PATH
- [ ] Flutter & Dart plugins installed in Android Studio
- [ ] Project opened in Android Studio
- [ ] `flutter pub get` completed successfully
- [ ] `.env` file configured with API keys
- [ ] Android emulator created or phone connected
- [ ] `flutter doctor` shows all green checkmarks
- [ ] Ready to click **Run** button! 🚀

---

## 🆘 Need More Help?

1. **Flutter Documentation:** https://docs.flutter.dev
2. **Android Studio Guide:** https://developer.android.com/studio
3. **Flutter Discord:** https://discord.gg/flutter

---

## 🎉 You're All Set!

Now you can:
1. Click the **green ▶ Run button** in Android Studio
2. Wait for the build to complete
3. See your app running on the emulator/device
4. Make changes and use **Hot Reload** for instant updates!

**Happy coding! 🚀**
