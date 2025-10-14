# FarmApx

A comprehensive farm management web application built with Flutter.

## Features

- **Dashboard**: Overview of your farm with key metrics
- **Crops Management**: Track and manage your crops across different fields
- **Livestock Management**: Monitor your livestock inventory
- **Inventory Management**: Keep track of seeds, fertilizers, tools, and feed

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (included with Flutter)
- A web browser for testing

### Installation

1. Clone the repository:
```bash
git clone https://github.com/kevorhyno90/-farmapx.git
cd -farmapx
```

2. Install dependencies:
```bash
flutter pub get
```

### Running the App

To run the app in debug mode on the web:

```bash
flutter run -d chrome
```

Or to run in any available browser:

```bash
flutter run -d web-server
```

### Building for Production

To build the web app for production:

```bash
flutter build web
```

The built files will be in the `build/web` directory.

### Testing

Run the test suite:

```bash
flutter test
```

## Project Structure

```
farmapx/
├── lib/
│   └── main.dart          # Main application code
├── web/
│   ├── index.html         # Web entry point
│   ├── manifest.json      # PWA manifest
│   └── icons/             # App icons
├── test/
│   └── widget_test.dart   # Widget tests
├── pubspec.yaml           # Project dependencies
└── README.md              # This file
```

## Development

This is a Flutter web application designed to help farmers manage their operations efficiently. The app provides a clean, intuitive interface for tracking crops, livestock, and inventory.

### Future Enhancements

- Data persistence with local storage or backend integration
- Detailed crop and livestock tracking
- Weather integration
- Task scheduling and reminders
- Reports and analytics
- Multi-language support

## License

This project is open source and available for use and modification.
