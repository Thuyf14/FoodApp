import 'package:flutter/material.dart';

import 'auth_card.dart';
import 'app_banner.dart';
//Hien thi giao dien dang nhap va dang ki
class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Lay kich thuoc thiet bi hien tai
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              //tao nen cho giao dien voi mau 
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 180, 8, 131).withOpacity(0.5),
                  Color.fromARGB(255, 189, 15, 146).withOpacity(0.7),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0, 1],
              ),
            ),
          ),
          //Signle.. cuon nd khi qua kthc man
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                //appbanner Hien thi tieu de, authcard hien thi the dang nhap va dang ki
                children: <Widget>[AppBanner(), AuthCard()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
