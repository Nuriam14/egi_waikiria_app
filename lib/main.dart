import 'package:flutter/material.dart';
import 'ui/screens/login_screen.dart';
import 'ui/theme/app_theme.dart';
import 'models/cart_service.dart'; // Importante importar el CartService

// Se vuelve asíncrono
void main() async {
  // 1. Asegura que los bindings de Flutter estén listos antes de usar SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Espera a que se cargue el carrito desde la memoria del celular
  await CartService().cargarCarrito();

  // 3. Recién ahí arranca la app
  runApp(const WaikiriaApp());
}

class WaikiriaApp extends StatelessWidget {
  const WaikiriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waikiria',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}