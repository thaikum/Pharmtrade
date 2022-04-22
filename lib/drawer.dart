import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmtrade/login_form.dart';
import 'package:pharmtrade/my_sales.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  getName() {
    return FirebaseAuth.instance.currentUser?.email;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 26.0),
            color: Colors.lightBlueAccent,
            width: double.infinity,
            height: 200.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.blue,
                      size: 60.0,
                    ),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    )),
                Text(
                  getName(),
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                )
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
            },
            leading: const Icon(
              Icons.bar_chart,
            ),
            title: const Text(
              "Report",
            ),
          ),

          //My sales
          ListTile(
            onTap: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const MySales()))
                  .then((value) => Navigator.pop(context));
            },
            leading: const Icon(
              Icons.real_estate_agent,
            ),
            title: const Text(
              "My sales",
            ),
          ),
          ListTile(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            leading: const Icon(
              Icons.logout,
            ),
            title: const Text(
              "Log out",
            ),
          )
        ],
      ),
    );
  }
}
