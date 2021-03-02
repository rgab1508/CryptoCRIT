class Transaction {
  final timestamp;
  final fromAddress;
  final toAddress;
  final amount;
  final signature;
  final toRollNo;
  final fromRollNo;

  Transaction(
      {this.timestamp,
      this.fromAddress,
      this.toAddress,
      this.amount,
      this.signature,
      this.toRollNo,
      this.fromRollNo});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
        amount: json['amount'],
        fromAddress: json['from_address'],
        toAddress: json['to_address'],
        signature: json['signature'],
        toRollNo: json['to_roll_no'],
        fromRollNo: json['from_roll_no'],
        timestamp: json['timestamp']);
  }
}
