import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;

  const PaymentScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ödeme'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Image.network("https://picsum.photos/200/300"),
            height: 300,
            width: 300,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sepet Özeti',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
                width: 10,
              ),
              SizedBox(
                width: 200,
                height: 200,
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                          '${cartItems[index]['name']} x ${cartItems[index]['quantity']}'),
                      subtitle: Text(
                        '\$${cartItems[index]['price'] * cartItems[index]['quantity']}',
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
                width: 10,
              ),
              Text('Toplam Tutar: \$${_calculateTotalAmount()}'),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateTotalAmount() {
    double total = 0.0;
    for (var item in cartItems) {
      total += item['price'] * item['quantity'];
    }
    return total;
  }
}
