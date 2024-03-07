
class BankAccount {
  final String type;
  final String endNum;
  final String amount;

  const BankAccount(this.type, this.endNum, this.amount);
}

const List<BankAccount> bankAccounts = [
  BankAccount("Savings", "7890", "100,000,000.00"),
  BankAccount("Checking", "3210", "100,000,000.00"),
];