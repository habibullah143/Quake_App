import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

late Map _data;
late List _features;
void main() async {
  _data = await getQuakes();
  _features = _data['features'];
  // ignore: avoid_print
  print(_data['features'][0]['properties']);

  runApp(const MaterialApp(
    title: "Quake App",
    home: Quake(),
    debugShowCheckedModeBanner: false,
  ));
}

class Quake extends StatelessWidget {
  const Quake({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quake"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Center(
          child: ListView.builder(
        padding: const EdgeInsets.all(15.0),
        itemBuilder: (BuildContext context, int position) {
          if (position.isOdd) return const Divider();
          final index = position ~/ 2;

          var format = DateFormat.yMMMMd("en_US").add_jm();
          var date = format.format(DateTime.fromMicrosecondsSinceEpoch(
              _features[index]['properties']['time'] * 1000,
              isUtc: true));
          return ListTile(
            title: Text(
              "At: $date}",
              style: const TextStyle(
                  fontSize: 15.5,
                  color: Colors.orange,
                  fontWeight: FontWeight.w500),
            ),
            subtitle: Text("${_features[index]['properties']['place']}",
                style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic)),
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Text(
                "${_features[index]['properties']['mag']}",
                style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontStyle: FontStyle.normal),
              ),
            ),
            onTap: () {
              _showAlertMessage(
                  context, "${_features[index]['properties']['title']}");
            },
          );
        },
        itemCount: _features.length,
      )),
    );
  }

  void _showAlertMessage(BuildContext context, String message) {
    var alert = AlertDialog(
      title: const Text('Quakes'),
      content: Text(message),
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'))
      ],
    );
    showDialog(builder: (context) => alert, context: context);
  }
}

Future<Map> getQuakes() async {
  //String apiUrl = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";

  http.Response response = await http.get(Uri.parse(
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson'));

  return json.decode(response.body);
}
