import 'dart:typed_data';

import 'package:flutter/material.dart';

class TeamListItem extends StatelessWidget {
  final int index;
  final String name;
  // final String profileImage;
  final Uint8List profileImage;
  final Function setIndex;

  TeamListItem({this.index, this.name, this.profileImage, this.setIndex});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (setIndex != null) {
          setIndex(context, index);
        }
      },
      child: Card(
        elevation: 5,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    color: Color.fromRGBO(33, 33, 33, 0.9),
                    child: Image.memory(
                      profileImage,
                      // base64.decode(profileImage),

                      // base64Decode(image),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    color: Color.fromRGBO(33, 33, 33, 1),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          this.name,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 5,
              right: 5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8)),
                  color: Theme.of(context).primaryColor,
                ),
                width: 25,
                height: 25,
                alignment: Alignment.center,
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        index.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
