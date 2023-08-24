import 'package:flutter/material.dart';
import 'package:flutter_application_rating/meal_api.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _textEditingController = TextEditingController();
  var enabled = false;
  double rate = 0;
  String now = '날짜를 선택하세요';
  dynamic listView = const Text('결과출력화면');

  void showReview({required String evalDate}) async {
    var api = MealApi();
    var result = api.getReview(evalDate: evalDate);
    setState(() {
      listView = FutureBuilder(
        future: result,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // 데이터가 있을 때
            var data = snapshot.data;
            return ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                      leading: Text(data[index]['rating']),
                      title: Text(data[index]['comment']));
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: data.length);
          } else {
            // 데이터가 없을 때
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  var dt = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime.now(),
                  );
                  if (dt != null) {
                    var date = dt.toString().split(' ')[0];
                    setState(() {
                      now = date;
                    });
                    showReview(evalDate: date);
                  }
                },
                child: Text(now)),
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
                            now, rate, _textEditingController.text);
                        showReview(evalDate: now);
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
