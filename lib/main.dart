import 'dart:async';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart' show PlatformException; 
import 'attendanceController.dart';
import 'package:fluttertoast/fluttertoast.dart';



void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: HomePage(),
  theme: ThemeData(
    primaryColor: Color(0xFFf2944a),
  ),
));


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  String result = "";
  String trackValue;
  String weekNumber;
  String statusValue = "Present";
  String error = "";

 

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult.split("\n")[0].split(":")[1];
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }

  _sendData() {
    print(result.split("\n"));
    print(trackValue);
    print(weekNumber);

    if (trackValue != null && weekNumber != null && result != "") {
      Map _body = {
        "email": result.toLowerCase().trim(),
        "week": weekNumber.toLowerCase(),
        "track": trackValue.toLowerCase()
    };
    setState(() {
      error = "";
    });

    showdialogWidget(context);
    new Future( () async {
      String response = await AttendanceController.updateAttendance(_body);
      
      Color bgColor = Colors.green;

      if (response == null) {
         bgColor = Colors.red;
      } 

      Future.delayed(new Duration(seconds: 1),  (){
        Navigator.of(context, rootNavigator: true).pop('dialog');
          setState(() {
              result = "";
              trackValue = null;
              weekNumber = null;
            });
          Fluttertoast.showToast(
          msg: response,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: bgColor,
          textColor: Colors.white,
          fontSize: 16.0
        );
        });
    });
  
    

    

    // print(_body);
    } else {
      setState(() {
      error = "please update all field!!";
    });
    }
    
  }

  _updateTrack(String newValue) {
    print(newValue);
    setState(() {
      trackValue = newValue;
    });
    }

  _updateWeekNumber(String newValue) {
    setState(() {
      weekNumber = newValue;
    });
    }

  _updateStatusValue(String newValue) {
    setState(() {
      statusValue = newValue;
    });
    }

  List dropdownItemsWeek = List<int>.generate(14, (i) => i + 1)
                    .map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString()),
                      );
                    })
                    .toList();

  List dropdownItemsTrack = <String>['DS', 'ML', 'CV', 'NLP']
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                    .toList();

  List dropdownItemsStatus = <String>['Present', 'AOC']
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                    .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "QR Code Attendance Tracka",
                style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 20),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.all(30),
              child: Image.asset(
                'assets/images/qr_code.png',
                width: 300,
              ),
            ),
            SizedBox(height: 20,),
             result != "" ? Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Email Address: $result",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              )
            ) : Container(),
            SizedBox(height: 20,),
            result != "" ? Divider() : Container(),
            SizedBox(height: 10,),
            result != "" ? Container(
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                // runSpacing: 20.0,
                spacing: 30.0,
              children: <Widget>[
                Container(
                  width: 80,
                  child: new DropdownButtonHideUnderline(
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Track",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      )
                    ),
                    child: DropdownButton<String>(
                    value: trackValue,
                    onChanged: _updateTrack,
                    hint: new Text(
                          "Select",
                          style: TextStyle(fontSize: 14),
                        ),
                    items: dropdownItemsTrack,
                    style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
                  )
                  ),
                ),
                ),
        
                Container(
                  width: 80,
                  child: new DropdownButtonHideUnderline(
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Week",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                        )
                    ),
                    child: DropdownButton<String>(
                    value: weekNumber,
                    onChanged: _updateWeekNumber,
                    hint: new Text(
                          "Select",
                          style: TextStyle(fontSize: 14),
                        ),
                    items: dropdownItemsWeek,
                    style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500)
                  )
                  ),
                ),
                ),
                Container(
                  width: 80,
                  child: new DropdownButtonHideUnderline(
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Status",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                        )
                    ),
                    child: DropdownButton<String>(
                    value: statusValue,
                    onChanged: _updateStatusValue,
                    hint: new Text(
                          "Select",
                          style: TextStyle(fontSize: 14),
                        ),
                    items: dropdownItemsStatus,
                    style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500)
                  )
                  ),
                ),
                ),
              ],
            ),
            ): Container(),
            error != "" ? Container(
              alignment: Alignment.centerLeft,
              child: Text(error, style: TextStyle(color: Colors.red)),
            ) : Container(),
            
          ],
        )

      ),
  
      floatingActionButton: result == ""? FloatingActionButton.extended(
          onPressed: _scanQR,
          icon: Icon(Icons.camera_alt),
          label: Text("Scan"),
          backgroundColor: Color(0xFFf2944a),
      ) : FloatingActionButton.extended(
          onPressed: _sendData,
          icon: Icon(Icons.send),
          label: Text("Send"),
          backgroundColor: Color(0xFFf2944a),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}



 showdialogWidget(context) {
  return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new Dialog(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child: Container(
                height: 100,
                padding: EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new CircularProgressIndicator(backgroundColor: Color(0xFFf2944a)),
                    new SizedBox(
                      width: 20,
                    ),
                    new Text(
                      "Updating attendance...",
                      style: TextStyle(
                          color: Color(0xFF75002c), fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ));
        },
      );
}