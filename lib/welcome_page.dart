import 'package:booknex_partner/ground_registration_wizard.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "Welcome To BookNex",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          "Register your turfing business and start earning",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        ElevatedButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>GroundRegistrationWizard() ));
        }, child: Text("register",style: Theme.of(context).textTheme.labelMedium,)),
      ],
    );
  }
}
