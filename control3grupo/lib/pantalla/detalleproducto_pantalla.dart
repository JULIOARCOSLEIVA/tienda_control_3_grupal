import 'package:flutter/material.dart';
import 'package:control3grupo/custom_app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../estado_global.dart';

class DetalleProductoPantalla extends StatefulWidget {
  final Map<String, dynamic> producto;
  final Function agregarAlCarrito;

  DetalleProductoPantalla(
      {required this.producto, required this.agregarAlCarrito});

  @override
  _DetalleProductoPantallaState createState() =>
      _DetalleProductoPantallaState();
}

class _DetalleProductoPantallaState extends State<DetalleProductoPantalla> {
  int cantidadSeleccionada = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Detalle Producto',
        usuarioConectado: usuarioConectado,
        cantidadProductosCarrito: cantidadProductosCarrito,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(widget.producto[
                'imagenUrl']), // Asegúrate de que esta ruta esté bien configurada
            SizedBox(height: 20),
            Text(
              widget.producto['nombre'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Categoría: ${widget.producto['categoria']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              widget.producto['descripcion'],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Cantidad: ',
                  style: TextStyle(fontSize: 18),
                ),
                DropdownButton<int>(
                  value: cantidadSeleccionada,
                  onChanged: (int? newValue) {
                    setState(() {
                      cantidadSeleccionada = newValue!;
                    });
                  },
                  items: List.generate(
                          widget.producto['stock'], (index) => index + 1)
                      .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                widget.agregarAlCarrito(widget.producto);
              },
              icon: Icon(FontAwesomeIcons.cartPlus),
              label: Text('Agregar al carrito'),
            ),
          ],
        ),
      ),
    );
  }
}
