enum CardType {
  MasterCard,
  Visa,
  Verve,
  Others, // Any other card issuer
  Invalid // We'll use this when the card is invalid
}
class PaymentCard {
  CardType type;
  String number;
  String name;
  int month;
  int year;
  int cvv;

  PaymentCard(
      {required this.type,required this.number, required this.name, required this.month,required this.year, required this.cvv});
}