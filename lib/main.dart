import 'package:business/component/firebase/firebase_options.dart';
import 'package:business/component/utils/global.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'component/utils/side_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: (context) => Global(),
    child: const Home(),
  ));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Global>(
      builder: (context, global, child) => MaterialApp(
        title: 'Flutter Login',
        theme: global.getTheme(),
        home: SideMenuPage(),
      ),
    );
  }
}
