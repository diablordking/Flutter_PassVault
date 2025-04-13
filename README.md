# PlaPass: Secure Password Vault

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20Android-brightgreen.svg)
![Encryption](https://img.shields.io/badge/encryption-AES--256-red.svg)

## Overview

**PlaPass** is a secure, offline password manager built with Flutter. It uses industry-standard encryption to ensure your passwords remain private and protected. With zero-knowledge architecture, even we can't access your data - only you hold the key.

## Key Security Features

- **AES-256 Encryption**: All sensitive data is encrypted using AES, the same encryption standard used by governments and security professionals worldwide
- **Zero-Knowledge Architecture**: Your master password is securely hashed, and all encryption/decryption happens locally on your device
- **Offline First**: No data ever leaves your device - no servers, no cloud storage, no risk of data breaches
- **Secure Storage**: Encryption keys are stored in your device's secure storage (Keychain on iOS, KeyStore on Android)
- **Automatic Screen Lock**: Protection against unauthorized physical access
- **Password Generator**: Create strong, unique passwords with customizable parameters

## Features

- **Password Management**: Securely store, organize, and access your passwords
- **Auto-Fill**: Coming soon - seamless integration with your device's autofill service
- **Search**: Quickly find the password you need when you need it
- **Password Generator**: Create strong passwords with customizable parameters
- **Password Strength Analysis**: Evaluate the security of your existing passwords
- **Custom Categories**: Organize passwords your way
- **Dark Mode Support**: Easy on the eyes for nighttime use

## Technical Details

- **Encryption**: AES-256 with secure key generation and management
- **Key Storage**: Device secure storage (Keychain/KeyStore)
- **Password Hashing**: SHA-256 for master password security
- **Database**: Local SQLite with encryption
- **Platform**: Built with Flutter for cross-platform compatibility

## Privacy Policy

We respect your privacy:
- **No Data Collection**: We don't collect any personal data
- **No Analytics**: No usage tracking or analytics
- **No Network Requests**: The app functions entirely offline
- **No Permissions**: Only requires the minimum permissions needed to function

## Installation

### From GitHub Releases
1. Visit the [Releases](https://github.com/yourusername/plapass/releases) page
2. Download the latest APK for Android or IPA for iOS
3. Install on your device

### From Source
1. Clone this repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter build apk` for Android or `flutter build ios` for iOS

## Security Best Practices

- **Use a Strong Master Password**: This is your main defense - make it long, complex, and unique
- **Regular Backups**: While we keep your data secure, device loss is still possible
- **Keep Your Device Updated**: Security updates for your OS help protect your data
- **Screen Lock**: Enable device-level security (fingerprint, PIN, pattern)

## Contributing

Contributions to improve PlaPass are welcome:
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Credits

- Flutter and Dart teams for the amazing framework
- The open-source community for the encryption libraries
- All contributors who help make this app better

---

*PlaPass: Your passwords, secured.*
