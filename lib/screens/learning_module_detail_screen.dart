import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gamapath/model/LearningModuleDetailModel.dart';

import '../core/api_client.dart';

class LearningModuleDetailScreen extends StatefulWidget {
  final String categoryId;
  final String casesId;
  final String learningModuleName;
  const LearningModuleDetailScreen({Key? key, required this.categoryId, required this.casesId, required this.learningModuleName,});

  @override
  State<LearningModuleDetailScreen> createState() => _LearningModuleDetailScreen();
}

class _LearningModuleDetailScreen extends State<LearningModuleDetailScreen>{

  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage storage = new FlutterSecureStorage();

  Future<List<ModulesItem>> getModules() async {
    var token = await storage.read(key: 'token');
    List<ModulesItem> cases = await _apiClient.getModules(token!, widget.categoryId, widget.casesId);
    return cases;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var paddingTopHeight = MediaQuery.of(context).viewPadding.top;
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.learningModuleName}"),
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
                      Padding(
                          padding: EdgeInsets.symmetric(),
                          child:   FutureBuilder(
                            future: getModules(),
                            builder: (context, AsyncSnapshot<List<ModulesItem>> snapshot){
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
                                } else if(snapshot.data == null){
                                  return Center(
                                    child: Text(
                                        "Maaf, tidak ada data dalam repository ini.",
                                        style: TextStyle(
                                            fontSize: 15.0, color: Colors.black87)),
                                  );
                                }else {
                                  var modules = snapshot.data;
                                  if(modules != null){
                                         return
                                    Container(
                                      child:  ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          padding: EdgeInsets.symmetric(),
                                          shrinkWrap: true,
                                          itemCount: modules?.length,
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
                                                        Container(
                                                          margin: EdgeInsets.all(8.0),
                                                          child: modules != null ? Column(
                                                            children: <Widget>[
                                                              modules![index].type != "DOCUMENT" ? Image.network(modules![index].file, fit: BoxFit.cover,) : SizedBox(),
                                                              SizedBox(height: 10,),
                                                              ListView.builder(
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  scrollDirection: Axis.vertical,
                                                                  padding: EdgeInsets.symmetric(),
                                                                  shrinkWrap: true,
                                                                  itemCount: modules![index].annotations.length,
                                                                  itemBuilder:(context, index2){
                                                                    return Container(
                                                                      alignment: Alignment.centerLeft,
                                                                      child: Column(
                                                                        children: [
                                                                          Text(modules![index].annotations[index2].description)
                                                                        ],
                                                                      ),
                                                                    );
                                                              })
                                                            ],
                                                          ) : Center(
                                                            child: Text(
                                                              "Maaf, tidak ada data dalam repository ini.",
                                                              style: TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors.black87
                                                              )
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) => LearningModuleScreen(
                                                //             categoriesName: categoriesModel[index].name,
                                                //             categoriesId: categoriesModel[index].id.toString()
                                                //         )
                                                //     )
                                                // );
                                              },
                                            );
                                          }),
                                    );
                                }else{
                                  debugPrint("error snapshot ${snapshot.error.toString()} category id : ${widget.categoryId}");
                                  return Center(
                                    child: Text(
                                        "Maaf, tidak ada data dalam repository ini.",
                                        style: TextStyle(
                                            fontSize: 15.0, color: Colors.black87)),
                                  );
                                }
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