class MonthlyFee {
  late String month;
  late String year;
  late bool isPaid;
  late String paidDate;
  late int dueMoney;
  late bool message;

  MonthlyFee(
      {required this.month,
      required this.year,
      required this.isPaid,
      required this.paidDate,
      required this.dueMoney});

  MonthlyFee.fromJson(Map<String, dynamic> json) {
    month = json['month'] ?? "nmn";
    year = json['year'] ?? "";
    isPaid = json['isPaid'] ?? false;
    message = json['message'] ?? false;
    paidDate = json['paidDate'] ?? "";
    dueMoney = json['dueMoney'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.month;
    data['year'] = this.year;
    data['isPaid'] = this.isPaid;
    data['paidDate'] = this.paidDate;
    data['dueMoney'] = this.dueMoney;
    data['message'] = this.message;
    return data;
  }
}
