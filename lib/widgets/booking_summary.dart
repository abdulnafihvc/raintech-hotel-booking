import 'package:flutter/material.dart';
import '../models/room.dart';

class BookingSummary extends StatelessWidget {
  final int nights;
  final Room? selectedRoom;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final double totalAmount;
  final String? validationMessage;
  final VoidCallback onConfirm;
  final bool isValid;

  const BookingSummary({
    super.key,
    required this.nights,
    required this.selectedRoom,
    required this.checkInDate,
    required this.checkOutDate,
    required this.totalAmount,
    this.validationMessage,
    required this.onConfirm,
    required this.isValid,
  });

  String _formatPrice(double price) {
    String priceStr = price.toStringAsFixed(0);
    if (priceStr.length > 3) {
      priceStr = '${priceStr.substring(0, priceStr.length - 3)},${priceStr.substring(priceStr.length - 3)}';
    }
    return '₹$priceStr';
  }

  String _formatDateShort(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return "${date.day} ${months[date.month - 1]}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (validationMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        validationMessage!,
                        style: TextStyle(
                          color: Colors.red.shade800, 
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            
            if (isValid && selectedRoom != null && checkInDate != null && checkOutDate != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${selectedRoom!.roomType} (${selectedRoom!.id})',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${_formatDateShort(checkInDate!)} - ${_formatDateShort(checkOutDate!)}',
                    style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${selectedRoom!.pricePerNight.toStringAsFixed(0)} x $nights night${nights > 1 ? 's' : ''}', 
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  ),
                  Text(
                    _formatPrice(totalAmount), 
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: Colors.grey.shade200, thickness: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Price', 
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  Text(
                    _formatPrice(totalAmount),
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
            
            ElevatedButton(
              onPressed: isValid ? onConfirm : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                disabledBackgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.grey.shade400,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Confirm Booking',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
