import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/api_client.dart';
import '../model/FinishQuestionModel.dart';
import '../model/QuestionModel.dart';
import 'home_screen.dart';

class QuizPostScreen extends StatefulWidget{
  final String practicesId;
  const QuizPostScreen({Key? key, required this.practicesId});

  @override
  State<QuizPostScreen> createState() => _QuizPostScreen();
}

class _QuizPostScreen extends State<QuizPostScreen>{

  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage storage = new FlutterSecureStorage();

  Future<List<QuestionItem>> getQuestions() async {
    var token = await storage.read(key: 'token');
    List<QuestionItem> questions = await _apiClient.getPostTestQuestions(token!, widget.practicesId);
    return questions;
  }

  var _questionIndex = 0;
  var _isPreTestFinished = false;
  var _finalScore = "";
  List<QuestionItem> _questions = [];

  Future<void> saveAnsweredQuestions(String answerOption, String answerNumber) async {
    var token = await storage.read(key: 'token');
    dynamic res = await _apiClient.answerPostTest(token!, widget.practicesId, answerNumber, answerOption);
    if (res['success'] == true) {
      _answerQuestion(answerOption, answerNumber);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('Soal nomor $answerNumber terjawab!'),
      //   backgroundColor: Colors.green,
      // ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${res['message']}'),
        backgroundColor: Colors.red.shade300,
      ));
    }
  }

  Future<MyPreTestResults> finishPostTest() async {
    var token = await storage.read(key: 'token');
    MyPreTestResults result = await _apiClient.finishPostTest(token!, widget.practicesId);
    _finishPretest(result.point.toString());
    return result;
  }

  void _answerQuestion(String answerOption, String answerNumber ) {
    setState(() {
      _questionIndex = _questionIndex + 1;
    });
    // ignore: avoid_print
    print(_questionIndex);
    if (_questionIndex < _questions.length) {
      // ignore: avoid_print
      print('answer question: $answerOption, $answerNumber');
    } else {
      // ignore: avoid_print
      print('No more questions!');
    }
  }

  void _finishPretest(String score){
    setState(() {
      _isPreTestFinished = true;
      _finalScore = score;
    });
  }

  void _backToPreviousQuestion(){
    setState(() {
      _questionIndex = _questionIndex -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Post-Test"),
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
            physics: const BouncingScrollPhysics(),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: FutureBuilder(
                      future: getQuestions(),
                      builder: (context, AsyncSnapshot<List<QuestionItem>> snapshot){
                        if(snapshot.hasData){
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return Container(
                              width: size.width,
                              height: size.height,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else if (snapshot.error != null) {
                            debugPrint("Error snapshot: ${snapshot.error.toString()}");
                            return const Center(child: Text('Terjadi Error!'));
                          } else {

                            var questions = snapshot.data!;
                            var sortedQuestions = questions..sort((a,b) => a.number.compareTo(b.number));
                            _questions = sortedQuestions;
                            if(_isPreTestFinished == true){
                              return Container(
                                child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Result(score: _finalScore)
                                ),
                              );
                            }else{
                              return Container(
                                child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: _questionIndex < _questions!.length
                                        ? Quiz(
                                      answerQuestion: saveAnsweredQuestions,
                                      questionIndex: _questionIndex,
                                      questions: _questions,
                                      backToPreviousQuestion: _backToPreviousQuestion,
                                    ) :Submit(_backToPreviousQuestion, finishPostTest)
                                  //:Result(_totalScore, _resetQuiz),
                                ),
                              );
                            }
                          }
                        }else {
                          debugPrint("error has no data snapshot: ${snapshot.error.toString()}");
                        }
                        return const SizedBox();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}

class Quiz extends StatelessWidget {
  final List<QuestionItem> questions;
  final int questionIndex;
  final Function answerQuestion;
  final Function backToPreviousQuestion;

  const Quiz({
    Key? key,
    required this.questions,
    required this.answerQuestion,
    required this.questionIndex,
    required this.backToPreviousQuestion
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Nomor ${questionIndex + 1} dari ${questions.length} soal.", style: const TextStyle(
            fontSize: 14,
            color: Colors.black38,
            fontWeight: FontWeight.w300),),
        SizedBox(
          height: 20,
        ),
        Question(
          questions[questionIndex].question.toString(),
        ), //
        SizedBox(
          height: 20,
        ),
        Answer(() => answerQuestion("A", questions[questionIndex].number.toString()), questions[questionIndex].optionA, "A", questions[questionIndex].number.toString()),
        SizedBox(
          height: 15,
        ),
        Answer(() => answerQuestion("B", questions[questionIndex].number.toString()), questions[questionIndex].optionB, "B", questions[questionIndex].number.toString()),
        SizedBox(
          height: 15,
        ),
        Answer(() => answerQuestion("C", questions[questionIndex].number.toString()), questions[questionIndex].optionC, "C", questions[questionIndex].number.toString()),
        SizedBox(
          height: 15,
        ),
        Answer(() => answerQuestion("D", questions[questionIndex].number.toString()), questions[questionIndex].optionD, "D", questions[questionIndex].number.toString()),
        SizedBox(
          height: 15,
        ),
        questions[questionIndex].optionE != null ?  Answer(() => answerQuestion("E", questions[questionIndex].number.toString()), questions[questionIndex].optionE!, "E", questions[questionIndex].number.toString()) : Container(),
        SizedBox(
          height: 50,
        ),
        questionIndex > 0 ? GestureDetector(
          onTap: (){
            backToPreviousQuestion();
          },
          child: Text("Kembali ke soal sebelumnya", style: const TextStyle(
              fontSize: 14,
              color: Colors.blueAccent,
              fontWeight: FontWeight.w700),),
        ) : Container()
      ],
    ); //Column
  }
}


class Question extends StatelessWidget {
  final String questionText;

  const Question(this.questionText, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Html(data: questionText)
    ); //Contaier
  }
}

class Answer extends StatelessWidget {
  final Function answerQuestion;
  final String answerOption;
  final String answerText;
  final String answerNumber;

  const Answer(
      this.answerQuestion, this.answerText, this.answerOption, this.answerNumber, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // use SizedBox for white space instead of Container
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: //selectHandler(),
        (){
          answerQuestion();
        },
        style: ButtonStyle(
            textStyle:
            MaterialStateProperty.all(const TextStyle(color: Colors.white)),
            backgroundColor: MaterialStateProperty.all(Colors.grey.shade100)),
        child: Html(data: answerText),
      ),
    ); //Container
  }
}

class Submit extends StatelessWidget{
  final Function backToPreviousQuestion;
  final Function finishPretest;

  const Submit(this.backToPreviousQuestion, this.finishPretest, {Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
          ),
          Text("Anda telah menjawab semua soal!", style: const TextStyle(
              fontSize: 18,
              color: Colors.black38,
              fontWeight: FontWeight.w300),),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child:  ElevatedButton(
              onPressed: //selectHandler(),
                  (){
                finishPretest();
              },
              style: ButtonStyle(
                  textStyle:
                  MaterialStateProperty.all(const TextStyle(color: Colors.white)),
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              child: Text("Serahkan"),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child:  ElevatedButton(
              onPressed: //selectHandler(),
                  (){
                    backToPreviousQuestion();
                    },
              style: ButtonStyle(
                  textStyle:
                  MaterialStateProperty.all(const TextStyle(color: Colors.black)),
                  backgroundColor: MaterialStateProperty.all(Colors.grey)),
              child: Text("Kembali ke soal",),
            ),
          ),
        ],
      ),
    );
  }
}

class Result extends StatelessWidget{
  final String score;

  const Result({Key? key, required this.score}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
          ),
          Text("Nilai Anda :", style: const TextStyle(
              fontSize: 18,
              color: Colors.black38,
              fontWeight: FontWeight.w300),),
          SizedBox(
            height: 30,
          ),
          Text(score, style: const TextStyle(
              fontSize: 50,
              color: Colors.black38,
              fontWeight: FontWeight.w300),),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child:  ElevatedButton(
              onPressed: //selectHandler(),
                  (){
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                        HomeScreen()), (Route<dynamic> route) => false);
              },
              style: ButtonStyle(
                  textStyle:
                  MaterialStateProperty.all(const TextStyle(color: Colors.white)),
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              child: Text("Selesai"),
            ),
          ),
        ],
      ),
    );
  }
}
