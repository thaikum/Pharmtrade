import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key, required this.data}) : super(key: key);
  final Map<String, dynamic> data;

  static const costs = {
    "P-Element-1": 100,
    "P-Element-2": 200,
    "K-Element-3": 300,
    "proton": 600,
  };

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String? currentValue;
  CollectionReference order = FirebaseFirestore.instance.collection('order');

  var itemList = <String>[
    "P-Element-1",
    "P-Element-2",
    "K-Element-3",
    "proton",
  ];

  var items = [];

  get data => widget.data['items'];
  get snap => widget.data;

  bool isCalled = false;

  num totalCost = 0;

  get userId => FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    isCalled = snap['isCalled'];

    data.forEach((key, value) {
      final row = {
        "name": key,
        "quantity": value,
      };
      items.add(row);
      totalCost += value * OrderPage.costs[key];
    });
  }

  insertIntoItems() {
    itemList.remove(currentValue);
    setState(() {
      items.add({
        "name": currentValue!,
        "quantity": 0,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${snap['id']}"),
        ),
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for (var item in items)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                item['name'].toString(),
                              ),
                            ),
                            SizedBox(
                              width: 80.0,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: const InputDecoration(
                                  labelText: "Quantity",
                                ),
                                initialValue: item["quantity"].toString(),
                                onChanged: (value) {
                                  if (value != "") {
                                    item['quantity'] = int.parse(value);
                                    totalCost = 0;
                                    for (var element in items) {
                                      var k = element["quantity"] *
                                          OrderPage.costs[element["name"]];
                                      totalCost = totalCost + k;
                                    }

                                    Map<String, dynamic> toUpload = {};
                                    for (var item in items) {
                                      toUpload.addAll(
                                          {item['name']: item['quantity']});
                                    }

                                    Map<String, dynamic> it = {
                                      "items": toUpload,
                                    };

                                    order.doc(snap['id']).update(it).onError(
                                        (error, stackTrace) => print(error));
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    items.remove(item);
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      const Divider(),
                      Text(
                        "Total Cost: ${totalCost.toString()}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //The add item button
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 13),
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      StatefulBuilder(
                                        builder: (BuildContext context,
                                                StateSetter setState) =>
                                            AlertDialog(
                                          content: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                DropdownButton2(
                                                  hint: const Text(
                                                    "Select Item",
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                  onChanged: (String? val) {
                                                    setState(() {
                                                      currentValue = val!;
                                                    });
                                                  },
                                                  value: currentValue,
                                                  items: itemList.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                  buttonWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.8,
                                                ),
                                                Column(
                                                  children: [
                                                    const Divider(),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            currentValue = null;
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            if (currentValue !=
                                                                null) {
                                                              insertIntoItems();
                                                              currentValue =
                                                                  null;
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            }
                                                          },
                                                          child: const Text(
                                                            "Ok",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .blueAccent,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ));
                            },
                            child: const Text('Add item'),
                          ),
                          ElevatedButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 13),
                            ),
                            onPressed: () {
                              if (totalCost > 0) {
                                var doc = FirebaseFirestore.instance
                                    .collection('report')
                                    .doc(userId);

                                doc.get().then((snapshot) {
                                  if (snapshot.exists) {
                                    Map<String, dynamic> data =
                                        snapshot.data() as Map<String, dynamic>;

                                    Map<String, dynamic> previousItems =
                                        data['items'];

                                    for (var item in items) {
                                      String name = item['name'];
                                      if (previousItems.containsKey(name)) {
                                        previousItems.update(
                                            name,
                                            (value) =>
                                                value + item['quantity']);
                                      } else {
                                        previousItems
                                            .addAll({name: item['quantity']});
                                      }
                                    }
                                    doc.update({"items": previousItems});
                                  } else {
                                    Map<String, dynamic> updateData = {};
                                    for (var item in items) {
                                      updateData.addAll(
                                          {item["name"]: item["quantity"]});
                                    }
                                    doc.set({"items": updateData});
                                  }

                                  FirebaseFirestore.instance
                                      .collection('order')
                                      .doc(snap["id"])
                                      .delete();

                                  Navigator.pop(context);
                                });
                              }
                            },
                            child: const Text('Serve'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(isCalled? "Turn is called off" : "Turn is Called on"),
                          Switch(value: isCalled, onChanged: (val){
                            setState(() {
                              isCalled = !isCalled;
                            });

                            FirebaseFirestore.instance
                                .collection('order')
                                .doc(snap['id'])
                                .update({'isCalled': isCalled});
                          }),
                        ],
                      )
                    ]),
              ),
            ),
          ),
        ));
  }
}
