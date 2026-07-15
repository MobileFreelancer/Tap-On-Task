import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/services/auth_service.dart';
import 'core/services/firebase_service.dart';
import 'core/services/task_service.dart';
import 'core/services/app_services.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/auth/providers/auth_form_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {}

  final firebaseReady = await FirebaseService.instance.initialize();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()..initializeFirebase()),
        ChangeNotifierProvider(create: (_) => AuthFormProvider()),
        ChangeNotifierProvider(create: (_) => TaskService()),
        ChangeNotifierProvider(create: (_) => HomeService()),
        ChangeNotifierProvider(create: (_) => SearchService()),
        ChangeNotifierProvider(create: (_) => BookingService()),
        ChangeNotifierProvider(create: (_) => PaymentService()),
        ChangeNotifierProvider(create: (_) => NotificationService()),
      ],
      child: TapOnTaskApp(firebaseReady: firebaseReady),
    ),
  );
}

class TapOnTaskApp extends StatelessWidget {
  final bool firebaseReady;
  const TapOnTaskApp({super.key, required this.firebaseReady});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthService>().tryAutoLogin();
      context.read<NotificationService>().fetchNotifications();
    });

    return MaterialApp.router(
      title: 'Tap On Task',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
