import 'package:flutter/material.dart';

Widget project_screen_shimmer(context) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: 5,
    itemBuilder: (context, index) {
      return Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 250,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        color: Colors.white.withOpacity(0.3),
                        height: 12,
                        width: 15,
                      )),
                ],
              ),
              const SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    width: MediaQuery.of(context).size.width * 0.8,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    color: Colors.white,
                    height: 24,
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            color: Colors.white,
                            height: 25,
                            width: 25,
                          ),

                          const SizedBox(
                            width: 4.0,
                          ),
                          Container(
                            color: Colors.white,
                            height: 10,
                            width: 50,
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          Container(
                            color: Colors.white,
                            height: 25,
                            width: 25,
                          ),

                          const SizedBox(
                            width: 4.0,
                          ),
                          Container(
                            color: Colors.white,
                            height: 10,
                            width: 50,
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          // Icon(Icons.share),
                        ],
                      ),
                      Container(
                        color: Colors.white,
                        height: 25,
                        width: 25,
                      )
                    ],
                  ),
                  const Divider(),
                ],
              ),
            ]),
      );
    },
  );
}

