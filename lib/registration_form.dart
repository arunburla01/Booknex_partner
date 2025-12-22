import 'package:booknex_partner/widgets/textformfield.dart';
import 'package:flutter/material.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final namecontroller = TextEditingController();
  final mobileController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Registration form'),
      ),
      body: Center(
        child: Form(
          // <- wrap fields in Form with _formKey
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Enter Owner Details",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          
              Column(
                children: [
                  TextformfieldRUW(labelname: "Name", controller: namecontroller),
                  TextformfieldRUW(
                    labelname: "Email",
                    controller: emailController,
                    regexp: RegExp(r'^[^@]+@[^@]+\.[^@]+'),
                    msg: "please enter valid email address",
                  ),
                  TextformfieldRUW(
                    labelname: "Mobile",
                    controller: mobileController,
                    regexp: RegExp(r'^\d{10}$'),
                    msg: "enter valid mobile number",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            print("Form validated successfully");
          }
        },
        tooltip: 'Save & Continue',
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    namecontroller.dispose();
    mobileController.dispose();
    super.dispose();
  }
}
