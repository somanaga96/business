import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'rate_card.dart';

class EggScreen extends StatefulWidget {
  const EggScreen({super.key});

  @override
  _EggScreenState createState() => _EggScreenState();
}

class _EggScreenState extends State<EggScreen> {
  List<Map<String, dynamic>> questions = [];
  int currentIndex = 0;
  DateTime selectedDate = DateTime.now();
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    fetchFirestoreData(selectedDate);
  }

  Future<bool> checkDataAvailable(DateTime date) async {
    DateTime dayStart = DateTime(date.year, date.month, date.day);
    DateTime dayEnd = dayStart.add(Duration(days: 1));

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('egg').get();

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data.containsKey('date') && data['date'] is Timestamp) {
        Timestamp timestamp = data['date'];
        DateTime storedDate = timestamp.toDate();
        if (storedDate.isAfter(dayStart) && storedDate.isBefore(dayEnd)) {
          return true;
        }
      }
    }
    return false;
  }

  void fetchFirestoreData(DateTime date) async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('egg').get();

    List<Map<String, dynamic>> tempList = [];
    DateTime dayStart = DateTime(date.year, date.month, date.day);
    DateTime dayEnd = dayStart.add(Duration(days: 1));

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      if (data.containsKey('date') && data['date'] is Timestamp) {
        Timestamp timestamp = data['date'];
        DateTime storedDate = timestamp.toDate();

        if (storedDate.isAfter(dayStart) && storedDate.isBefore(dayEnd)) {
          tempList.add({'docid': doc.id, ...data});
        }
      }
    }

    setState(() {
      questions = tempList;
      currentIndex = 0;
      selectedDate = date;
    });

    Future.delayed(Duration(milliseconds: 100), () {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    });
  }

  void nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        _pageController.jumpToPage(currentIndex);
      });
    }
  }

  void prevQuestion() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        _pageController.jumpToPage(currentIndex);
      });
    }
  }

  void nextPage() async {
    DateTime nextDate = selectedDate.add(Duration(days: 1));
    bool dataAvailable = await checkDataAvailable(nextDate);
    if (dataAvailable) {
      fetchFirestoreData(nextDate);
    }
  }

  void prevPage() async {
    DateTime prevDate = selectedDate.subtract(Duration(days: 1));
    bool dataAvailable = await checkDataAvailable(prevDate);
    if (dataAvailable) {
      fetchFirestoreData(prevDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "${selectedDate.toLocal()}".split(' ')[0],
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: questions.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> question = questions[index];
                      double rate = question['rate'];

                      return PageView(
                        scrollDirection: Axis.horizontal, // Enables sliding
                        children: [
                          RateCard(rate: rate),
                          RateCard(rate: rate - 0.05),
                          RateCard(rate: rate - 0.1),
                          RateCard(rate: rate - 0.15),
                        ],
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        bool dataAvailable = await checkDataAvailable(
                          selectedDate.subtract(Duration(days: 1)),
                        );
                        if (dataAvailable) prevPage();
                      },
                      child: Text("Previous Date"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        bool dataAvailable = await checkDataAvailable(
                          selectedDate.add(Duration(days: 1)),
                        );
                        if (dataAvailable) nextPage();
                      },
                      child: Text("Next Date"),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (currentIndex > 0)
                      ElevatedButton(
                        onPressed: prevQuestion,
                        child: Text("Previous Question"),
                      ),
                    if (currentIndex < questions.length - 1)
                      ElevatedButton(
                        onPressed: nextQuestion,
                        child: Text("Next Question"),
                      ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
    );
  }
}
