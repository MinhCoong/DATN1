import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

class TimeAgoWidget extends StatelessWidget {
  final DateTime dateTime;

  const TimeAgoWidget({super.key, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting(); // Khởi tạo định dạng ngôn ngữ

    Duration timeAgo = DateTime.now().difference(dateTime);
    String timeAgoString = '';

    if (timeAgo.inDays > 0) {
      timeAgoString = '${timeAgo.inDays} ngày trước';
    } else if (timeAgo.inHours > 0) {
      timeAgoString = '${timeAgo.inHours} giờ trước';
    } else if (timeAgo.inMinutes > 0) {
      timeAgoString = '${timeAgo.inMinutes} phút trước';
    } else {
      timeAgoString = 'Vừa xong';
    }

    return Text(
      timeAgoString,
      style: const TextStyle(fontSize: 16),
    );
  }
}
