class Discount {
  final int id;
  final int standId;
  final String name;
  final int percentage;
  final DateTime startDate;
  final DateTime endDate;

  Discount({
    required this.id,
    required this.standId,
    required this.name,
    required this.percentage,
    required this.startDate,
    required this.endDate,
  });
}
