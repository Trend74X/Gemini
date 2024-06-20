// import 'package:gemini_api/src/helper/constants.dart';
import 'dart:developer';
import 'dart:io';

import 'package:gemini_api/src/helper/constants.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends GetxController {
  
  RxBool isLoading = false.obs;
  List chat = [];
  XFile? image;

  askGemini(String question) async{
    // final apiKey = Platform.environment['geminiapiKey'];
    isLoading(true);
    try {
      chat.add({
        "role": "user",
        "content": question,
        "type": "text"
      });
      const apiKey = geminiapiKey;
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
      GenerateContentResponse response;
      if(image == null) {
        final content = [Content.text(question)];
        response = await model.generateContent(content);
      } else {
        final imageBytes = await image!.readAsBytes();
        final content = [
          Content.multi([
            TextPart(question),
            DataPart('image/png', imageBytes),
          ])
        ];
        response = await model.generateContent(content);
      }
      chat.add({
        "role": "gemini",
        "content": response.text,
        "type": "text"
      });
    } catch (e) {
      log(e.toString());
      chat.add({
        "role" : "system",
        "content": e.toString(),
        "type": "text"
      });
    } finally {
      isLoading(false);
    }
  }

  pickImage(source) async {
    final ImagePicker picker = ImagePicker();
    image = await picker.pickImage(source: source == 'camera' ? ImageSource.camera : ImageSource.gallery);
    if(image == null) return;
    chat.add({
      "role" : "user",
      "content": File(image!.path),
      "type": "image"
    });
  }

}