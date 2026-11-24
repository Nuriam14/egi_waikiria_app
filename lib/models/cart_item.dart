import 'producto.dart';

/// CartItem: representa un producto dentro del carrito.
/// Tiene un Producto + talle + cantidad.
class CartItem {
  final Producto producto;
  final String talle;
  int cantidad;

  CartItem({
    required this.producto,
    required this.talle,
    this.cantidad = 1,
  });

  /// Precio total del item (precio × cantidad)
  double get subtotal => producto.precio * cantidad;

  // --- MÉTODOS PARA PERSISTENCIA (NUEVOS) ---

  Map<String, dynamic> toJson() {
    return {
      'producto': producto.toJson(), // Llamamos al toJson del producto
      'talle': talle,
      'cantidad': cantidad,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      producto: Producto.fromJson(json['producto'] as Map<String, dynamic>),
      talle: json['talle'] as String,
      cantidad: json['cantidad'] as int,
    );
  }
}