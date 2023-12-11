import 'package:flutter/material.dart';

import 'package:sepet/PaymentPage.dart';
import 'dart:convert' as convert;
import 'dart:html' as html;

class ShoppingScreen extends StatefulWidget {
  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  List<Map<String, dynamic>> _cartItems = [];
  double _totalAmount = 0.0;
  bool _showCartSummary = false;

  double _calculateTotalAmount() {
    double total = 0.0;
    _cartItems.forEach((item) {
      total += item['price'] * item['quantity'];
    });
    return total;
  }

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  void _loadCartItems() {
    // Tarayıcı depolama alanından verileri yükle
    String? cartItemsJson = html.window.localStorage['cartItems'];
    if (cartItemsJson != null) {
      setState(() {
        _cartItems = List<Map<String, dynamic>>.from(convert.jsonDecode(cartItemsJson));
        _totalAmount = _calculateTotalAmount();
      });
    }
  }


  void _saveCartItems() {
    // Sepet öğelerini tarayıcı depolama alanına kaydet
    html.window.localStorage['cartItems'] = convert.jsonEncode(_cartItems);
  }


  void _addToCart(String name, double price) {
    setState(() {
      if (_cartItems.any((item) => item['name'] == name)) {
        _cartItems.firstWhere((item) => item['name'] == name)['quantity'] += 1;
      } else {
        _cartItems.add({'name': name, 'price': price, 'quantity': 1});
      }
      _totalAmount = _calculateTotalAmount();
      _saveCartItems(); // Ekleme yapıldıktan sonra depolama alanına kaydet

    });
  }

  void _removeFromCart(String name) {
    setState(() {
      var item = _cartItems.firstWhere((item) => item['name'] == name);
      if (item['quantity'] > 1) {
        item['quantity'] -= 1;
      } else {
        _cartItems.removeWhere((item) => item['name'] == name);
      }
      _totalAmount = _calculateTotalAmount();
      _saveCartItems(); // Çıkarma yapıldıktan sonra depolama alanına kaydet

    });
  }

  void _toggleCartSummary() {
    setState(() {
      _showCartSummary = !_showCartSummary;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alışveriş Ekranı'),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: Image.network(products[index]['image']),
                  title: Text(products[index]['name']),
                  subtitle: Text('\$${products[index]['price']}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      _addToCart(
                        products[index]['name'],
                        products[index]['price'],
                      );
                    },
                    child: Text('Sepete Ekle'),
                  ),
                ),
              );
            },
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: 50,
            bottom: 100,
            right: _showCartSummary ? 0 : -MediaQuery.of(context).size.width * 0.3,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              color: Colors.greenAccent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      _toggleCartSummary();
                    },
                  ),
                  Text(
                    'Sepet Özeti',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _cartItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                              '${_cartItems[index]['name']} x ${_cartItems[index]['quantity']}'),
                          subtitle: Text(
                            '\$${_cartItems[index]['price'] * _cartItems[index]['quantity']}',
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              _removeFromCart(_cartItems[index]['name']);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(cartItems: _cartItems),
                        ),
                      );
                    },
                    child: Text('Sepeti Onayla'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _cartItems.isNotEmpty
          ? FloatingActionButton(
        onPressed: () {
          _toggleCartSummary();
        },
        child: Stack(
          children: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                _toggleCartSummary();
              },
            ),
            _cartItems.isNotEmpty
                ? Positioned(
              right: 5,
              top: 5,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red,
                child: Text(
                  _cartItems.length.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            )
                : SizedBox.shrink(),
          ],
        ),
      )
          : null,
    );
  }


  // Ürün listesi, ürünler burada tanımlanabilir (örneğin).
  List<Map<String, dynamic>> products = [
    {
      'name': 'Elma',
      'price': 10.0,
      'image': 'https://picsum.photos/200/300',
    },
    {
      'name': 'Armut',
      'price': 20.0,
      'image': 'https://picsum.photos/200/300',
    },
    {
      'name': 'Kiraz',
      'price': 30.0,
      'image': 'https://picsum.photos/200/300',
    },
    {
      'name': 'Şeftali',
      'price': 90.0,
      'image': 'https://picsum.photos/200/300',
    },
    {
      'name': 'Nar',
      'price': 40.0,
      'image': 'https://picsum.photos/200/300',
    },
    {
      'name': 'Mandalina',
      'price': 50.0,
      'image': 'https://picsum.photos/200/300',
    },
    // Diğer ürünler...
  ];
}
