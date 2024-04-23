import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/services/network/AccountService.dart';
import 'package:mobile/state/AccountState.dart';

import '../models/Account.dart';

class RegisterViewModel extends ChangeNotifier {
  final AccountState _accountState = AccountState();
  final AccountService _accountService = AccountService();

  bool _loading = false;
  bool get loading => _loading;
  void _setLoading(bool value){
    _loading = value;
    notifyListeners();
  }

  Future<bool> register(String login, String email, String password) async {
    _setLoading(true);
    try {
      Account account = await _accountService.register(login, email, password);
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
