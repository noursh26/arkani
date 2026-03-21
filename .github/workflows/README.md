# Flutter CI/CD Workflow

This GitHub Actions workflow automates testing, building, and releasing the Arkani Flutter application.

## Features

- **Automated Testing**: Runs on every push and pull request
- **Code Analysis**: Linting with `flutter analyze`
- **Test Coverage**: Generates and uploads coverage reports
- **APK Building**: Builds release APK automatically
- **App Bundle**: Builds AAB for Play Store (when signed)
- **Auto Release**: Creates GitHub releases with APK when tags are pushed

## Triggers

- Push to `main` or `master` branches
- Pull requests to `main` or `master`
- Tags starting with `v` (e.g., `v1.0.0`)

## Required Secrets (for Signed Builds)

To create signed APKs and App Bundles, add these secrets to your GitHub repository:

| Secret | Description |
|--------|-------------|
| `KEYSTORE_BASE64` | Base64 encoded keystore file |
| `KEYSTORE_PASSWORD` | Keystore password |
| `KEY_ALIAS` | Key alias name |
| `KEY_PASSWORD` | Key password |

### Generate Keystore and Secrets

```bash
# Generate keystore
keytool -genkey -v -keystore arkani-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias arkani

# Encode keystore to base64
base64 -i arkani-keystore.jks | pbcopy  # On macOS
base64 -i arkani-keystore.jks -w 0     # On Linux
# On Windows PowerShell:
[Convert]::ToBase64String([IO.File]::ReadAllBytes("arkani-keystore.jks")) | Set-Clipboard
```

Then paste the base64 string into GitHub Secrets as `KEYSTORE_BASE64`.

## How to Create a Release

```bash
# Create and push a new tag
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

The workflow will automatically:
1. Run all tests
2. Build the APK (and AAB if signed)
3. Create a GitHub release with the artifacts

## Workflow Jobs

| Job | Description |
|-----|-------------|
| `test` | Runs tests and code analysis |
| `build-android` | Builds APK and AAB |
| `release` | Creates GitHub release (only on tags) |
