import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../login.dart';

class LoginView extends StatelessWidget {
  const LoginView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    return Scaffold(
      body:
      Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height*0.15,
              ),
// Image.asset('images/ecampusLogo.png'),

              Container(
                width: MediaQuery.of(context).size.width*0.3,
                height: MediaQuery.of(context).size.width*0.3,
                child: Image.asset('images/ecampusLogo.png',
                  fit: BoxFit.contain,
                ),

              ) ,
              const SizedBox(height: 50,),


              Card(
                margin: EdgeInsets.symmetric(horizontal: 40),
                child:
                Padding(padding: EdgeInsets.all(10),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      const Text(
                        'Welcome to eCampusGuard',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,

                        ),
                      ),

//space
                      SizedBox(height: 20,),
                      const TextField(
                        decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: 'UserName'
                        ),

                        keyboardType: TextInputType.text,
                      ),
//space
                      SizedBox(height: 20,),
                      const TextField(
                        decoration: InputDecoration(
                            icon: Icon(Icons.lock),
                            labelText: 'Password'
                        ),

                        keyboardType: TextInputType.text,
                      ),

//space
                      SizedBox(height: 30,),

// ElevatedButton(
//
//   onPressed: (null),
//   child: Text('Login'),
//
//   style:ButtonStyle(
//
//   ),
// )
                      ElevatedButton.icon(

                        onPressed: (null),
                        icon: Icon(Icons.login),

                        label:  Text('login'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            )

                        ),

                      )
                    ],
                  ),

                ),
              )
            ],
          ),
        ),
      ),
    );  }
}






