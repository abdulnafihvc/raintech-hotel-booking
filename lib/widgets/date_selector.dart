import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final ValueChanged<DateTime?> onCheckInChanged;
  final ValueChanged<DateTime?> onCheckOutChanged;

  const DateSelector({
    super.key,
    required this.checkInDate,
    required this.checkOutDate,
    required this.onCheckInChanged,
    required this.onCheckOutChanged,
  });

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')} ${_monthString(date.month)} ${date.year}";
  }

  String _monthString(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Safely add a day without hitting DST 23h/25h boundaries
    DateTime getNextDay(DateTime d) => DateTime(d.year, d.month, d.day + 1);

    final initialDate = isCheckIn 
      ? (checkInDate ?? today) 
      : (checkOutDate ?? (checkInDate != null ? getNextDay(checkInDate!) : getNextDay(today)));
    
    final firstDate = isCheckIn ? today : (checkInDate ?? today);
    
    final baseLastDate = DateTime(today.year + 1, today.month, today.day);
    // Allow check-out lastDate to extend slightly so check-ins on the absolute last date can still checkout
    final safeLastDate = isCheckIn ? baseLastDate : DateTime(baseLastDate.year, baseLastDate.month, baseLastDate.day + 7);

    // Prevent showDatePicker AssertionError if initialDate breaches limits
    DateTime safeInitialDate = initialDate;
    if (safeInitialDate.isBefore(firstDate)) safeInitialDate = firstDate;
    if (safeInitialDate.isAfter(safeLastDate)) safeInitialDate = safeLastDate;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: safeInitialDate,
      firstDate: firstDate,
      lastDate: safeLastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: const Color(0xFF1E3A8A),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (isCheckIn) {
        onCheckInChanged(pickedDate);
      } else {
        onCheckOutChanged(pickedDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Expanded(
              child: _buildDateItem(
                context,
                'Check-in',
                checkInDate != null ? _formatDate(checkInDate!) : 'Select Date',
                Icons.login_rounded,
                () => _selectDate(context, true),
                checkInDate != null,
              ),
            ),
            Container(
              height: 48,
              width: 1,
              color: Colors.grey.shade200,
            ),
            Expanded(
              child: _buildDateItem(
                context,
                'Check-out',
                checkOutDate != null ? _formatDate(checkOutDate!) : 'Select Date',
                Icons.logout_rounded,
                () => _selectDate(context, false),
                checkOutDate != null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateItem(
    BuildContext context, 
    String label, 
    String dateStr, 
    IconData icon, 
    VoidCallback onTap,
    bool hasDate,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon, 
                  size: 16, 
                  color: hasDate ? Theme.of(context).primaryColor : Colors.grey.shade500,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              dateStr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: hasDate ? FontWeight.w700 : FontWeight.w400,
                color: hasDate ? Colors.black87 : Colors.grey.shade400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
