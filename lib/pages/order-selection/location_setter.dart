import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:upbox/pages/maps_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:upbox/services/location_service.dart';

class LocSet extends StatefulWidget {
  const LocSet({super.key});

  @override
  State<LocSet> createState() => _LocSetState();
}

class _LocSetState extends State<LocSet> {
  TextEditingController inputOne = TextEditingController();
  TextEditingController inputTwo = TextEditingController();

  // final bool _isbtnActive = false;
  bool editing1 = false;
  bool editing2 = false;

  String? countryName;
  String? state;

  List<String> locationSuggestions = [];

  void locationData() async {
    try {
      var url = Uri.parse('http://ip-api.com/json');
      Response response = await http.get(url);
      Map data = json.decode(response.body);
      // Getting the variables from the API
      String country = data['country'];
      String region = data['regionName'];
      String city = data['city'];
      // print(country + region + city);

      setState(() {
        countryName = country;
        state = city;
      });
      debugPrint(region);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  var placeList = [
    'Area one',
    'Area 11',
    'Area 22',
  ];
  @override
  void initState() {
    super.initState();
    locationData();
  }

  Future<dynamic> getLocationSuggestion(String query) async {
    var key = LocationService().key;
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$key');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      final places = json.decode(response.body);

      // var result = {
      //   'places_prediction1': places['predictions'][0]['description'],
      //   'places_prediction2': places['predictions'][1]['description'],
      //   'places_prediction3': places['predictions'][2]['description'] ?? '',
      //   'places_prediction4': places['predictions'][3]['description'] ?? '',
      // };
      if (places['predictions'].length > 0) {
        var result = {
          'places_prediction1': places['predictions'][0]['description'],
          'places_prediction2': places['predictions'][1]['description'],
          'places_prediction3': places['predictions'][2]['description'] ?? '',
          'places_prediction4': places['predictions'][3]['description'] ?? '',
        };

        // print(result);
        setState(() {
          locationSuggestions = List<String>.from(places['predictions']
              .map((prediction) => prediction['description']));
        });
      } else {
        // print('No predictions found');
        setState(() {
          locationSuggestions.clear();
        });
      }
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  // Function to handle when a suggestion is tapped
  void onSuggestionSelected(String suggestion, TextEditingController input) {
    setState(() {
      input.text = suggestion;
      locationSuggestions.clear();
      if (input == inputOne) {
        editing1 = false;
      } else {
        editing2 = false;
      }
    });
    FocusScope.of(context)
        .nextFocus(); // Move to the next field after selecting the suggestion
  }

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
          child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 80, color: Colors.white),
              const Text(
                "Enter location",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Enter the pick up and delivery location of your item",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              Align(
                child: TextFormField(
                  // enabled: false,
                  controller: inputOne,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(23),
                    hintText: "Enter pick up location",
                    prefixIcon: const Icon(Icons.fire_truck),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) async {
                    await getLocationSuggestion(value);
                    setState(() {
                      editing1 = true;
                    });
                  },
                  onEditingComplete: () {
                    setState(() {
                      locationSuggestions.clear();
                      editing1 = false;
                    });
                    FocusScope.of(context).nextFocus();
                  },
                ),
              ),
              const SizedBox(height: 40),
              if (locationSuggestions.isNotEmpty && editing1 == true)
                suggestionList(),
              const SizedBox(height: 40),
              TextFormField(
                onChanged: (value) async {
                  await getLocationSuggestion(value);
                  // setState(() {
                  //   _isbtnActive = value.length >= 5 ? true : false;
                  // });
                },
                controller: inputTwo,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(23),
                  hintText: "Enter delivery location",
                  prefixIcon: const Icon(Icons.fire_truck_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              if (locationSuggestions.isNotEmpty)
                Container(
                  height: 200, // Adjust the height as needed
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    itemCount: locationSuggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = locationSuggestions[index];
                      return GestureDetector(
                        onTap: () => onSuggestionSelected(suggestion, inputTwo),
                        child: Card(
                          child: ListTile(
                            title: Text(suggestion),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              SizedBox(height: MediaQuery.of(context).size.height / 8),
              Container(
                alignment: const Alignment(0, 0.7),
                child: ElevatedButton(
                  onPressed: inputOne.text.isNotEmpty == true &&
                          inputTwo.text.isNotEmpty == true
                      ? () {
                          Navigator.of(context).push(
                            PageTransition(
                              child: MainScreen(
                                sourceLocationName: inputOne.text,
                                destinationName: inputTwo.text,
                                // cNAme: countryName.toString(),
                                // sName: state.toString(),
                              ),
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
                        "Order Truck",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  Container suggestionList() {
    return Container(
      height: 200, // Adjust the height as needed
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        itemCount: locationSuggestions.length,
        itemBuilder: (context, index) {
          final suggestion = locationSuggestions[index];
          return GestureDetector(
            onTap: () => onSuggestionSelected(suggestion, inputOne),
            child: Card(
              child: ListTile(
                title: Text(suggestion),
              ),
            ),
          );
        },
      ),
    );
  }
}
