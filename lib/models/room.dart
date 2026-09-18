class Room {
  final String id;
  final String roomType;
  final double pricePerNight;
  final int maxGuests;

  const Room({
    required this.id,
    required this.roomType,
    required this.pricePerNight,
    required this.maxGuests,
  });
}
