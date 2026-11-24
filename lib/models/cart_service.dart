import 'dart:convert'; // Para usar jsonEncode y jsonDecode
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importamos SharedPreferences
import 'cart_item.dart';
import 'producto.dart';

/// CartService: guarda los items del carrito en memoria y en SharedPreferences.
class CartService extends ChangeNotifier {
  // Singleton: instancia única
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];
  static const String _cartKey = 'waikiria_cart'; // Clave para guardar en el celu

  /// Lista de items (solo lectura desde afuera)
  List<CartItem> get items => List.unmodifiable(_items);

  /// Total de items (contando cantidades)
  int get totalItems => _items.fold(0, (sum, item) => sum + item.cantidad);

  /// Total en pesos
  double get total => _items.fold(0, (sum, item) => sum + item.subtotal);

  /// 1. CARGAR EL CARRITO (Se llama al iniciar la app)
  Future<void> cargarCarrito() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? carritoString = prefs.getString(_cartKey);

      if (carritoString != null) {
        final List<dynamic> listaJson = jsonDecode(carritoString);
        _items.clear(); // Limpiamos por las dudas
        for (var itemJson in listaJson) {
          _items.add(CartItem.fromJson(itemJson));
        }
        notifyListeners(); // Avisamos a la UI que ya hay items
      }
    } catch (e) {
      debugPrint('Error al cargar el carrito: $e');
    }
  }

  /// 2. GUARDAR EL CARRITO (Se llama cada vez que hay un cambio)
  Future<void> _guardarCarrito() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String carritoString = jsonEncode(
        _items.map((item) => item.toJson()).toList(),
      );
      await prefs.setString(_cartKey, carritoString);
    } catch (e) {
      debugPrint('Error al guardar el carrito: $e');
    }
  }

  /// Agrega un producto al carrito.
  void agregar(Producto producto, String talle, int cantidad) {
    final index = _items.indexWhere(
          (item) => item.producto.id == producto.id && item.talle == talle,
    );

    if (index >= 0) {
      _items[index].cantidad += cantidad;
    } else {
      _items.add(
        CartItem(producto: producto, talle: talle, cantidad: cantidad),
      );
    }

    _guardarCarrito(); // Guardamos en el teléfono
    notifyListeners(); // Avisa a las pantallas que se actualicen
  }

  /// Quita un item del carrito
  void quitar(CartItem item) {
    _items.remove(item);
    _guardarCarrito(); // Guardamos en el teléfono
    notifyListeners();
  }

  /// Vacía el carrito (después de la compra)
  void vaciar() {
    _items.clear();
    _guardarCarrito(); // Guardamos en el teléfono (se guarda vacío)
    notifyListeners();
  }
}