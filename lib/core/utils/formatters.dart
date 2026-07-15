import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(symbol: 'EGP ', decimalDigits: 2);
    return formatter.format(amount);
  }

  static String formatDate(DateTime date) {
    final formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(date);
  }

  static String formatDateTime(DateTime date) {
    final formatter = DateFormat('MMM dd, yyyy - hh:mm a');
    return formatter.format(date);
  }

  static String formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return formatDate(date);
  }

  static String formatPhoneNumber(String phone) {
    if (phone.length == 11) {
      return '${phone.substring(0, 4)} ${phone.substring(4, 7)} ${phone.substring(7)}';
    }
    return phone;
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static String formatDuration(int minutes) {
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final remainingMins = minutes % 60;
    if (remainingMins == 0) return '$hours hr';
    return '${hours}h ${remainingMins}m';
  }

  static String formatRetryAfter(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (minutes == 0) return '$remainingSeconds seconds';
    if (remainingSeconds == 0) return '$minutes minutes';
    return '$minutes minutes and $remainingSeconds seconds';
  }

  static String formatRating(double rating) {
    return rating.toStringAsFixed(1);
  }

  static String formatTaskCount(int count) {
    if (count < 1000) return count.toString();
    if (count < 1000000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '${(count / 1000000).toStringAsFixed(1)}M';
  }
}

extension DateTimeFormatting on DateTime {
  String get formatted => Formatters.formatDate(this);
  String get formattedWithTime => Formatters.formatDateTime(this);
  String get timeAgo => Formatters.formatTimeAgo(this);
}
