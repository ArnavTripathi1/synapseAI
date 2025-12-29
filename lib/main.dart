import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'amplifyconfiguration.dart';
import 'core/theme/app_theme.dart';
import 'features/student/home/main_screen.dart';

// 2. Turn on the AWS Engine
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await _configureAmplify();
    runApp(const ProviderScope(child: MyApp()));
  } on Object catch (e) {
    print('Error configuring Amplify: $e');
    runApp(const MaterialApp(home: Scaffold(body: Center(child: Text('Startup Error')))));
  }
}


Future<void> _configureAmplify() async {
  if (!Amplify.isConfigured) {
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.addPlugin(AmplifyAPI());

    await Amplify.configure(amplifyconfig);
    safePrint("Amplify configured");
  }
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      // 3. Wrap App in Authenticator to handle Login/Session
      child: MaterialApp(
        title: 'Synapse',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        builder: Authenticator.builder(),
        home: const MainScreen(),
      ),
    );
  }
}
