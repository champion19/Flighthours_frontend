class EmployeeEntityRegister {
  final String id;
  final String name;
  final String email;
  final String? password;
  final bool? emailConfirmed;
  final String idNumber;
  final String? bp;
  final String fechaInicio;
  final String fechaFin;
  final bool? vigente;
  final String? airline;

  EmployeeEntityRegister({
    required this.id,
    required this.name,
    required this.idNumber,
    required this.email,
    required this.password,
    this.emailConfirmed,
    this.bp,
    required this.fechaInicio,
    required this.fechaFin,
    this.vigente,
    this.airline,
  });

  factory EmployeeEntityRegister.empty() {
    return EmployeeEntityRegister(
      id: '',
      name: '',
      idNumber: '',
      email: '',
      password: '',
      emailConfirmed: false,
      bp: '',
      fechaInicio: '',
      fechaFin: '',
      vigente: false,
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
    String? bp,
    String? fechaInicio,
    String? fechaFin,
    bool? vigente,
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
