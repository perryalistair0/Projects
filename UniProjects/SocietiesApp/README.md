# NUSU Society App

*Societies App, built using the Flutter Development Kit, part of Team 43's Project.*

## Installation
- Install Flutter SDK
- Open `/societies-app` directory
- Run `flutter pub get` to fetch dependencies
  
### Android Device Installation *(Method 1)*
- Open `/societies-app` directory
- Run `flutter build apk`
- Copy `app.apk` file from `/societies-app/build/app/outputs/flutter-apk/app.apk` to Android Device
- Open file on Android Device and follow installation instructions

### Android Device Installation *(Method 2)*
- Open `/societies-app` directory
- Run `flutter build apk`
- Connect an Android Device with a USB cable
- Run `flutter install`
  
### Android Emulator Installation
- Open `/societies-app` directory in Android Studio
- Create an Android Virtual Device in AVD Manager
- Start the Virtual Device in AVD Manager
- Start the emulation by pressing the play button or running `flutter run`

### iOS Device Installation
- Open `/societies-app/ios/Runner.xcodeproj` in XCode
- Sign the Runner with an Apple Developer Account
- Connect an iOS Device via USB Cable
- In XCode, press `Product -> Destination -> 'Your Device Name'`
- In XCode, press `Product -> Scheme -> Edit Scheme -> Build Configuration -> Release`
- In XCode, press the play button to build and deploy application to iDevice