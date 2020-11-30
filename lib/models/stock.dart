class Stock {
  Stock(this.id, this.symbol, this.name, this.price);
  int id;
  String symbol;
  String name;
  double price;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'price': price,
    };
  }
}
