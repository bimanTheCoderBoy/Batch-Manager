import 'package:batch_manager/util/monthlyFee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentItem {
  late String name;
  late int number;
  late String batch;
  late List<MonthlyFee> account = [];
  late int balance;
  late var id;

  StudentItem.empty();
  StudentItem(
      {required this.name,
      required this.number,
      required this.batch,
      required this.account,
      required this.balance,
      required this.id});

  StudentItem.fromJson(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    name = json.data()['name'];
    number = json.data()['number'];
    batch = json.data()['batch'];
    if (json.data()['account'] != null) {
      List<MonthlyFee> account1 = [];
      json.data()['account'].forEach((v) {
        account1.add(MonthlyFee.fromJson(v));
      });
      account = account1;
    }
    balance = json.data()['balance'];
    id = json.id;
  }
  StudentItem.fromJsond(DocumentSnapshot<Map<String, dynamic>> json) {
    name = json.data()?['name'];
    number = json.data()?['number'];
    batch = json.data()?['batch'];
    if (json.data()?['account'] != null) {
      List<MonthlyFee> account = [];
      json.data()!['account'].forEach((v) {
        account.add(MonthlyFee.fromJson(v));
      });
    }
    balance = json.data()?['balance'];
    id = json.id;
  }
}
