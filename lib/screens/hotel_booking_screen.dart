import 'package:flutter/material.dart';
import '../data/room_data.dart';
import '../models/room.dart';
import '../utils/booking_calculator.dart';
import '../widgets/date_selector.dart';
import '../widgets/room_card.dart';
import '../widgets/booking_summary.dart';

class HotelBookingScreen extends StatefulWidget {
  const HotelBookingScreen({super.key});

  @override
  State<HotelBookingScreen> createState() => _HotelBookingScreenState();
}

class _HotelBookingScreenState extends State<HotelBookingScreen> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  Room? _selectedRoom;
  int _guestCount = 1; // New state for tracking guests
  
  bool _hasAttemptedBooking = false;

  void _handleConfirmBooking() {
    setState(() {
      _hasAttemptedBooking = true;
    });

    if (_getValidationMessage() == null) {
      // Success!
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text('Booking confirmed for ${_selectedRoom!.id}!'),
            ],
          ),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  String? _getValidationMessage() {
    // Validate dates
    final dateError = BookingCalculator.validateDates(_checkInDate, _checkOutDate);
    if (dateError != null) return dateError;
    
    // Validate room
    if (_selectedRoom == null) {
      return 'Please select a room to continue.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    int nights = 0;
    double totalAmount = 0;
    bool areDatesValid = false;
    
    final dateError = BookingCalculator.validateDates(_checkInDate, _checkOutDate);
    if (dateError == null && _checkInDate != null && _checkOutDate != null) {
      areDatesValid = true;
      nights = BookingCalculator.calculateNights(_checkInDate!, _checkOutDate!);
      if (_selectedRoom != null) {
        totalAmount = BookingCalculator.calculateTotal(nights, _selectedRoom!.pricePerNight);
      }
    }

    String? displayValidationMessage;
    if (_hasAttemptedBooking) {
      displayValidationMessage = _getValidationMessage();
    } else {
      if ((_checkInDate != null || _checkOutDate != null) && dateError != null) {
        // Prevent showing "missing" errors immediately after picking just one date
        if (!dateError.contains('Please select')) {
          displayValidationMessage = dateError;
        }
      }
    }
        
    final isValid = areDatesValid && _selectedRoom != null;
    
    // Dynamically filter rooms that can accommodate the current guest count
    final filteredRooms = rooms.where((room) => room.maxGuests >= _guestCount).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NightOwl',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              children: [
                const Text(
                  'Select Dates',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                DateSelector(
                  checkInDate: _checkInDate,
                  checkOutDate: _checkOutDate,
                  onCheckInChanged: (date) {
                    setState(() {
                      _checkInDate = date;
                      if (_checkOutDate != null && 
                          (date!.isAfter(_checkOutDate!) || date.isAtSameMomentAs(_checkOutDate!))) {
                        _checkOutDate = null;
                      }
                      _hasAttemptedBooking = false;
                    });
                  },
                  onCheckOutChanged: (date) {
                    setState(() {
                      _checkOutDate = date;
                      _hasAttemptedBooking = false;
                    });
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Enhanced Available Rooms Header with Guest Filter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Available Rooms',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.person, size: 18, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: _guestCount > 1 ? () {
                                  setState(() {
                                    _guestCount--;
                                  });
                                } : null,
                                borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  child: Icon(
                                    Icons.remove, 
                                    size: 16, 
                                    color: _guestCount > 1 ? Theme.of(context).primaryColor : Colors.grey.shade300,
                                  ),
                                ),
                              ),
                              Text(
                                '$_guestCount', 
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              InkWell(
                                onTap: _guestCount < 4 ? () {
                                  setState(() {
                                    _guestCount++;
                                    // If we increase guests and the currently selected room is now too small, unselect it
                                    if (_selectedRoom != null && _selectedRoom!.maxGuests < _guestCount) {
                                      _selectedRoom = null;
                                      _hasAttemptedBooking = false;
                                    }
                                  });
                                } : null,
                                borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  child: Icon(
                                    Icons.add, 
                                    size: 16, 
                                    color: _guestCount < 4 ? Theme.of(context).primaryColor : Colors.grey.shade300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                if (filteredRooms.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Text(
                        'No rooms available for $_guestCount guests.',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      ),
                    ),
                  )
                else
                  ...filteredRooms.map((room) => RoomCard(
                    room: room,
                    isSelected: _selectedRoom?.id == room.id,
                    onTap: () {
                      setState(() {
                        _selectedRoom = room;
                        _hasAttemptedBooking = false;
                      });
                    },
                  )),
              ],
            ),
          ),
          BookingSummary(
            nights: nights,
            selectedRoom: _selectedRoom,
            checkInDate: _checkInDate,
            checkOutDate: _checkOutDate,
            totalAmount: totalAmount,
            validationMessage: displayValidationMessage,
            isValid: isValid,
            onConfirm: _handleConfirmBooking,
          ),
        ],
      ),
    );
  }
}
