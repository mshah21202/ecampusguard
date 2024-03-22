import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../global/theme/cubit/theme_cubit.dart';
import '../../authentication/cubit/authentication_cubit.dart';
import '../../home/view/home_view.dart';
import '../../login/cubit/login_cubit.dart';
import '../../../global/router/routes.dart';

class LoginView extends StatelessWidget {
  const LoginView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    // Controllers
    final username = TextEditingController();
    final password = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      appBar: AppBar(
        title: const Center(
          child: Text(
            "eCampusGuard",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: const Color(0xFF565992),
      ),
          body:
          BlocConsumer<AuthenticationCubit, AuthenticationState>(
              listener: (context, state) {

/*
                if (state is Authenticated) {
                  // Navigate to the HomeView on successful authentication
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomePage()), // Update this with your HomeView
                  );
                } else if (state is FailedAuthentication) {
                  // Show an error message on failed authentication
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login Failed:')),
                  );}
*/

           },
             builder: (context, state) {
               if (state is LoginLaoding) {
                 return const Center(child: CircularProgressIndicator());
               }

               return Center(
                 child: SingleChildScrollView(
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       SizedBox(height: screenSize.height * 0.1),
                       Container(
                         width: screenSize.width > 600 ? 400 : screenSize
                             .width * 0.9,
                         padding: const EdgeInsets.all(20.0),
                         decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(8.0),
                           boxShadow: const [
                             BoxShadow(
                               color: Colors.black12,
                               blurRadius: 15.0,
                               offset: Offset(0, 10),
                             ),
                           ],
                         ),
                         child: Form(
                           child: Column(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               // Your logo here
                               Image.asset(
                                 'assets/images/ecampusLogo.png',
                                 width: 100,
                                 // Set your width and height accordingly
                                 height: 100,
                               ),
                               const SizedBox(height: 20),
                               const Text(
                                 'Login to eCampusGuard',
                                 style: TextStyle(
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold,
                                 ),
                               ),
                               const SizedBox(height: 20),
                               TextFormField(
                                 controller: username,
                                 decoration: const InputDecoration(
                                   labelText: 'Username',
                                   prefixIcon: Icon(Icons.person),
                                   border: OutlineInputBorder(),
                                 ),
                               ),
                               const SizedBox(height: 20),
                               TextFormField(
                                 controller: password,
                                 obscureText: true,
                                 decoration: const InputDecoration(
                                   labelText: 'Password',
                                   prefixIcon: Icon(Icons.lock),
                                   border: OutlineInputBorder(),
                                 ),
                               ),
                               const SizedBox(height: 30),
                               ElevatedButton.icon(
                                 onPressed: () {
/*                                   final authCubit = BlocProvider.of<AuthenticationCubit>(context);
                                   authCubit.login(
                                     username: username.text,
                                     password: password.text,
                                   );*/

                                 },
                                 icon: const Icon(Icons.login),
                                 label: const Text('Login'),
                                 style: ElevatedButton.styleFrom(
                                   foregroundColor: Colors.white,
                                   backgroundColor:  const Color(0xFF565992),
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(30.0),
                                   ),
                                   padding: const EdgeInsets.symmetric(
                                       horizontal: 30, vertical: 10),
                                 ),
                               ),
                               const SizedBox(height: 30),

                               //testing button
                               //i still dont know how to deal with routes excuse me
                               ElevatedButton.icon(
                                 onPressed: () {
                                   GoRouter.of(context).go(homeRoute);
                                 },
                                 icon: const Icon(Icons.login),
                                 label: const Text('NEXT'),
                                 style: ElevatedButton.styleFrom(
                                   foregroundColor: Colors.white,
                                   backgroundColor:  const Color(0xFF565992),
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(30.0),
                                   ),
                                   padding: const EdgeInsets.symmetric(
                                       horizontal: 30, vertical: 10),
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ),

                       SizedBox(height: screenSize.height * 0.1),
                     ],
                   ),
                 ),

               );
             }),
    );
  }
}






