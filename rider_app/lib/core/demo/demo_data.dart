library;

abstract final class Demo {
  const Demo._();

  static const String riderName = 'Arjun Mehta';
  static const String riderShortName = 'Arjun';
  static const String riderCode = 'EVS-DEL-01142';
  static const String riderMobile = '9876543210';
  static const String hub = 'Okhla Phase II';
  static const String teamLead = 'Rohit Sharma';
  static const String teamLeadMobile = '9811023344';

  static const String vehicleNumber = 'DL 1S AB 4429';
  static const String vehicleModel = 'Ather 450X';
  static const String vehicleVin = 'MD9AT450XR1204471';
  static const String vehicleColour = 'Space Grey';

  static const Map<String, Object?> profile = {
    'name': riderName,
    'shortName': riderShortName,
    'riderCode': riderCode,
    'mobile': riderMobile,
    'hub': hub,
    'teamLead': teamLead,
    'teamLeadMobile': teamLeadMobile,
    'vehicleNumber': vehicleNumber,
    'vehicleModel': vehicleModel,
  };

  static const num walletBalance = 4860;
  static const num todayEarnings = 1240;
  static const num incentiveEarned = 320;
  static const num incentiveTarget = 500;
  static const num weeklyRent = 1750;

  static const int tripsToday = 14;
  static const double distanceTodayKm = 62.4;
  static const int onlineMinutes = 318;

  static DateTime get now => DateTime.now();

  static DateTime today() {
    final DateTime n = now;
    return DateTime(n.year, n.month, n.day);
  }

  static DateTime daysAgo(int days) =>
      today().subtract(Duration(days: days));

  static DateTime hoursAgo(int hours) => now.subtract(Duration(hours: hours));

  static DateTime nextWeekday(int weekday) {
    final DateTime t = today();
    final int delta = (weekday - t.weekday + 7) % 7;
    return t.add(Duration(days: delta == 0 ? 7 : delta));
  }

  static const List<String> weekLabels = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  static const List<num> weekEarnings = [
    980,
    1120,
    860,
    1340,
    1210,
    1490,
    todayEarnings,
  ];

  static const List<int> weekTrips = [11, 13, 9, 15, 14, 17, tripsToday];
}
