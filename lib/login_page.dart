import 'package:flutter/material.dart';
import 'package:machine_test/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController place = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                ),
                child: TextField(
                  controller: place,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Center(
                child: Container(
                  color: const Color.fromARGB(255, 24, 116, 2),
                  child: TextButton(
                    onPressed: () {
                      final city = place.text;
                      place.clear();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                  city: city,
                                )),
                      );
                    },
                    child: const Text(
                      'Done',
                      style: TextStyle(
                          fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
