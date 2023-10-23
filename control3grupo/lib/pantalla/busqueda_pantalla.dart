import 'package:flutter/material.dart';
import '../custom_app_bar.dart';
import '../estado_global.dart';
import 'detalleproducto_pantalla.dart';

class ResultadosBusquedaPantalla extends StatelessWidget {
  final List<Map<String, dynamic>> resultados;
  final Function agregarAlCarrito;

  ResultadosBusquedaPantalla(
      {required this.resultados, required this.agregarAlCarrito});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Resultados de búsqueda',
        usuarioConectado: usuarioConectado,
        cantidadProductosCarrito: cantidadProductosCarrito,
      ),
      body: ListView.builder(
        itemCount: resultados.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalleProductoPantalla(
                    producto: resultados[index],
                    agregarAlCarrito: agregarAlCarrito,
                  ),
                ),
              );
            },
            child: ListTile(
              title: Text(resultados[index]['nombre']),
              subtitle: Text(resultados[index]['descripcion']),
            ),
          );
        },
      ),
    );
  }
}
