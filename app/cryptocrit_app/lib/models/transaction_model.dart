class Transaction {
  final int timestamp;
  final String from_address;
  final String to_address;
  final int amount;
  final String signature;

  Transaction(
      {this.timestamp,
      this.from_address,
      this.to_address,
      this.amount,
      this.signature});
}
