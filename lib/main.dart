import 'package:flutter/material.dart';
import 'screens/new_product/new_product.dart';
import 'screens/home.dart';
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
          bodyLarge: TextStyle(
              color: textColor,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500),
          bodyMedium: TextStyle(
              color: textColor,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: primaryColor,
          textTheme: ButtonTextTheme.primary,
        ),
        appBarTheme: const AppBarTheme(
          color: backgroundColor,
          iconTheme: IconThemeData(color: secondaryColor),
        ),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => HomeScreen(),
        "/new_product": (context) => NewProductScreen(),
      },
    );
  }
}
