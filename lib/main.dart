import 'package:flutter/material.dart';
import 'package:state_libraries/bloc/bloc_page.dart';
import 'package:state_libraries/get/get_page.dart';
import 'package:state_libraries/mobx/mobx_page.dart';
import 'package:state_libraries/provider/provider_page.dart';
import 'package:state_libraries/riverpod/riverpod_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("State Libraries"),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  child: Text("Bloc Page"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BlocWrapper()),
                    );
                  },
                ),
                OutlinedButton(
                  child: Text("Getx Page"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GetWrapper()),
                    );
                  },
                ),
                OutlinedButton(
                  child: Text("Mobx Page"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MobxPage()),
                    );
                  },
                ),
                OutlinedButton(
                  child: Text("Provider Page"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProviderWrapper()),
                    );
                  },
                ),
                OutlinedButton(
                  child: Text("Redux Page"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BlocPage()),
                    );
                  },
                ),
                OutlinedButton(
                  child: Text("Riverpod Page"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RiverpodWrapper()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
