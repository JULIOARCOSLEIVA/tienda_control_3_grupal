class CarritoItem {
  final String id;
  final String nombre;
  final double precio;
  final double stock;
  int cantidad;

  CarritoItem(
      {required this.id,
      required this.nombre,
      required this.precio,
      required this.stock,
      this.cantidad = 1});
}

class Carrito {
  List<CarritoItem> items = [];
}
