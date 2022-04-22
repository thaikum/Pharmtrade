import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:pharmtrade/order_page.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({Key? key, required this.itemName, required this.data})
      : super(key: key);

  final Map<String, dynamic> data;
  final String itemName;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
      // color: Colors.blueGrey,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderPage(
                        data: data,
                      )),
            );
          },
          title: Text(itemName),
          trailing: IconButton(
            icon: Icon(
              Icons.phone,
              color: data['isCalled'] == true ? Colors.red : Colors.blue,
            ),
            onPressed: () async {
              FlutterPhoneDirectCaller.callNumber(data['phone']).then((value) {
                FirebaseFirestore.instance
                    .collection('order')
                    .doc(data['id'])
                    .update({'isCalled': true});
              });
            },
          ),
        ),
      ),
    );
  }
}
