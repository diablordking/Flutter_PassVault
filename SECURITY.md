# Security Policy

## Reporting a Vulnerability

We take the security of PlaPass very seriously. We appreciate your efforts to responsibly disclose your findings, and will make every effort to acknowledge your contributions.

### How to Report a Security Vulnerability

If you believe you've found a security vulnerability in PlaPass, please send an email to **security@plapass.example.com** (replace with actual contact).

Please include the following details in your report:

- Description of the vulnerability
- Steps to reproduce the issue
- Potential impact of the vulnerability
- Any suggestions for remediation
- Your contact information for follow-up (optional)

### Response Process

After you've reported a vulnerability:

1. We will acknowledge your report within 48 hours
2. We will provide an initial assessment of the report within 1 week
3. We aim to release patches for verified vulnerabilities within 30 days, depending on complexity
4. We will keep you informed about our progress addressing the issue

### Encryption Specifications

PlaPass uses the following security measures to protect your data:

- **AES-256** for encrypting password data
- **SHA-256** for hashing master password
- **Flutter Secure Storage** for secure key storage, leveraging:
  - Keychain on iOS
  - Keystore on Android
- **SQLite** with encryption for local database
- **Zero-knowledge architecture** - encryption/decryption happens entirely on-device

### Security Best Practices for Development

PlaPass developers adhere to the following security practices:

1. No hardcoded secrets or credentials in source code
2. Regular security code reviews
3. Dependencies kept up-to-date
4. Security testing integrated into development workflow
5. Principle of least privilege in all code implementations

### Scope

The following is considered in scope for security reports:

- The PlaPass mobile application (iOS and Android)
- Any dependencies directly utilized by the PlaPass application
- Build and release infrastructure

### Safe Harbor

We support responsible disclosure practices and will not take legal action against or suspend/terminate your account when reporting security issues, provided you:

- Make a good faith effort to avoid privacy violations, destruction of data, and interruption or degradation of our service
- Do not access or modify data that does not belong to you
- Give us reasonable time to respond to your report before making any information public
- Do not exploit the security vulnerability for your own gain

Thank you for helping keep PlaPass and our users safe!

---

*This security policy is effective as of August 6, 2024 and may be updated as needed.* 