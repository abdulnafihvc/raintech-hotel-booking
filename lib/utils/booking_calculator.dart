class BookingCalculator {
  /// Normalizes a date to UTC at midnight (00:00:00).
  /// This eliminates all timezone and Daylight Saving Time (DST) edge cases.
  static DateTime _normalizeToUtc(DateTime date) {
    return DateTime.utc(date.year, date.month, date.day);
  }

  static int calculateNights(DateTime checkIn, DateTime checkOut) {
    final inDate = _normalizeToUtc(checkIn);
    final outDate = _normalizeToUtc(checkOut);
    // Because both dates are UTC midnight, the difference is strictly multiples of 24h.
    return outDate.difference(inDate).inDays;
  }

  static double calculateTotal(int nights, double pricePerNight) {
    if (nights <= 0) return 0;
    return nights * pricePerNight;
  }

  static String? validateDates(DateTime? checkIn, DateTime? checkOut) {
    if (checkIn == null) {
      return 'Please select a check-in date.';
    }
    if (checkOut == null) {
      return 'Please select a check-out date.';
    }

    final todayDate = _normalizeToUtc(DateTime.now());
    final checkInDate = _normalizeToUtc(checkIn);
    final checkOutDate = _normalizeToUtc(checkOut);

    if (checkInDate.isBefore(todayDate)) {
      return 'Check-in date cannot be in the past.';
    }

    if (checkOutDate.isBefore(checkInDate)) {
      return 'Check-out date must be after check-in date.';
    }

    if (checkInDate.isAtSameMomentAs(checkOutDate)) {
      return 'Same-day check-in and check-out is not allowed.';
    }

    return null; // Valid
  }
}
