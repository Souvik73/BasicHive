import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Box<String> taxBox;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _payController = TextEditingController();

  @override
  void initState() {
    super.initState();
    taxBox = Hive.box<String>("IncomeTax");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Center(
          child: Text("Income Tax Management"),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: taxBox.listenable(),
              builder: (context, Box<String> tax, _) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    final key = tax.keys.toList()[index];
                    final value = tax.get(key);

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            "₹" + value!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        Text(
                          key,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Edit",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Icon(
                                          Icons.edit,
                                          color: Colors.grey[400],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  _idController.text = key;
                                  _payController.text = value;
                                  showeditdialog();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                    // borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Delete",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Icon(
                                          Icons.delete,
                                          color: Colors.grey[400],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  _idController.text = key;
                                  showdeletedialog();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (_, index) => Divider(
                    thickness: 2.0,
                    color: Colors.black,
                  ),
                  itemCount: tax.keys.toList().length,
                );
              },
            ),
          ),
          Container(
            color: Colors.grey[300],
            child: Row(
              
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    _idController.text = "";
                    _payController.text = "";
                    showadddialog();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  showeditdialog() {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    "Edit Income Tax Details",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Tax payer Id",
                  ),
                  controller: _idController,
                ),
                SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Tax Paid Amount",
                  ),
                  controller: _payController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  child: Text("Edit"),
                  onPressed: () {
                    if (_idController.text != "" && _payController.text != "") {
                      final key = _idController.text;
                      final value = _payController.text;
                      _payController.text = "";
                      _idController.text = "";

                      taxBox.put(key, value);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Enter Some Data"),
                      ));
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showdeletedialog() {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Delete Record",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Tax payer Id",
                  ),
                  controller: _idController,
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  child: Text("Delete"),
                  onPressed: () {
                    if (_idController.text != "") {
                      final key = _idController.text;
                      _idController.text = "";
                      taxBox.delete(key);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Enter Some Data"),
                      ));
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  showadddialog() {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    "Income Tax Details",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Tax payer Id",
                  ),
                  controller: _idController,
                ),
                SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Tax paid",
                  ),
                  controller: _payController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  child: Text("submit"),
                  onPressed: () {
                    if (_idController.text != "" && _payController.text != "") {
                      final key = _idController.text;
                      final value = _payController.text;
                      _payController.text = "";
                      _idController.text = "";

                      taxBox.put(key, value);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Enter Some Data"),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
