import 'package:flight_hours_app/features/login/presentation/bloc/login_bloc.dart';
import 'package:flight_hours_app/features/login/presentation/widgets/login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  final void Function(String email, String password) onSubmit;
  const LoginForm({super .key, required this.onSubmit});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
   String _email = '';
   String _password = '';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSubmit(_email, _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            onSaved: (value) => _email = value!.trim(),
            validator: (value) => value!.isEmpty ? 'Email is required': null,
          ),
          const SizedBox(height: 16,),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            onSaved: (value) => _password = value !,
            validator: (value) => value!.isEmpty ? 'Password must be at least 6 characters': null,
          ),
          const SizedBox(height: 16),
          BlocBuilder<LoginBloc,LoginState>(
          builder:(context,state){
            if(state is LoginLoading){
              return const CircularProgressIndicator();
            }
          return LoginEnter(
            text: 'Login',
            onPressed: _submit,
          );
          },
          ),
        ],
      ),
    );
  }
}
