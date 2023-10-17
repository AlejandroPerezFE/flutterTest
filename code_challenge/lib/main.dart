import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Prueba Tecnica - NUNTIUS'),
        ),
        body: Center(
          child: MyWidget(),
        ),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String displayText = "Click 'Get Json' to load data";
  Uint8List byteData = Uint8List(0);
  bool isJsonLoaded = false; 
  bool canConvert = true; 

  Future<void> fetchJsonData() async {

    final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/todos/"));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final lastEntry = jsonData.isNotEmpty ? jsonData.last : {};
      final jsonText = JsonEncoder.withIndent('  ').convert(lastEntry);
      setState(() {
        displayText = jsonText;
        byteData = Uint8List.fromList(utf8.encode(displayText));
        isJsonLoaded = true; 
        canConvert = true; 
      });
    } else {
      setState(() {
        displayText = "Failed to load data";
        canConvert = true;
      });
    }
  }

  void convertToJson() {
    if (isJsonLoaded && displayText.isNotEmpty && canConvert) {
      byteData = Uint8List.fromList(utf8.encode(displayText));
      setState(() {
        displayText = "Converted to ByteArray (UTF-8):\n$byteData";
        canConvert = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          displayText,
          style: TextStyle(fontSize: 14.0),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: fetchJsonData,
              child: Text('Get Json'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, 
              ),
            ),
            SizedBox(width: 20), 
            ElevatedButton(
              onPressed: isJsonLoaded ? convertToJson : null, 
              child: Text('Convert JSON'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green, 
              ),
            ),
          ],
        ),
      ],
    );
  }
}
