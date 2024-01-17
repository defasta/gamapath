import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gamapath/screens/learning_module_cases_screen.dart';
import 'package:gamapath/screens/quiz_module_screen.dart';

import '../core/api_client.dart';
import '../model/LearningModuleDetailModel.dart';
import 'learning_module_detail_screen.dart';

class LearningModuleScreen extends StatefulWidget {
  final String categoryName;
  final String categoryId;
  const LearningModuleScreen({Key? key, required this.categoryName, required this.categoryId}): super(key: key);

  @override
  State<LearningModuleScreen> createState() => _LearningModuleScreen();
}

class _LearningModuleScreen extends State<LearningModuleScreen>{

  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage storage = new FlutterSecureStorage();

  Future<List<LearningModuleDetail>> getLearningModules() async {
    var token = await storage.read(key: 'token');
    List<LearningModuleDetail> learningModules= await _apiClient.getLearningModules(token!, widget.categoryId);
    return learningModules;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var paddingTopHeight = MediaQuery.of(context).viewPadding.top;
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.categoryName}"),
        backgroundColor: Colors.blue.shade200,
        actions: [
        ],
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
                          child:   FutureBuilder(
                            future: getLearningModules(),
                            builder: (context, AsyncSnapshot<List<LearningModuleDetail>> snapshot){
                              if(snapshot.hasData){
                                if(snapshot.connectionState == ConnectionState.waiting){
                                  return Container(
                                    width: size.width,
                                    height: size.height,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }else if (snapshot.error != null) {
                                  debugPrint("Error snapshot: ${snapshot.error.toString()}");
                                  return const Center(child: Text('Terjadi Error!'));
                                } else {
                                  var learningModule = snapshot.data;

                                  return
                                    Container(
                                      child:  Column(
                                        children: [
                                          ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              padding: EdgeInsets.symmetric(),
                                              shrinkWrap: true,
                                              itemCount: learningModule?.length,
                                              itemBuilder: (context, index){
                                                return GestureDetector(
                                                  child: Container(
                                                    child: Card(
                                                      child: Container(
                                                        alignment: Alignment.centerLeft,
                                                        margin:  EdgeInsets.symmetric(
                                                            vertical: 25, horizontal: 20),
                                                        child: Column(
                                                          children: <Widget>[
                                                            Text(learningModule![index].name)
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => LearningModuleCasesScreen(
                                                                categoryName: learningModule[index].name,
                                                                categoryId: widget.categoryId,
                                                                learningModuleId: learningModule[index].id.toString()
                                                            )
                                                        )
                                                    );
                                                  },
                                                );
                                              }),
                                        ],
                                      )
                                    );
                                }
                              }else {
                                debugPrint("error has no data snapshot: ${snapshot.error.toString()} category id : ${widget.categoryId}");
                              }
                              return const SizedBox();
                            },
                          )
                      )
                    ],
                  )
              ),
            )
        ),
      ),
    );
  }

}