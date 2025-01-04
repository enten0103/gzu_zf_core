class CannotParse implements Exception {
  @override
  String toString() => "CannotParse";
}

class NetNarrow implements Exception {
  @override
  String toString() => "NetNarrow";
}

class PasswordOrUsernameWrong implements Exception {
  @override
  String toString() => "PasswordOrUsernameWrong";
}

class SchoolNetCannotAccess implements Exception {
  @override
  String toString() => 'SchoolNetCannotAccess';
}

class NoSuchNav implements Exception {
  @override
  String toString() => "NoSuchNav";
}

class LoginFailed implements Exception {
  @override
  String toString() => "LoginFailed";
}
