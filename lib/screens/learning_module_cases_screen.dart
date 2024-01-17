import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gamapath/screens/quiz_module_screen.dart';

import '../core/api_client.dart';
import '../model/LearningModuleDetailModel.dart';
import 'learning_module_detail_screen.dart';

class LearningModuleCasesScreen extends StatefulWidget {
  final String categoryName;
  final String categoryId;
  final String learningModuleId;
  const LearningModuleCasesScreen(
      {Key? key,
      required this.categoryName,
      required this.categoryId,
      required this.learningModuleId})
      : super(key: key);

  @override
  State<LearningModuleCasesScreen> createState() =>
      _LearningModuleCasesScreen();
}

class _LearningModuleCasesScreen extends State<LearningModuleCasesScreen> {
  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage storage = new FlutterSecureStorage();

  Future<List<CasesItem>> getCases() async {
    var token = await storage.read(key: 'token');
    List<CasesItem> cases = await _apiClient.getCases(
        token!, widget.categoryId, widget.learningModuleId);
    return cases;
  }

  Future<void> _displayEmptyModuleDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Modul Kosong', style: TextStyle(fontSize: 16)),
            content: const Text('Maaf, belum ada data pada modul ini.',
                style: TextStyle(fontSize: 14)),
            actions: <Widget>[
              MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<void> isQuestionAvailable(String learningModuleId) async {
    var token = await storage.read(key: 'token');
    dynamic res =
        await _apiClient.isQuizAvailable(token!, learningModuleId);
    if (res['success'] == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuizModuleScreen(
                    practicesId: widget.learningModuleId,
                  )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${res['message']}'),
        backgroundColor: Colors.red.shade300,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.categoryName}"),
        backgroundColor: Colors.blue.shade200,
        actions: [],
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Container(
            width: size.width,
            height: size.height,
            // decoration: BoxDecoration(image: DecorationImage(
            //     image : const AssetImage('assets/images/bg_main.png'),
            //     fit: BoxFit.fitHeight
            // ),),
            color: Colors.white,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                  child: Column(
                children: [
                  // Container(
                  //   width: size.width,
                  //   padding: const EdgeInsets.symmetric(
                  //       vertical: 12, horizontal: 5),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(10),),
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Container(
                  //         margin: EdgeInsets.all(12.0),
                  //         child: const Image(
                  //           width: 20,
                  //           height: 20,
                  //           image: AssetImage('assets/images/ic_setting.png'),),
                  //       ),
                  //       const SizedBox(width: 7),
                  //       Text(widget.categoryName,
                  //           style: const TextStyle(
                  //               fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w700)),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                      padding: EdgeInsets.symmetric(),
                      child: FutureBuilder(
                        future: getCases(),
                        builder:
                            (context, AsyncSnapshot<List<CasesItem>> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                width: size.width,
                                height: size.height,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else if (snapshot.error != null) {
                              debugPrint(
                                  "Error snapshot: ${snapshot.error.toString()}");
                              return const Center(
                                  child: Text('Terjadi Error!'));
                            } else {
                              var cases = snapshot.data;

                              return Container(
                                  child: Column(
                                children: [
                                  ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      padding: EdgeInsets.symmetric(),
                                      shrinkWrap: true,
                                      itemCount: cases?.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          child: Container(
                                            child: Card(
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 25,
                                                    horizontal: 20),
                                                child: Column(
                                                  children: <Widget>[
                                                    Text(cases![index].name)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            if (cases[index].modules.isEmpty) {
                                              _displayEmptyModuleDialog(
                                                  context);
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LearningModuleDetailScreen(
                                                              categoryId: widget
                                                                  .categoryId,
                                                              casesId: cases[
                                                                      index]
                                                                  .id
                                                                  .toString(),
                                                              learningModuleName:
                                                                  cases[index]
                                                                      .name
                                                                      .toString())));
                                            }
                                          },
                                        );
                                      }),
                                  Container(
                                    margin: EdgeInsets.all(20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              isQuestionAvailable(
                                                  widget.learningModuleId);
                                            },
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.blueAccent,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 40,
                                                        vertical: 15)),
                                            child: const Text(
                                              "Quiz",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ));
                            }
                          } else {
                            debugPrint(
                                "error has no data snapshot: ${snapshot.error.toString()} category id : ${widget.categoryId}");
                          }
                          return const SizedBox();
                        },
                      ))
                ],
              )),
            )),
      ),
    );
  }
}
