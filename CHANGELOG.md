# Changelog

All notable changes to this project will be documented in this file.

## [2.0.0] - 2024-08-06

### Added
- AES-256 encryption for all password data
- Secure storage for encryption keys using platform-specific secure storage
- SHA-256 hashing for master password
- Migration system for existing passwords to encrypted format
- Database version upgrade to support encryption
- Loading indicators during encryption/decryption operations
- Enhanced error handling for authentication
- New security information in registration screen

### Changed
- Master password storage moved from SharedPreferences to secure storage
- Database structure updated to track encryption status
- Login verification now uses secure hash comparison
- Improved password validation

### Fixed
- Security vulnerability with plaintext password storage
- Master password protection
- Potential data exposure issues

## [1.1.1] - 2024-06-03

### Bug Fixes
- Minor bug fix

## [1.1.0] - 2024-05-09

### Added
- Responsive Application & Updated Color Scheme
- Sliding Clipped Nav Bar Added

### Fixed
- Minor bug fix
- Unsupported operating system removed

## [1.0.4] - 2024-03-02

### Fixed
- Auth Provider Added
- OnBoarding Provider Added

## [1.0.3] - 2024-02-28

### Fixed
- Material 3 Theme Applied

## [1.0.2] - 2024-02-24

### Fixed
- Updated to latest Dart SDK and Dependencies


