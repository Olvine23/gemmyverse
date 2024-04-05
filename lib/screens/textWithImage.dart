import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:ollygemini/main.dart';

class TextWithImage extends StatefulWidget {
  const TextWithImage({super.key});

  @override
  State<TextWithImage> createState() => _TextWithImageState();
}

class _TextWithImageState extends State<TextWithImage> {
  bool loading = false;
  List textAndImageChat = [];
  List textWithImageChat = [];
  File? imageFile;

  final ImagePicker picker = ImagePicker();

  final TextEditingController _textController = TextEditingController();
  final ScrollController _controller = ScrollController();

  final gemmy = GoogleGemini(apiKey: apiKey!);

  // Text only input
  void fromTextAndImage({required String query, required File image}) {
    setState(() {
      loading = true;
      textAndImageChat.add({
        "role": "Olly",
        "text": query,
        "image": image,
      });
      _textController.clear();
      imageFile = null;
    });
    scrollToTheEnd();

    gemmy.generateFromTextAndImages(query: query, image: image).then((value) {
      setState(() {
        loading = false;
        textAndImageChat
            .add({"role": "Wiz Gemini", "text": value.text, "image": ""});
      });
      scrollToTheEnd();
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
        textAndImageChat
            .add({"role": "Gemini", "text": error.toString(), "image": ""});
      });
      scrollToTheEnd();
    });
  }

  void scrollToTheEnd() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Gemmyverse Text With Image Path",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  controller: _controller,
                  itemCount: textAndImageChat.length,
                  itemBuilder: (context, index) {
                    return loading ? Center(child:  Lottie.asset('assets/bubble.json'),) : ListTile(
                      isThreeLine: true,
                      leading: CircleAvatar(
                        child: Text(
                            textAndImageChat[index]["role"].substring(0, 1)),
                      ),
                      title: Text(
                        textAndImageChat[index]["role"],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(textAndImageChat[index]["text"]),
                      trailing: textAndImageChat[index]["image"] == ""
                          ? null
                          : Image.file(
                              textAndImageChat[index]["image"],
                              width: 90,
                            ),
                    );
                  })),
          Column(
            children: [
              Text(
                "Remember to attach an image. It is required here",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Container(
                alignment: Alignment.bottomRight,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: "Write a message",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none),
                          fillColor: Colors.transparent,
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_a_photo),
                      onPressed: () async {
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        setState(() {
                          imageFile = image != null ? File(image.path) : null;
                        });
                      },
                    ),
                    IconButton(
                      icon: loading
                          ? const CircularProgressIndicator()
                          : const Icon(Icons.send),
                      onPressed: () {
                        if (imageFile == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please select an image")));
                          return;
                        }
                        fromTextAndImage(
                            query: _textController.text, image: imageFile!);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: imageFile != null
          ? Container(
              margin: const EdgeInsets.only(bottom: 80),
              height: 150,
              child: Image.file(imageFile ?? File("")),
            )
          : null,
    );
  }
}
