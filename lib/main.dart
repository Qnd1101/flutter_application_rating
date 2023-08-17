import 'package:flutter/material.dart';
import 'package:flutter_application_rating/meal_api.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _textEditingController = TextEditingController();
  var enabled = false;
  List<Score> score = [];
  double rate = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    score.add(Score(rate: 5, comment: '맛있어요'));
    score.add(Score(rate: 1, comment: '맛없어요'));
  }

  @override
  Widget build(BuildContext context) {
    var listView = ListView.separated(
      itemCount: score.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) => ListTile(
        leading: Text('${score[index].rate}'),
        title: Text(score[index].comment),
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
                setState(() {
                  rate = rating;
                  enabled = true;
                });
              },
            ),
            TextFormField(
              controller: _textEditingController,
              enabled: enabled,
              decoration: const InputDecoration(
                  hintText: '맛을 평가해주세요.',
                  label: Text('오늘의 급식 평가'),
                  border: OutlineInputBorder()),
              maxLength: 20,
            ),
            ElevatedButton(
                onPressed: enabled
                    ? () async {
                        var api = MealApi();
                        var evalDate = DateTime.now().toString().split(' ')[0];
                        var res = await api.insert(
                            evalDate, rate, _textEditingController.text);
                        print(res);

                        score.add(
                          Score(
                              rate: rate, comment: _textEditingController.text),
                        );
                        setState(() {
                          ListView;
                        });
                      }
                    : null,
                child: const Text('저장하기')),
            Expanded(child: listView)
          ],
        ),
      ),
    );
  }
}

class Score {
  double rate;
  String comment;

  Score({required this.rate, required this.comment});
}
