import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EggCrud extends StatefulWidget {
  const EggCrud({super.key});

  @override
  State<EggCrud> createState() => _EggCrudState();
}

class _EggCrudState extends State<EggCrud> {
  late Future<QuerySnapshot> _eggData;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    DateTime today = DateTime.now();
    DateTime last30Days = today.subtract(const Duration(days: 30));

    setState(() {
      _eggData = FirebaseFirestore.instance
          .collection('egg')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(last30Days))
          .orderBy('date', descending: true)
          .get();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Egg Rate List')),
      body: SingleChildScrollView(
        child: FutureBuilder<QuerySnapshot>(
          future: _eggData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error fetching data'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No data available'));
            }

            var eggList = snapshot.data!.docs;
            return Column(
              children: eggList.map((doc) {
                var data = doc.data() as Map<String, dynamic>;
                var rate = data['rate'];
                var date = (data['date'] as Timestamp).toDate();
                String amount = (rate % 1 == 0)
                    ? '${rate.toInt()}'
                    : rate.toStringAsFixed(2);
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Rate: \$${amount}'),
                    subtitle:
                        Text('Date: ${DateFormat('yyyy-MM-dd').format(date)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editData(doc.id, data),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteData(doc.id),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addData,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _editData(String docId, Map<String, dynamic> data) {
    TextEditingController rateController =
        TextEditingController(text: data['rate'].toString());
    DateTime selectedDate = (data['date'] as Timestamp).toDate();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: rateController,
                  decoration: const InputDecoration(labelText: 'Rate')),
              TextButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Text(
                    'Select Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('egg')
                    .doc(docId)
                    .update({
                  'rate': double.parse(rateController.text),
                  'date': Timestamp.fromDate(DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      DateTime.now().hour,
                      DateTime.now().minute,
                      DateTime.now().second)),
                });
                _fetchData();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteData(String docId) async {
    await FirebaseFirestore.instance.collection('egg').doc(docId).delete();
    _fetchData();
  }

  void _addData() {
    TextEditingController rateController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: rateController,
                  decoration: const InputDecoration(labelText: 'Rate')),
              TextButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Text(
                    'Select Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('egg').add({
                  'rate': double.parse(rateController.text),
                  'date': Timestamp.fromDate(DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      DateTime.now().hour,
                      DateTime.now().minute,
                      DateTime.now().second)),
                });
                _fetchData();
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
