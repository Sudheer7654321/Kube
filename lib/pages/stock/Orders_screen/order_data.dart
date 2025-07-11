class Order {
  final String symbol;
  final String companyName;
  final String logoUrl;
  final double shares;
  final double price;
  final double total;
  final String orderType;
  final DateTime date;

  Order({
    required this.symbol,
    required this.companyName,
    required this.logoUrl,
    required this.shares,
    required this.price,
    required this.total,
    required this.orderType,
    required this.date,
  });
}