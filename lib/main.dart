import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text("Fluthon Quotes"),
        backgroundColor: Colors.black,
      ),
      body: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _itemCount = 0;

  var jsonResponse;

  String _Query;

  Future<void> getQuotes(query) async {
    String url = "http://10.0.2.2:5000/api/v1/?query=$query";
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        jsonResponse = convert.jsonDecode(response.body);
        _itemCount = jsonResponse.length;
      });
//      jsonResponse[0]["author"]; = author name
//      jsonResponse[0]["quote"]; = quotes text
      print("Number of quotes found : $_itemCount.");
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(

          children: <Widget>[
            Container(
              height: _itemCount == 0 ? 80 : 450,
              child: _itemCount == 0
                  ? Text("Loading...")
                  : ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius:
                        BorderRadius.all(Radius.circular(10))),
                    padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10),
                    margin:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          jsonResponse[index]["quote"], //quote
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          jsonResponse[index]["author"], //author name
                          style: TextStyle(
                              color: Colors.black, fontSize: 18),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: _itemCount,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "search quote here",
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                    onChanged: (value) {
                      _Query = value;
                      print(value);
                    },
                  ),
                  ButtonTheme(
                    minWidth: 100,
                    child: RaisedButton(
                      child: Text(
                        "get quotes",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.black87,
                      onPressed: () {
                        getQuotes(_Query);
                        setState(() {
                          _itemCount = 0;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}