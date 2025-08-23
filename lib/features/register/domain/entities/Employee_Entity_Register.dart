class EmployeeEntityRegister {
  final String id;
  final String name;
  final String email;
  final String password;
  final bool? emailConfirmed;
  final String? idNumber;
  final int? bp;
  final String fechaInicio;
  final String fechaFin;
  final String vigente;
  final String airline;

  EmployeeEntityRegister({
    required this.id,
    required this.name,
    required this.idNumber,
    required this.email,
    required this.password,
    required this.emailConfirmed,
    required this.bp,
    required this.fechaInicio,
    required this.fechaFin,
    required this.vigente,
    required this.airline,    // <-- NUEVO
  });

  factory EmployeeEntityRegister.empty() {
    return EmployeeEntityRegister(
      id: '',
      name: '',
      idNumber: '',
      email: '',
      password: '',
      emailConfirmed: false,
      bp: 0,
      fechaInicio: '',
      fechaFin: '',
      vigente: '',
      airline: '',
    );
  }

  EmployeeEntityRegister copyWith({
    String? id,
    String? name,
    String? idNumber,
    String? email,
    String? password,
    bool? emailConfirmed,
    int? bp,
    String? fechaInicio,
    String? fechaFin,
    String? vigente,
    String? airline,
  }) {
    return EmployeeEntityRegister(
      id: id ?? this.id,
      name: name ?? this.name,
      idNumber: idNumber ?? this.idNumber,
      email: email ?? this.email,
      password: password ?? this.password,
      emailConfirmed: emailConfirmed ?? this.emailConfirmed,
      bp: bp ?? this.bp,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      vigente: vigente ?? this.vigente,
      airline: airline ?? this.airline,
    );
  }
}
