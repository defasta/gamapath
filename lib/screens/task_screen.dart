import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gamapath/screens/quiz_post_screen.dart';
import 'package:gamapath/screens/quiz_screen.dart';

import '../core/api_client.dart';
import '../model/TaskModel.dart';

class TaskScreen extends StatefulWidget {
  final String taskName;
  final String taskId;

  const TaskScreen({Key? key, required this.taskName, required this.taskId});

  @override
  State<TaskScreen> createState() => _TaskScreen();
}

class _TaskScreen extends State<TaskScreen>{

  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage storage = new FlutterSecureStorage();

  Future<TaskItem> getTaskDetail() async {
    var token = await storage.read(key: 'token');
    return await _apiClient.getTaskData(token!, widget.taskId);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskName),
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
            color: Colors.white,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child:    FutureBuilder(
                      future: getTaskDetail(),
                      builder: (context, AsyncSnapshot<TaskItem> snapshot){
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
                            var preTestResult = snapshot.data?.preTestResult;
                            var postTestResult = snapshot.data?.postTestResult;

                            return Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: size.width,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(0, 2),
                                            blurRadius: 5,
                                            color: Colors.black.withOpacity(0.3),
                                          ),]),
                                    child :Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.all(12),
                                              child:  Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text(
                                                    'Pre-Test',
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black38,
                                                        fontWeight: FontWeight.normal),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  preTestResult?.point != null ?
                                                  Text(
                                                    'Selesai',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.green,
                                                        fontWeight: FontWeight.bold),
                                                  ) : Text(
                                                   'Belum dikerjakan',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black38,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  preTestResult?.point == null ? Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: (){
                                                            Navigator.push(
                                                                context, 
                                                                MaterialPageRoute(
                                                                    builder: (context) => QuizScreen(practicesId: widget.taskId) )
                                                            );
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                              primary: Colors.blueAccent,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius.circular(10)),
                                                              padding: const EdgeInsets.symmetric(
                                                                  horizontal: 40, vertical: 15)),
                                                          child: const Text(
                                                            "Kerjakan",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ): Container(
                                                    padding: EdgeInsets.all(10),
                                                    child: Center(
                                                      child: Text(
                                                        'Nilai : ${preTestResult?.point}',
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.lightBlueAccent,
                                                            fontWeight: FontWeight.w500),
                                                      ),
                                                    ),
                                                    color: Colors.grey[100],
                                                  )
                                                ],
                                              )
                                          ),
                                        ]),
                                  ),
                                  // const SizedBox(height: 20),
                                  // Container(
                                  //   width: size.width,
                                  //   padding: const EdgeInsets.symmetric(
                                  //       vertical: 12, horizontal: 5),
                                  //   decoration: BoxDecoration(
                                  //       color: Colors.white,
                                  //       borderRadius: BorderRadius.circular(10),
                                  //       boxShadow: [
                                  //         BoxShadow(
                                  //           offset: Offset(0, 2),
                                  //           blurRadius: 5,
                                  //           color: Colors.black.withOpacity(0.3),
                                  //         ),]),
                                  //   child :Column(
                                  //       crossAxisAlignment: CrossAxisAlignment.start,
                                  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  //       children: [
                                  //         Padding(
                                  //             padding: EdgeInsets.all(12),
                                  //             child:  Column(
                                  //               crossAxisAlignment: CrossAxisAlignment.start,
                                  //               mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  //               children: [
                                  //                 Text(
                                  //                   'Modul',
                                  //                   style: const TextStyle(
                                  //                       fontSize: 18,
                                  //                       color: Colors.black38,
                                  //                       fontWeight: FontWeight.normal),
                                  //                 ),
                                  //                 const SizedBox(height: 20),
                                  //                 Row(
                                  //                   mainAxisAlignment: MainAxisAlignment.center,
                                  //                   children: [
                                  //                     Expanded(
                                  //                       child: ElevatedButton(
                                  //                         onPressed: (){
                                  //                           if(preTestResult != null){
                                  //
                                  //                           } else {
                                  //                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  //                               content: Text("Mohon kerjakan Pre-Test dahulu!"),
                                  //                               backgroundColor: Colors.redAccent,
                                  //                             ));
                                  //                           }
                                  //                         },
                                  //                         style: ElevatedButton.styleFrom(
                                  //                             primary: preTestResult?.point != null ? Colors.blueAccent : Colors.grey,
                                  //                             shape: RoundedRectangleBorder(
                                  //                                 borderRadius:
                                  //                                 BorderRadius.circular(10)),
                                  //                             padding: const EdgeInsets.symmetric(
                                  //                                 horizontal: 40, vertical: 15)),
                                  //                         child: const Text(
                                  //                           "Lihat",
                                  //                           style: TextStyle(
                                  //                             fontSize: 14,
                                  //                             fontWeight: FontWeight.bold,
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                     ),
                                  //                   ],
                                  //                 ),
                                  //               ],
                                  //             )
                                  //         ),
                                  //       ]),
                                  // ),
                                  const SizedBox(height: 20),
                                  Container(
                                    width: size.width,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(0, 2),
                                            blurRadius: 5,
                                            color: Colors.black.withOpacity(0.3),
                                          ),]),
                                    child :Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.all(12),
                                              child:  Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text(
                                                    'Post-Test',
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black38,
                                                        fontWeight: FontWeight.normal),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  postTestResult?.point != null ?
                                                  Text(
                                                    'Selesai',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.green,
                                                        fontWeight: FontWeight.bold),
                                                  ) : Text(
                                                    'Belum dikerjakan',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black38,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  postTestResult?.point == null ?
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: (){
                                                            if(preTestResult != null){
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => QuizPostScreen(practicesId: widget.taskId) )
                                                              );
                                                            } else {
                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                content: Text("Mohon kerjakan Pre-Test dahulu!"),
                                                                backgroundColor: Colors.redAccent,
                                                              ));
                                                            }
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                              primary: preTestResult?.point != null ? Colors.blueAccent : Colors.grey,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius.circular(10)),
                                                              padding: const EdgeInsets.symmetric(
                                                                  horizontal: 40, vertical: 15)),
                                                          child: const Text(
                                                            "Kerjakan",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ): Container(
                                                    padding: EdgeInsets.all(10),
                                                    child: Center(
                                                      child: Text(
                                                        'Nilai : ${postTestResult?.point}',
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.lightBlueAccent,
                                                            fontWeight: FontWeight.w500),
                                                      ),
                                                    ),
                                                    color: Colors.grey[100],
                                                  )
                                                ],
                                              )
                                          ),
                                        ]),
                                  ),
                                ],
                              ),
                            );
                          }
                        } else {
                          debugPrint("error has no data snapshot: ${snapshot.error.toString()}");
                        }
                        return const SizedBox();
                      },
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }

}