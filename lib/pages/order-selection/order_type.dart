import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:page_transition/page_transition.dart';
import 'package:upbox/pages/order-selection/location_setter.dart';

import '../../providers.dart';

class OrderType extends StatefulWidget {
  const OrderType({super.key});

  @override
  State<OrderType> createState() => _OrderTypeState();
}

class _OrderTypeState extends State<OrderType> {
  bool? _isChecked = false;
  bool? _isChecked2 = false;
  bool? _isChecked3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
        iconTheme: const IconThemeData(size: 30),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: const Text(
          "TruckService",
          style: TextStyle(
            fontSize: 26,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 80, color: Colors.white),
                const Text(
                  "Truck type selection",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Select the type of truck you want to use for your delivery",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 25),
                Consumer(builder: (_, WidgetRef ref, __) {
                  return Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: 350,
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 4, bottom: 4),
                          decoration: BoxDecoration(
                            border: _isChecked == true
                                ? Border.all(width: 2, color: Colors.blue)
                                : Border.all(
                                    width: 2,
                                    color: const Color.fromARGB(
                                        255, 232, 230, 230),
                                  ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CheckboxListTile(
                            enableFeedback: true,
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              "Large truck",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            value: _isChecked,
                            onChanged: (bool? newValue) {
                              setState(() {
                                _isChecked = newValue;
                                _isChecked2 = false;
                                _isChecked3 = false;
                                ref.read(truckchosen.notifier).state = 1;
                              });
                            },
                            activeColor: Colors.blue,
                            checkColor: Colors.white,
                            subtitle: const Text(
                                "select this option for delivery of large items,machines and equipment"),
                            checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 4, bottom: 4),
                          decoration: BoxDecoration(
                            border: _isChecked2 == true
                                ? Border.all(width: 2, color: Colors.blue)
                                : Border.all(
                                    width: 2,
                                    color: const Color.fromARGB(
                                        255, 232, 230, 230),
                                  ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CheckboxListTile(
                            enableFeedback: true,
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              "Medium truck",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            value: _isChecked2,
                            onChanged: (bool? newValue) {
                              setState(() {
                                _isChecked2 = newValue;
                                _isChecked = false;
                                _isChecked3 = false;
                                ref.read(truckchosen.notifier).state = 2;
                              });
                            },
                            activeColor: Colors.blue,
                            checkColor: Colors.white,
                            subtitle: const Text(
                                "select this option for medium-sized items such as furniture, electronics, etc."),
                            checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 4, bottom: 4),
                          decoration: BoxDecoration(
                            border: _isChecked3 == true
                                ? Border.all(width: 2, color: Colors.blue)
                                : Border.all(
                                    width: 2,
                                    color: const Color.fromARGB(
                                        255, 232, 230, 230),
                                  ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CheckboxListTile(
                            enableFeedback: true,
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              "Small truck",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            value: _isChecked3,
                            onChanged: (bool? newValue) {
                              setState(() {
                                _isChecked3 = newValue;
                                _isChecked = false;
                                _isChecked2 = false;
                                ref.read(truckchosen.notifier).state = 3;
                              });
                            },
                            activeColor: Colors.blue,
                            checkColor: Colors.white,
                            subtitle: const Text(
                                "select this option for small items such as food, clothes, etc."),
                            checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                SizedBox(height: MediaQuery.of(context).size.height / 30),
                ElevatedButton(
                  onPressed: _isChecked == true ||
                          _isChecked2 == true ||
                          _isChecked3 == true
                      ? () {
                          if (_isChecked == true) {
                            SessionManager().set("item-type", 'Large items');
                          }
                          if (_isChecked2 == true) {
                            SessionManager().set("item-type", 'Medium items');
                          }
                          if (_isChecked3 == true) {
                            SessionManager().set("item-type", 'Small items');
                          }
                          Navigator.of(context).push(
                            PageTransition(
                              child: const LocSet(),
                              childCurrent: widget,
                              type: PageTransitionType.rightToLeftJoined,
                              duration: const Duration(milliseconds: 200),
                              reverseDuration:
                                  const Duration(milliseconds: 200),
                            ),
                          );
                        }
                      : null,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(20),
                    ),
                    // backgroundColor: MaterialStateProperty.all<Color>(),
                    shadowColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    elevation: MaterialStateProperty.all(0),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Order Truck Now",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
