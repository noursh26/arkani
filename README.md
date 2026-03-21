# أركاني (Arkani) - Islamic App

تطبيق إسلامي شامل للأذكار والأحكام ومواقيت الصلاة والمساجد

## Features

- **مواقيت الصلاة**: أوقات الصلاة الدقيقة مع حسابات متعددة
- **الأذكار**: مجموعة متنوعة من الأذكار مع عداد تسبيح
- **الأحكام الشرعية**: قاعدة بيانات الأحكام مع البحث والتصفية
- **المساجد القريبة**: البحث عن المساجد باستخدام خرائط Google
- **التنبيهات**: تنبيهات يومية ورسائل تحفيزية عبر OneSignal

## Architecture

- **Clean Architecture**: features/ folder مع data/domain/presentation layers
- **State Management**: Riverpod (flutter_riverpod)
- **Navigation**: GoRouter مع bottom navigation bar (4 tabs)
- **Local Storage**: Hive للتخزين المؤقت وتفضيلات المستخدم
- **HTTP Client**: Dio مع interceptors للتعامل مع الأخطاء

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   ├── database/
│   ├── di/
│   ├── errors/
│   ├── network/
│   ├── services/
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── home/
│   ├── adhkar/
│   ├── rulings/
│   └── mosques/
├── config/
├── l10n/
└── main.dart
```

## Getting Started

### Prerequisites

- Flutter SDK >= 3.10.0
- Dart SDK >= 3.0.0
- Android Studio / Xcode

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/arkani.git
cd arkani

# Install dependencies
flutter pub get

# Run code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Run app in development mode
flutter run --flavor development

# Run app in production mode
flutter run --flavor production
```

## Environment Configuration

Create `.env.development` and `.env.production` files:

```
# Development Environment
ENV=development
APP_NAME=أركاني (تطوير)
API_BASE_URL=http://10.0.2.2:8000/api
ONESIGNAL_APP_ID=your_onesignal_dev_app_id

# Production Environment
ENV=production
APP_NAME=أركاني
API_BASE_URL=https://arkani.app/api
ONESIGNAL_APP_ID=your_onesignal_prod_app_id
```

## Build

```bash
# Build APK - Development
flutter build apk --flavor development

# Build APK - Production
flutter build apk --flavor production

# Build App Bundle - Production
flutter build appbundle --flavor production
```

## API Endpoints

The app uses the following Laravel backend API endpoints:

- `POST /api/v1/devices/register` - Device registration
- `GET /api/v1/prayers/times` - Prayer times
- `GET /api/v1/adhkar/categories` - Adhkar categories
- `GET /api/v1/adhkar/{slug}` - Adhkar by category
- `GET /api/v1/messages/random` - Motivational message
- `GET /api/v1/rulings/topics` - Ruling topics
- `GET /api/v1/rulings` - Islamic rulings
- `GET /api/v1/notifications/today` - Daily notification
- `GET /api/v1/mosques/nearby` - Nearby mosques

## Theme

- **Primary Color**: Islamic Green (#0F6E56)
- **Font**: Cairo / Tajawal (Arabic)
- **Layout**: RTL (Right-to-Left)
- **Language**: Arabic only

## License

This project is licensed under the MIT License.

## Contact

For support or inquiries, please contact: support@arkani.app
