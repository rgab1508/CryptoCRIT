class Transaction {
  final int timestamp;
  final String fromAddress;
  final String toAddress;
  final int amount;
  final String signature;

  Transaction(
      {this.timestamp,
      this.fromAddress,
      this.toAddress,
      this.amount,
      this.signature});
}
