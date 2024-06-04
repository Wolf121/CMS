//      This Functio Shows this Date Format 2023-18-09 17:27:49


class CustomDateFormat {
  DateTime parseCustomDate(String dateStr) {
    List<String> dateTimeParts = dateStr.split(' ');

    List<String> dateParts = dateTimeParts[0].split('-');
    int year = int.parse(dateParts[0]); // year
    int day = int.parse(dateParts[1]); // day
    int month = int.parse(dateParts[2]); // month

    List<String> timeParts = dateTimeParts[1].split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    int second = int.parse(timeParts[2]);

    DateTime dateTime = DateTime(year, month, day, hour, minute, second);

    print(year);
    print(month);
    print(day);
    print(hour);
    print(minute);
    print(second);

    return dateTime;
  }
}
