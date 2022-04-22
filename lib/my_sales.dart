import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MySales extends StatefulWidget {
  const MySales({Key? key}) : super(key: key);

  @override
  State<MySales> createState() => _MySalesState();
}

class _MySalesState extends State<MySales> {
  get userId => FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Sales"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('report')
            .doc(userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }

          if (!snapshot.hasData) {
            return const Text("No Data");
          }

          // String t = jsonEncode(snapshot.data?.data());
          Map<String, dynamic> data =
              snapshot.data?.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              children: [
                const TableRow(children: [
                  TableCell(
                    child: Text(
                      'Item',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "Quantity",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  )
                ]),
                for (var key in data['items'].keys)
                  TableRow(
                    children: [
                      TableCell(
                        child: Text(
                          key.toString(),
                        ),
                      ),
                      TableCell(
                        child: Text(
                          data['items'][key].toString(),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
