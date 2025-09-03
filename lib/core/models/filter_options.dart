enum TimePeriod { currentYear, total }

class FilterOptions {
  final String department;
  final TimePeriod timePeriod;

  FilterOptions({required this.department, required this.timePeriod});
}
