import 'package:cloud_firestore/cloud_firestore.dart';

//esta ya no se esta usando, solo fue para crear los productos de prueba al principio
List<Map<String, dynamic>> productosFicticios = [
  {
    'id': 'es1',
    'nombre': 'Esmalte al agua',
    'descripcion': 'Esmalte a base de agua de alta calidad y durabilidad',
    'categoria': 'Pintura',
    'precio': 25000.0,
    'stock': 12,
    'imagenUrl': 'assets/esmalte.jpg'
  },
  {
    'id': 'es2',
    'nombre': 'Rodillo',
    'descripcion': 'Rodillo ideal para pintar grandes superficies',
    'categoria': 'Pintura',
    'precio': 2590.0,
    'stock': 3,
    'imagenUrl': 'assets/rodillo.jpg'
  },
  {
    'id': 'es3',
    'nombre': 'Latex',
    'descripcion': 'Latex de secado rápido para interiores y exteriores',
    'categoria': 'Pintura',
    'precio': 8900.0,
    'stock': 10,
    'imagenUrl': 'assets/latex.jpg'
  },
  {
    'id': 'es4',
    'nombre': 'Sopa en lata',
    'descripcion': 'Deliciosa sopa enlatada, lista para calentar y servir',
    'categoria': 'Comida',
    'precio': 990.0,
    'stock': 0,
    'imagenUrl': 'assets/sopa.jpg'
  },
  {
    'id': 'es5',
    'nombre': 'Papas Fritas',
    'descripcion': 'Papas fritas crujientes y deliciosas',
    'categoria': 'Comida',
    'precio': 350.0,
    'stock': 80,
    'imagenUrl': 'assets/papas.jpg'
  },
  {
    'id': 'es6',
    'nombre': 'RocaCola',
    'descripcion': 'Refresco burbujeante con sabor a cola',
    'categoria': 'Bebida',
    'precio': 680.0,
    'stock': 10,
    'imagenUrl': 'assets/rocacola.jpg'
  },
  {
    'id': 'es7',
    'nombre': 'Silla',
    'descripcion': 'Silla ergonómica para el hogar o la oficina',
    'categoria': 'Hogar',
    'precio': 15000.0,
    'stock': 0,
    'imagenUrl': 'assets/silla.jpg'
  },
  {
    'id': 'es8',
    'nombre': 'Mesa Playa',
    'descripcion': 'Mesa plegable, ideal para picnics o días de playa',
    'categoria': 'Hogar',
    'precio': 25600.0,
    'stock': 7,
    'imagenUrl': 'assets/mesa.jpg'
  },
  {
    'id': 'es9',
    'nombre': 'Sillon',
    'descripcion': 'Sillón reclinable, perfecto para relajarse',
    'categoria': 'Hogar',
    'precio': 99000.0,
    'stock': 8,
    'imagenUrl': 'assets/sillon.jpg'
  },
  {
    'id': 'es10',
    'nombre': 'Jugo de naranja',
    'descripcion': 'Jugo natural de naranja, sin conservantes',
    'categoria': 'Bebida',
    'precio': 1600.0,
    'stock': 5,
    'imagenUrl': 'assets/jugo.jpg'
  },
];

void cargarProductos() async {
  final CollectionReference productos =
      FirebaseFirestore.instance.collection('Producto');

  // Borrar todos los documentos existentes
  final QuerySnapshot productosActuales = await productos.get();
  for (QueryDocumentSnapshot productoActual in productosActuales.docs) {
    await productos.doc(productoActual.id).delete();
  }

  // Añadir productos ficticios
  for (Map<String, dynamic> producto in productosFicticios) {
    await productos.add(producto);
  }
}
