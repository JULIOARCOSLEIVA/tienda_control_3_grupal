import 'package:flutter/material.dart';
import 'package:control3grupo/pantalla/carro_pantalla.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'pantalla/login_pantalla.dart';
import 'carrito_model.dart';
import 'estado_global.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final ValueNotifier<bool> usuarioConectado;
  final ValueNotifier<int> cantidadProductosCarrito;

  CustomAppBar({
    required this.title,
    required this.usuarioConectado,
    required this.cantidadProductosCarrito,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        ValueListenableBuilder<int>(
          valueListenable: cantidadProductosCarrito,
          builder: (context, value, child) {
            return Stack(
              alignment: Alignment.topRight,
              children: [
                PopupMenuButton<Map<String, dynamic>>(
                  onSelected: (producto) {
                    print(
                        "Producto seleccionado: $producto"); // ver que funcione el boton.
                    if (producto.containsKey('action') &&
                        producto['action'] == 'verCarro') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CarroPantalla()),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return carrito.items.map((CarritoItem item) {
                      return PopupMenuItem<Map<String, dynamic>>(
                        value: {
                          'id': item.id,
                          'nombre': item.nombre,
                          'precio': item.precio
                        },
                        child: ListTile(
                          title: Text(item.nombre),
                          subtitle: Text(
                            'Cantidad: ${item.cantidad} - Total: \$${item.cantidad * item.precio}',
                          ),
                        ),
                      );
                    }).toList()
                      ..add(
                        PopupMenuItem(
                          enabled: false,
                          child: Divider(),
                        ),
                      )
                      ..add(
                        PopupMenuItem(
                          enabled: false,
                          child: Text(
                            'Total: \$${carrito.items.fold(0, (previousValue, item) => previousValue + (item.precio * item.cantidad).toInt())}',
                          ),
                        ),
                      )
                      ..add(
                        PopupMenuItem<Map<String, dynamic>>(
                          value: {'action': 'verCarro'},
                          child: Text('Ver Carro'),
                        ),
                      );
                  },
                  icon: Icon(FontAwesomeIcons.cartShopping),
                ),
                if (value > 0)
                  Positioned(
                    right: 00,
                    top: 00,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        value.toString(),
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        ValueListenableBuilder<bool>(
          valueListenable: usuarioConectado,
          builder: (context, value, child) {
            return IconButton(
              icon: Icon(
                value ? FontAwesomeIcons.user : FontAwesomeIcons.userLargeSlash,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
