import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const DrinkWheelApp());
}

class DrinkWheelApp extends StatefulWidget {
  const DrinkWheelApp({Key? key}) : super(key: key);

  @override
  _DrinkWheelAppState createState() => _DrinkWheelAppState();
}

class _DrinkWheelAppState extends State<DrinkWheelApp> {
  final List<String> options = ["季緣", "麻古", "得正", "七盞茶"];
  late final StreamController<int> controller;
  final TextEditingController _textController = TextEditingController();
  final List<Color> wheelColors = [
  Colors.cyan[700]!,
  Colors.cyan[600]!,
  Colors.cyan[500]!,
  Colors.cyan[400]!,
   ];

  @override
  void initState() {
    super.initState();
    controller = StreamController<int>.broadcast();
  }

  void addOption() {
    if (options.length < 12 && _textController.text.trim().isNotEmpty) {
      setState(() {
        options.add(_textController.text.trim());
        _textController.clear(); // Clear the text field after adding
      });
    }
  }

  void removeOption(int index) {
    if (options.length > 2) {
      setState(() {
        options.removeAt(index);
      });
    }
  }

  void spinWheel() {
    final selected = Random().nextInt(options.length);
    controller.add(selected);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        backgroundColor: Colors.cyan[50],
        appBar: AppBar(
          title: const Text("飲料轉盤 by Angela"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: FortuneWheel(
                  selected: controller.stream,
                  items: options.asMap().entries.map((entry) => FortuneItem(
                    style: FortuneItemStyle(
                      color: wheelColors[entry.key % wheelColors.length],
                      borderColor: Colors.white,
                      borderWidth: 2,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(entry.value,style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),),
                    ),
                  )).toList(),
                  animateFirst: false,
                ),
              ),
              const SizedBox(height: 20),
              // Add text input field and button in a row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: '輸入新選項',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      onSubmitted: (_) => addOption(), // Allow adding by pressing enter
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: addOption,
                    child: const Text("新增"),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: spinWheel,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 45),
                ),
                child: const Text("轉動轉盤"),
              ),
              const SizedBox(height: 20),
              Expanded(
                flex: 1,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(options[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => removeOption(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.close();
    _textController.dispose(); // Don't forget to dispose the text controller
    super.dispose();
  }
}
