import 'package:flutter/material.dart';
import 'package:spotter/services/session_svc.dart';

import '../constants.dart';


class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget child;
  final Function onPressed;
  final Function onTitleTapped;
  final SessionSvc svc;

  @override
  final Size preferredSize;

   const TopBar({required this.title, required this.child, required this
       .onPressed, required this.onTitleTapped, required this.svc})
      : preferredSize = const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Column(
        children: <Widget>[
          // SizedBox(height: 30,),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Hero(
                tag: 'topBarBtn',
                child: Card(
                  color: Colors.white,
                  elevation: 10,
                  shape: kBackButtonShape,
                  child: MaterialButton(
                    height: 50,
                    minWidth: 50,
                    elevation: 10,
                    shape: kBackButtonShape,
                    onPressed: (){onPressed();},
                    child: child,
                  ),
                ),
              ),
              // SizedBox(
              //   width: 50,
              // ),
              Hero(
                tag: 'title',
                transitionOnUserGestures: true,
                child: Card(
                  color: Colors.blueGrey,
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                    ),
                  ),
                  child: InkWell(
                    onTap: (){onTitleTapped();},
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: 50,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Row(
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                   color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}