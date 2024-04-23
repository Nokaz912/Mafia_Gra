import 'package:flutter/cupertino.dart';

import '../models/Account.dart';

class AccountState extends ChangeNotifier {
  static AccountState? _instance;

  Account? _currentAccount;
  Account? get currentAccount => _currentAccount;

  AccountState._internal();

  factory AccountState() {
    _instance ??= AccountState._internal();
    return _instance!;
  }

  void setAccount(Account? account) {
    _currentAccount = account;
    notifyListeners();
  }
}