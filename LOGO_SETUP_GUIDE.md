# 🎨 Logo Setup Guide

## Your Logo
The Aagman logo features:
- Green bus in front of a map
- Orange location pin
- Clean, friendly design
- Perfect for the civic-tech aesthetic

## Step 1: Save the Logo

1. Save the logo image you provided
2. Place it in: `assets/images/logo.png`
3. Make sure it's a PNG with transparent background (if possible)
4. Recommended size: 1024x1024px or larger

## Step 2: Install Flutter Launcher Icons Package

Run this command:
```bash
flutter pub add flutter_launcher_icons --dev
```

## Step 3: Update pubspec.yaml

I'll add the configuration for you automatically, but here's what it will look like:

```yaml
flutter_launcher_icons:
  android: true
  ios: false
  image_path: "assets/images/logo.png"
  adaptive_icon_background: "#F8F9FA"
  adaptive_icon_foreground: "assets/images/logo.png"
```

## Step 4: Generate Icons

After placing the logo, run:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

This will automatically generate all required Android icon sizes.

## Step 5: Update Splash Screen

The splash screen will show:
- Your logo centered
- App name "Aagman" below
- Clean background

## Step 6: Rebuild APK

```bash
flutter build apk --release
```

## What Will Change

### App Icon
- Home screen icon will be your logo
- App drawer icon will be your logo
- Recent apps will show your logo

### Splash Screen
- Shows when app launches
- Your logo with "Aagman" text
- Smooth transition to home screen

### About/Info Screens
- Logo can be used in settings
- Logo in about section
- Consistent branding

## File Structure

```
assets/
  images/
    logo.png          <- Your main logo (place here)
    
android/
  app/
    src/
      main/
        res/
          mipmap-hdpi/      <- Auto-generated
          mipmap-mdpi/      <- Auto-generated
          mipmap-xhdpi/     <- Auto-generated
          mipmap-xxhdpi/    <- Auto-generated
          mipmap-xxxhdpi/   <- Auto-generated
```

## Logo Specifications

### For Best Results:
- **Format**: PNG with transparency
- **Size**: 1024x1024px minimum
- **Background**: Transparent or white
- **Content**: Centered, with padding
- **Colors**: Match your app theme

### Your Logo Colors:
- Bus: Muted green (#5A8F7B - matches app theme!)
- Pin: Orange
- Map: Soft pastels
- Perfect match for the app!

## Alternative: Manual Setup

If you prefer manual setup:

1. Use an online tool like:
   - https://icon.kitchen
   - https://appicon.co
   - https://makeappicon.com

2. Upload your logo
3. Download Android icon pack
4. Replace files in `android/app/src/main/res/mipmap-*` folders

## Testing

After setup:
1. Uninstall old app from phone
2. Install new APK
3. Check home screen icon
4. Launch app and see splash screen
5. Verify icon in app drawer

## Troubleshooting

### Icon not updating?
- Uninstall app completely
- Clear cache
- Reinstall fresh APK

### Icon looks blurry?
- Use higher resolution source image
- Ensure PNG is at least 1024x1024px

### Background color wrong?
- Update `adaptive_icon_background` in pubspec.yaml
- Use your app's background color: `#F8F9FA`

## Next Steps

1. **Save logo** to `assets/images/logo.png`
2. **Run commands** from Step 4
3. **Build APK**
4. **Test on phone**

Your app will have professional branding! 🎉
