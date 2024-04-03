import 'package:intl/intl.dart';

class DateTimeService {

  final numberFormat = DateFormat('MM-dd-yyyy');

  final wordFormat = DateFormat('MM-dd-yyyy hh:mm a');
  
  DateTime convertStringToNumberFormat( String date) {
    return numberFormat.parse(date);
  }

  String convertNumberFormatToString(DateTime date){
    return numberFormat.format(date);
  }

  DateTime convertStringToWordFormat(String date) {
    return wordFormat.parse(date);
  }

  String convertWordFormatToString(DateTime date){
    return wordFormat.format(date);
  }

  String convertFullNumberDateToWordDate(String date){
    DateTime parsedDate = wordFormat.parse(date);
    return DateFormat('MMMM dd, yyyy HH:mm a').format(parsedDate);
  }

  String addDaysFromDate(String date, int days){
    DateTime dateTime = convertStringToNumberFormat(date);
    return convertNumberFormatToString(dateTime.add(Duration(days: days)));
  }

  DateTime addDayFromToday(int days){
    DateTime dateTime = DateTime.now();
    return dateTime.add(Duration(days: days));
  }

  DateTime subtractDaysFromDate(String date, int days){
    DateTime dateTime = convertStringToNumberFormat(date);
    return dateTime.subtract(Duration(days: days));
  }

  int getDaysUntilDate(String dateString) {
    final formattedDate = numberFormat.parse(dateString);
    final now = DateTime.now();
    final difference = formattedDate.difference(now);
    return difference.inDays;
  }
}