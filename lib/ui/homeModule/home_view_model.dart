import 'package:flutter/cupertino.dart';

import '../../data/network/firebase_database.dart';

class HomeViewModel extends ChangeNotifier {
  final FirebaseDatabase _auth = FirebaseDatabase();

  void signOut() {
    _auth.signOut();
  }

}