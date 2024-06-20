import 'package:flutter/material.dart';
import 'package:gemini_api/src/controlller/home_controller.dart';
import 'package:gemini_api/src/widget/custom_textfield.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final HomeController _con = Get.put(HomeController());
  final ScrollController _scrollController = ScrollController();
  TextEditingController questionCon = TextEditingController(); 

  @override
  void initState() {
    super.initState();
    _con.addListener(() {
      _scrollToBottom();
    });
  }

   @override
  void dispose() {
    _scrollController.dispose();
    _con.removeListener(() {});
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white24,
          body: Stack(
            children: [
              chatArea(),
              textfield()
            ],
          ),
        ),
      )
    );
  }

  textfield() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 80.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await showMediaOptions();
                    setState(() { });
                    _scrollToBottom();
                  },
                  child: const Icon(Icons.image)
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                flex: 3,
                child: CustomTextField(
                  controller: questionCon,
                )
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    if(questionCon.text.trim() !=  '') {
                      FocusScope.of(context).unfocus();
                      await _con.askGemini(questionCon.text.trim());
                      questionCon.clear();
                      setState(() { });
                      _scrollToBottom();
                    }
                  }, 
                  child: Obx(() => 
                    _con.isLoading.isTrue
                      ? const SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: CircularProgressIndicator()
                      )
                      : const Text('Ask')
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  chatArea() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 100.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: _con.chat.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8.0,),
                itemBuilder: (context, index) {
                  bool isUser = _con.chat[index]['role'] == 'user' ? true : false;
                  bool isWarning = _con.chat[index]['role'] == 'system' ? true : false;
                  var content = _con.chat[index]['content'];
                  bool isImage = _con.chat[index]['type'] == "image" ? true : false;
                  return LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          mainAxisAlignment: isUser
                              ? MainAxisAlignment.end
                              : isWarning
                                ? MainAxisAlignment.center
                                : MainAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: constraints.maxWidth * 0.75,
                              ),
                              child: IntrinsicWidth(
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 5.0),
                                  decoration: BoxDecoration(
                                    color: isUser ? Colors.blue : isWarning ? Colors.red  : Colors.grey,
                                      borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: isImage
                                    ? displayImg(content, index)
                                    : Text(
                                      content,
                                      textAlign: isUser ? TextAlign.end : isWarning ? TextAlign.center : TextAlign.start,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  showMediaOptions() {
    return Get.bottomSheet(
      SizedBox(
        height: 150.0,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.camera, color: Colors.white),
              title: const Text('Camera', style: TextStyle(color: Colors.white)),
              onTap: () async {
                await _con.pickImage('camera');
                Get.back(result: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo, color: Colors.white),
              title: const Text('Photo', style: TextStyle(color: Colors.white)),
              onTap: () async {
                await _con.pickImage('gallery');
                Get.back(result: true);
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black87
    );
  }

  displayImg(content, index) {
    return Stack(
      children: [
        SizedBox(
          height: 250.0,
          width: 250.0,
          child: Image.file(content!, fit: BoxFit.fill)
        ),
        Positioned(
          left: 2.0,
          child: Visibility(
            visible: _con.chat.length - 1 == index,
            child: Container(
              height: 30.0,
              decoration: const BoxDecoration(
                color: Colors.red, 
                shape: BoxShape.circle
              ),
              child: IconButton(
                onPressed: () {
                  _con.chat.removeAt(index);
                  setState(() { });
                },
                icon: const Icon(Icons.close, size: 18.0,)
              ),
            ),
          ),
        )
      ],
    );
  }

}