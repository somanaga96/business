import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'component/page/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Home());
}



class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const LoginPage(),
      home: const HomePage(),
    );
  }
}
//
// class FirestoreExample extends StatelessWidget {
//   const FirestoreExample({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance.collection('loans').snapshots(),
//       builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//         if (!snapshot.hasData) {
//           return const CircularProgressIndicator();
//         }
//         var documents = snapshot.data!.docs;
//         return ListView.builder(
//           itemCount: documents.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text(documents[index]['name']),
//               subtitle: Text(documents[index]['amount'].toString()),
//             );
//           },
//         );
//       },
//     );
//   }
// }
