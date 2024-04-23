import 'package:mobile/viewModels/LoginViewModel.dart';
import 'package:test/test.dart';

void main() {
  test('Application should send login request', () {
      //Przygotowujemy potrzebne dane
      final loginViewModel = LoginViewModel();
      const login = "admin", password = "admin";

      //Wykonujemy operacje na funkcji
      Future<bool> returnValue = loginViewModel.login(login, password);

      //Sprawdzamy wyniki
      expect(returnValue, completion(equals(true)));
  });
}