import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:generate_tool/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MainApp());
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<List<TextEditingController>> arrs = [];
  TextEditingController contentController = TextEditingController();
  TextEditingController typeController = TextEditingController(text: "thu/chi");
  TextEditingController versionController = TextEditingController();
  String categoryDropdownValue = categories.keys.first;
  String subcategoryDropdownValue = categories.values.first.first;
  List<int> ratio = [];
  List<TextEditingController> title = [];
  double progress = 0;
  TextEditingController quantityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Content"),
                            SizedBox(
                              width: 100,
                              child: TextField(
                                controller: contentController,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("type"),
                            SizedBox(
                              width: 100,
                              child: TextField(
                                controller: typeController,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("category"),
                            DropdownButton(
                              value: categoryDropdownValue,
                              items: categories.keys.map<DropdownMenuItem<String>>(
                                (value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                },
                              ).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    categoryDropdownValue = value;
                                    subcategoryDropdownValue = categories[categoryDropdownValue]!.first;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("sub-category"),
                            DropdownButton(
                              value: subcategoryDropdownValue,
                              items: categories[categoryDropdownValue]!.map<DropdownMenuItem<String>>(
                                (value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                },
                              ).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    subcategoryDropdownValue = value;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("version"),
                            SizedBox(
                              width: 100,
                              child: TextField(
                                controller: versionController,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("quantity"),
                            SizedBox(
                              width: 100,
                              child: TextField(
                                controller: quantityController,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                arrs.length,
                                (index) {
                                  final col = arrs[index];
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Visibility(
                                            visible: index != 0,
                                            child: IconButton(
                                              //left
                                              onPressed: () {
                                                setState(() {
                                                  arrs.swap(index, index - 1);
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.arrow_left,
                                              ),
                                            ),
                                          ),
                                          //close
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                arrs.removeAt(index);
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.close_rounded,
                                              color: Colors.red,
                                            ),
                                          ),
                                          //right
                                          Visibility(
                                            visible: index != arrs.length - 1,
                                            child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  arrs.swap(index, index + 1);
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.arrow_right,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              //ratio
                                              DropdownButton(
                                                value: ratio[index],
                                                items: List.generate(10, (i) => (i + 1) * 10).map<DropdownMenuItem<int>>(
                                                  (value) {
                                                    return DropdownMenuItem(
                                                      value: value,
                                                      child: Text("$value%"),
                                                    );
                                                  },
                                                ).toList(),
                                                onChanged: (value) {
                                                  if (value != null) {
                                                    setState(() {
                                                      ratio[index] = value;
                                                    });
                                                  }
                                                },
                                              ),
                                              SizedBox(
                                                width: 100,
                                                child: TextField(
                                                  controller: title[index],
                                                  decoration: const InputDecoration(
                                                      label: Text(
                                                    "title",
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  )),
                                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                                                ),
                                              ),
                                              ...List.generate(
                                                col.length,
                                                (index2) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: SizedBox(
                                                      width: 100,
                                                      child: TextField(
                                                        controller: col[index2],
                                                        decoration: InputDecoration(
                                                          suffixIcon: IconButton(
                                                            onPressed: () {
                                                              setState(
                                                                () {
                                                                  arrs[index].removeAt(index2);
                                                                },
                                                              );
                                                            },
                                                            icon: const Icon(Icons.close),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    arrs[index].add(TextEditingController());
                                                  });
                                                },
                                                icon: const Icon(Icons.add),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              title.add(TextEditingController());
                              arrs.add([TextEditingController()]);
                              ratio.add(100);
                            });
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () {
                      loadConfig();
                    },
                    child: const Text("Load config")),
                ElevatedButton(
                    onPressed: () {
                      exportConfig();
                    },
                    child: const Text("Save config")),
                ElevatedButton(
                    onPressed: () {
                      exportFile();
                    },
                    child: const Text("Export file")),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> exportConfig() async {
    Map<String, Object> res = {};
    res["content"] = contentController.text;
    res["type"] = typeController.text;
    res["category"] = categoryDropdownValue;
    res["subcategory"] = subcategoryDropdownValue;
    res["ratio"] = ratio;
    res["title"] = title.map((e) => e.text).toList();
    res["words"] = arrs.map((e) => e.map((e2) => e2.text).toList()).toList();
    res["version"] = versionController.text;
    res["quantity"] = quantityController.text;

    String? resultPath = await FilePicker.platform.saveFile(fileName: "config.tdcf", type: FileType.any);
    if (resultPath != null) {
      File(resultPath).writeAsStringSync(json.encode(res));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lưu cài đặt thành công")));
    }
  }

  Future<void> exportFile() async {
    String? resultPath = await FilePicker.platform.saveFile(fileName: "result.txt", type: FileType.any);

    if (resultPath != null) {
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      await gen(
        context,
        arrs,
        ratio,
        contentController,
        typeController,
        categoryDropdownValue,
        subcategoryDropdownValue,
        title,
        resultPath,
        int.tryParse(quantityController.text) ?? 0,
      );
      Navigator.pop(context);
    }
  }

  Future<void> loadConfig() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    try {
      if (result != null) {
        var file = File(result.files.single.path!);
        final String response = await file.readAsString(); //await rootBundle.loadString(result.files.single.path!);
        final data = await json.decode(response) as Map<String, dynamic>;
        // print(data["words"]);
        arrs = (data["words"] as List<dynamic>).map((e) {
          return (e as List<dynamic>).map((e2) => TextEditingController(text: e2 as String)).toList();
        }).toList();
        contentController.text = data["content"] as String;
        typeController.text = data["type"] as String;
        categoryDropdownValue = data["category"] as String;
        subcategoryDropdownValue = data["subcategory"] as String;
        ratio = (data["ratio"] as List<dynamic>).map((e) => e as int).toList();
        title = (data["title"] as List<dynamic>).map((e) => TextEditingController(text: e as String)).toList();
        versionController.text = data["version"] as String;
        quantityController.text = data["quantity"] as String;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Không hợp lệ")));
    }
    setState(() {});
  }
}

Future<void> gen(
  BuildContext context,
  List<List<TextEditingController>> arrs,
  List<int> ratio,
  TextEditingController contentController,
  TextEditingController typeController,
  String categoryDropdownValue,
  String subcategoryDropdownValue,
  List<TextEditingController> title,
  String resultPath,
  int quantity,
) async {
  List<List<String>> realArrs = [];
  for (int i = 0; i < arrs.length; i++) {
    var arr = arrs[i];
    arr.shuffle();
    arr = arr.sublist(0, (arr.length * ratio[i] + 99) ~/ 100);
    realArrs.add(arr.map((e) => e.text).toList());
  }
  var indexLst = List.generate(realArrs.length, (_) => 0);
  List<Map<String, Object>> result = [];

  while (quantity > 0) {
    quantity--;
    // double progress = 1;
    // for (int i = 0; i < indexLst.length; i++) {
    //   progress *= (indexLst[i] + 1) / (realArrs.length + 1);
    // }
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$progress%")));

    //print(List.generate(indexLst.length, (index) => realArrs[index][indexLst[index]]));
    Map<String, Object> tmp = {};
    var content = List.generate(
      indexLst.length,
      // (index) => (takeRatio(ratio[index])) ? realArrs[index][indexLst[index]] : "",
      (index) => (takeRatio(ratio[index])) ? realArrs[index][Random().nextInt(realArrs[index].length)] : "",
    );
    // for (int i = 0; i < content.length; i++) {
    //   content[i] = (Random().nextInt(10) < ratio[i] ~/ 10) ? content[i] : "";
    // }
    // print(content);
    tmp["content"] = content.where((e) => e != "").join(" ");
    tmp["type"] = typeController.text;
    tmp["category"] = categoryDropdownValue;
    tmp["subcategory"] = subcategoryDropdownValue;
    for (int i = 0; i < indexLst.length; i++) {
      // tmp[title[i].text] = realArrs[i][indexLst[i]];
      tmp[title[i].text] = content[i];
    }
    result.add(tmp);
    // int cur = 0;
    // while (cur < realArrs.length && realArrs[cur].length - 1 == indexLst[cur]) {
    //   indexLst[cur] = 0;
    //   cur++;
    // }
    // if (cur == realArrs.length) {
    //   break;
    // }
    // indexLst[cur]++;
  }
  await Isolate.run(() => File(resultPath).writeAsStringSync(json.encode(result)));
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Xuất thành công")));
}

extension SwappableList<E> on List<E> {
  void swap(int first, int second) {
    final temp = this[first];
    this[first] = this[second];
    this[second] = temp;
  }
}

bool takeRatio(int ratio) {
  return Random().nextInt(100) < ratio;
}
