class AuthFixture {
  static Map<String, dynamic> loginSuccess = {
    'id': 'u_1',
    'name': 'مستخدم تجريبي',
    'email': 'user@example.com',
    'token': 'fake-token-123',
  };

  static Map<String, dynamic> loginError = {
    'message': 'بيانات الاعتماد غير صحيحة',
  };

  static Map<String, dynamic> forgotOk = {
    'message': 'تم إرسال الرمز',
  };

  static Map<String, dynamic> otpOk = {
    'status': 'ok',
  };

  static Map<String, dynamic> otpBad = {
    'status': 'bad',
    'message': 'رمز غير صحيح',
  };
}


