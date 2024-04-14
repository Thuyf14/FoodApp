import 'dart:convert';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../shared/app_drawer.dart';

class ChatbotScreen1 extends StatefulWidget {
  static const routeName = '/chatbot';
  const ChatbotScreen1({super.key});
  @override
  _ChatbotScreen1State createState() => _ChatbotScreen1State();
}

class _ChatbotScreen1State extends State<ChatbotScreen1> {
  final messageInsert = TextEditingController();
  //Danh sach chua tn gom data 0 or 1 xac dinh tu nguoi dung hay chatbot va mess nd tn
  List<Map> _message = [];
  //Gui tn toi server chatbot va nhan phan hoi
  Future<void> _sendMessage(String message) async {
    final http.Response response = await http.post(
      Uri.parse(
          'https://e5a0-2401-d800-f729-2702-781e-9e0b-b2fd-6476.ngrok-free.app/webhooks/rest/webhook'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode({"sender": "user", "message": message}),
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      setState(() {
        // _response = responseData.isNotEmpty ? responseData.first['text'] : 'No response';
        _message.insert(0, {"data": 0, "message": responseData.first['text']});
      });
    } else {
      throw Exception('Failed to load response');
    }
  }

  //Giao dien man hinh
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chatbot",
        ),
      ),
      //menu huong ben trai
      drawer: const AppDrawer(),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Text(
                //Hien thi thoi gian hien tai
                "Hôm nay, ${DateFormat("Hm").format(DateTime.now())}",
                style: const TextStyle(fontSize: 15),
              ),
            ),
            Flexible(
              //Hien thi ds tn voi ListView.builder
                child: ListView.builder(
                    reverse: true,
                    itemCount: _message.length,
                    itemBuilder: (context, index) => chat( //hien thi tung tn trong listview
                        _message[index]["data"],
                        _message[index]["message"].toString()))),
            //Khoang cach giua tn va phan nhap tn
            const SizedBox(
              height: 20,
            ),
            //duong ke chia k/c tn va phan nhap tn
            const Divider(
              height: 5.0,
              color: Colors.grey,
            ),
            Container(
              child: ListTile(
                title: Container(
                  height: 35,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Color.fromRGBO(220, 220, 220, 1),
                  ),
                  padding: EdgeInsets.only(left: 15),
                  child: TextFormField(
                    //nguoi dung nhap tn
                    controller: messageInsert,
                    decoration: const InputDecoration(
                      hintText: "Nhập câu hỏi...",
                      hintStyle: TextStyle(color: Colors.black26),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    onChanged: (value) {},
                  ),
                ),
                //icon gui tn
                trailing: IconButton(
                    icon: const Icon(
                      Icons.send,
                      size: 30.0,
                      color: Colors.black,
                    ),
                    //xu ly khi user nhan nut gui tn
                    onPressed: () {
                      if (messageInsert.text.isEmpty) {
                        print("empty message");
                      } else {
                        setState(() {
                          _message.insert(
                              0, {"data": 1, "message": messageInsert.text});
                        });
                        // context.read<MessageManager>().addMessage('0', messageInsert.text);
                        _sendMessage(messageInsert.text);
                        messageInsert.clear();
                      }
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    }),
              ),
            ),
            const SizedBox(
              height: 15.0,
            )
          ],
        ),
      ),
    );
  }

  //for better one i have use the bubble package check out the pubspec.yaml
  //widget chua tn dua vao du lieu dau vao
  Widget chat(int data, String message) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment:
        //Xac dinh tn tu user-1 hay chatbot-0
            data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          data == 0
          //h/a cua nguoi nhan tn
              ? Container(
                  height: 40,
                  width: 40,
                  child: const CircleAvatar(
                    backgroundImage: AssetImage("assets/Images/robot-icon.png"),
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.all(10.0),
            //hien thi nd tn duoi dang bubble
            child: Bubble(
                radius: Radius.circular(15.0),
                color: data == 0 ? Colors.grey : Colors.purple,
                elevation: 0.0,
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(
                        width: 10.0,
                      ),
                      Flexible(
                          child: Container(
                        constraints: BoxConstraints(maxWidth: 200),
                        //noi dung tin nhan
                        child: Text(
                          message,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ))
                    ],
                  ),
                )),
          ),
          data == 1
          //h/a nguoi gui tn
              ? Container(
                  height: 40,
                  width: 40,
                  child: const CircleAvatar(
                    backgroundImage: AssetImage("assets/Images/user-icon.png"),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
