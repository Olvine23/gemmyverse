import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
 
import 'package:ollygemini/screens/textWithImage.dart';
import 'package:ollygemini/screens/text_only.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Gemmyverse",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Lottie.asset('assets/rocket.json'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                
                  "Welcome to the GemmyVerse",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "Choose your path",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontSize: 16
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white
                    ),
                    onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context){
                  return const TextOnly();
                 }));
                  }, child: const Text("Text Only")),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                     style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white
                    ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const TextWithImage();
                        }));
                      },
                      child: const Text("Text With Image"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
