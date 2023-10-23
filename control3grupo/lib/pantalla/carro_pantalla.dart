import 'package:flutter/material.dart';
import '../carrito_model.dart'; // Asegúrate de importar tu modelo de Carrito aquí
import '../custom_app_bar.dart'; // Asegúrate de importar la ruta correcta
import '../estado_global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarroPantalla extends StatefulWidget {
  @override
  _CarroPantallaState createState() => _CarroPantallaState();
}

class _CarroPantallaState extends State<CarroPantalla> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Carro de Compra',
        usuarioConectado: usuarioConectado,
        cantidadProductosCarrito: cantidadProductosCarrito,
      ),
      body: _construirCuerpo(),
    );
  }

  Widget _construirCuerpo() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: carrito.items.length,
            itemBuilder: (context, index) {
              CarritoItem item = carrito.items[index];
              return ListTile(
                title: Text(item.nombre),
                subtitle:
                    Text('Cantidad: ${item.cantidad} - Precio: ${item.precio}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (item.cantidad > 1) {
                          setState(() {
                            item.cantidad--;
                          });
                        }
                      },
                    ),
                    Text('${item.cantidad}'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        if (item.cantidad < item.stock) {
                          // Asegúrate de tener un campo `stock` en tu modelo CarritoItem
                          setState(() {
                            item.cantidad++;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'No puedes agregar más unidades de este producto. Stock alcanzado.')));
                        }
                      },
                    ),
                    Text('Total: ${item.cantidad * item.precio}'),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          carrito.items.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  'Total: ${carrito.items.fold(0, (previousValue, item) => previousValue + (item.precio * item.cantidad).toInt())}'),
              ElevatedButton(
                onPressed: () {
                  actualizarStockYCompletarCompra();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          '¡Gracias por tu compra! Tu pedido ha sido ejecutado con éxito.')));
                },
                child: Text('Pagar'),
              ),
            ],
          ),
        )
      ],
    );
  }

  void actualizarStockYCompletarCompra() async {
    final firestore = FirebaseFirestore.instance; // referencia a Firestore
    final productosRef = firestore
        .collection('products'); // referencia a la colección de productos

    WriteBatch batch = firestore.batch();

    try {
      for (CarritoItem item in carrito.items) {
        DocumentReference docRef = productosRef.doc(item.id);
        batch.update(docRef, {'stock': FieldValue.increment(-item.cantidad)});
      }

      await batch.commit();

      setState(() {
        carrito.items.clear();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Hubo un error al procesar la compra: $error'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
