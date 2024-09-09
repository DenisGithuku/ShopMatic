import 'package:flutter/material.dart';
import 'screens/new_product/new_product.dart';
import 'screens/home.dart';
import 'screens/detail.dart';

import 'colors.dart';

void main() {
  runApp(const ShopMatic());
}

class ShopMatic extends StatelessWidget {
  const ShopMatic({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: textColor),
          bodyMedium: TextStyle(color: textColor),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: primaryColor,
          textTheme: ButtonTextTheme.primary,
        ),
        appBarTheme:  AppBarTheme(
          color: backgroundColor,
          iconTheme: IconThemeData(color: secondaryColor),
        ),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => HomeScreen(),
        "/new_product": (context) => NewProductScreen(),
        "/detail": (context) => DetailScreen(),
      },
    );
  }
}
