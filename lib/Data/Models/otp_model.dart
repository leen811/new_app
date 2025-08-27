import 'package:equatable/equatable.dart';

class OtpModel extends Equatable {
  final String destination; // email or phone masked
  const OtpModel({required this.destination});

  @override
  List<Object?> get props => [destination];
}


