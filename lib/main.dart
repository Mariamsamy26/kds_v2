import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart' as loc;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'app/history_cycle/providers/history_provider.dart';
import 'app/orders_cycle/providers/kds_provider.dart';
import 'app/orders_cycle/views/kds_dashboard_screen.dart';
import 'styles/colors.dart';

int posId = 18;
int currencyId = 74;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  HttpOverrides.global = MyHttpOverrides();

  await loc.EasyLocalization.ensureInitialized();

  runApp(
    loc.EasyLocalization(
      supportedLocales: const [
        Locale('ar', ''),
        Locale('en', ''),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar', ''),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<KdsProvider>(
            create: (_) => KdsProvider(),
          ),
          ChangeNotifierProvider<HistoryProvider>(
            create: (_) => HistoryProvider(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1280, 740), // Tablet Landscape
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'BluBite KDS',
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          builder: (context, widget) {
            return Directionality(
              textDirection: context.locale.languageCode == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: widget!,
              ),
            );
          },
          theme: ThemeData(
            useMaterial3: false,
            scaffoldBackgroundColor: const Color(0xFFF3F5F8),
            appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: black),
              centerTitle: true,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 1,
            ),
          ),
          home: child,
        );
      },
      child: const KdsDashboardScreen(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
