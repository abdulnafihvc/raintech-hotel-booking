# Hotel Room Booking

## Overview
This is a single-page Flutter implementation of a modern hotel room booking interface, created as a developer coding assessment for Raintech Software Limited. It focuses on a clean UI/UX and robust date calculation logic without relying on external dependencies.

## Features
- Hotel room listing
- Check-in date selection
- Check-out date selection
- Room selection
- Date validation
- Number of nights calculation
- Total price calculation
- Error handling
- Booking summary
- Unit tests

## Tech Stack
- Flutter
- Dart
- Material 3

*Note: Room data is entirely hardcoded. The application does not use any backend, database, or API integrations, as per the assessment requirements.*

## Project Structure
The project follows a simple and clean modular structure:

- `lib/main.dart` - Entry point and theme configuration.
- `lib/models/` - Data models (e.g., `room.dart`).
- `lib/data/` - Hardcoded application data (`room_data.dart`).
- `lib/screens/` - The main single-page UI (`hotel_booking_screen.dart`).
- `lib/widgets/` - Reusable UI components (`date_selector.dart`, `room_card.dart`, `booking_summary.dart`).
- `lib/utils/` - Pure Dart business and calculation logic (`booking_calculator.dart`).
- `test/` - Unit tests for calculation and validation logic (`booking_calculator_test.dart`).

## How to Run

Ensure you have Flutter installed, then run the following commands in the project root:

```bash
flutter pub get
flutter run
```

## Run Tests

To execute the unit tests covering the core date calculation and validation logic, run:

```bash
flutter test
```

## Validation Rules
The application strictly enforces the following business logic:
- Check-in cannot be in the past.
- Check-out must be after check-in.
- A room must be explicitly selected before confirming.
- Same-day check-in and check-out is invalid.
- Total price = number of nights × price per night.

## Assessment Notes
The architecture of this application is intentionally kept simple and straightforward. Heavy state-management libraries (like BLoC or Riverpod) were deliberately avoided in favor of standard `StatefulWidget`/`setState`, aligning with the scope of a short 2–3 hour coding exercise.

## Future Improvements
Potential future enhancements for a production environment could include:
- Room availability filtering based on existing backend bookings
- Guest count filtering and dynamic UI adjustments
- More comprehensive widget and integration tests
- Backend/API integration for live pricing
- Booking persistence and user authentication
