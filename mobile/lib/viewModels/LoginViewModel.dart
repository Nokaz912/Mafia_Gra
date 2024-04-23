import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/services/network/AccountService.dart';
import 'package:mobile/state/AccountState.dart';

import '../models/Account.dart';

class LoginViewModel extends ChangeNotifier {
  final _accountState = AccountState();
  final _accountService = AccountService();

  bool _loading = false;
  bool get loading => _loading;
  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> login(String log, String pass) async {
    _setLoading(true);
    try {
      Account account = await _accountService.login(log, pass);
      _accountState.setAccount(account);
      _setLoading(false);
      return true;
    } catch(e) {
      _setLoading(false);
      return false;
    }
  }

  void reset() {
    _loading = false;
  }
}
