import 'package:flutter_test/flutter_test.dart';
import 'package:nightowl/utils/booking_calculator.dart';

void main() {
  group('BookingCalculator', () {
    // Dynamic dates for validation to prevent tests from expiring
    final today = DateTime.now();
    final tomorrow = DateTime(today.year, today.month, today.day + 1);
    final yesterday = DateTime(today.year, today.month, today.day - 1);
    
    // Explicit static dates for purely mathematical calculation tests
    final sep20 = DateTime(2023, 9, 20);
    final sep21 = DateTime(2023, 9, 21);
    final sep23 = DateTime(2023, 9, 23);

    group('Calculation Logic', () {
      test('20 Sep -> 23 Sep calculates as 3 nights', () {
        final nights = BookingCalculator.calculateNights(sep20, sep23);
        expect(nights, 3);
      });

      test('20 Sep -> 21 Sep calculates as 1 night', () {
        final nights = BookingCalculator.calculateNights(sep20, sep21);
        expect(nights, 1);
      });

      test('3 nights * ₹3,500 calculates to ₹10,500', () {
        final total = BookingCalculator.calculateTotal(3, 3500);
        expect(total, 10500.0);
      });

      test('2 nights * ₹5,800 calculates to ₹11,600', () {
        final total = BookingCalculator.calculateTotal(2, 5800);
        expect(total, 11600.0);
      });
    });

    group('Validation Logic', () {
      test('Same-day check-in and check-out is rejected', () {
        // Both dates set to tomorrow to avoid past-date error overriding this one
        final error = BookingCalculator.validateDates(tomorrow, tomorrow);
        expect(error, 'Same-day check-in and check-out is not allowed.');
      });

      test('Check-out before check-in is rejected', () {
        final checkIn = DateTime(today.year, today.month, today.day + 5);
        final checkOut = DateTime(today.year, today.month, today.day + 3);
        final error = BookingCalculator.validateDates(checkIn, checkOut);
        expect(error, 'Check-out date must be after check-in date.');
      });

      test('Check-in in the past is rejected', () {
        final error = BookingCalculator.validateDates(yesterday, tomorrow);
        expect(error, 'Check-in date cannot be in the past.');
      });
    });
  });
}
