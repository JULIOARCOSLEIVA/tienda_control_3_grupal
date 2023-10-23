import 'package:control3grupo/carrito_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // los íconos de FontAwesome
import 'pantalla/detalleproducto_pantalla.dart';
//import 'productos_prueba.dart'; // lo usamos para cargar productos de prueba
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'custom_app_bar.dart'; //aca mostramos la barra cosa de reutilizar el codigo en todas las seccioes.
import 'estado_global.dart'; // aca pasamos los estados de login y la cantidad que se ha agregado en el carro
import 'pantalla/busqueda_pantalla.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // cargarProductos();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tienda Onlain',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Tienda Onlain'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? categoriaFiltrada; //variable para filtrar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        usuarioConectado: usuarioConectado,
        cantidadProductosCarrito: cantidadProductosCarrito,
      ),
      body: Column(
        children: [
          // Banner
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.width /
                2, // Para lograr una resolución de 1:2
            child: Image.asset('assets/banner2.jpg', fit: BoxFit.cover),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Center(
              child: Text(
                'Nuestros Productos',
                style: TextStyle(
                  fontSize: 22, // tamaño del título del producto
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ), // Botón de búsqueda
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _mostrarBuscador(context);
            },
          ),
          ElevatedButton(
            child: Text(categoriaFiltrada == null
                ? "Filtrar por categoría"
                : "Quitar filtro"),
            onPressed: () async {
              if (categoriaFiltrada == null) {
                // Mostrar diálogo de selección de categoría y asignar resultado a categoriaFiltrada
                categoriaFiltrada = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          title: Text('Selecciona una categoría'),
                          children: [
                            // Aquí debes listar tus categorías. Por ejemplo:
                            SimpleDialogOption(
                              child: Text('Comida'),
                              onPressed: () {
                                Navigator.of(context).pop('Comida');
                              },
                            ),
                            SimpleDialogOption(
                              child: Text('Bebida'),
                              onPressed: () {
                                Navigator.of(context).pop('Bebida');
                              },
                            ),
                            SimpleDialogOption(
                              child: Text('Hogar'),
                              onPressed: () {
                                Navigator.of(context).pop('Hogar');
                              },
                            ),
                            SimpleDialogOption(
                              child: Text('Pintura'),
                              onPressed: () {
                                Navigator.of(context).pop('Pintura');
                              },
                            ),
                          ],
                        );
                      },
                    ) ??
                    categoriaFiltrada;
              } else {
                categoriaFiltrada = null;
              }
              setState(() {}); // Refrescar el estado para aplicar el filtro
            },
          ),
          // Grilla de productos

          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: obtenerProductos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text("No hay productos disponibles.");
                } else {
                  final productos = snapshot.data!;

                  return GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: productos.length,
                    itemBuilder: (BuildContext context, int index) {
                      ValueNotifier<bool> isTouched =
                          ValueNotifier<bool>(false);
                      return Container(
                          height: 500,
                          child: Card(
                              elevation: 5,
                              shadowColor: Colors.grey.withOpacity(0.5),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(10.0),
                                      height: 100,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              productos[index]['imagenUrl']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      productos[index]['nombre'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '\$${productos[index]['precio'].toString()}',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            10), // Espacio para separar un poco los elementos
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetalleProductoPantalla(
                                                    producto: productos[index],
                                                    agregarAlCarrito:
                                                        agregarAlCarrito),
                                          ),
                                        );
                                      },
                                      child: Text('Ver más'),
                                    ),
                                    ValueListenableBuilder<bool>(
                                      valueListenable: isTouched,
                                      builder: (context, value, child) {
                                        return GestureDetector(
                                          onTap: () {
                                            isTouched.value = !isTouched.value;
                                            agregarAlCarrito(productos[index]);
                                          },
                                          child: Icon(
                                            FontAwesomeIcons.cartShopping,
                                            color: value
                                                ? Colors.blue
                                                : Colors.black,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              )));
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> obtenerProductos() async {
    final CollectionReference productosRef =
        FirebaseFirestore.instance.collection('Producto');

    Query productosQuery = productosRef;
    if (categoriaFiltrada != null) {
      productosQuery =
          productosRef.where('categoria', isEqualTo: categoriaFiltrada);
    }

    final QuerySnapshot productosSnapshot = await productosQuery.get();

    return productosSnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool estaLogeado() {
    return _auth.currentUser != null;
  }

  void agregarAlCarrito(Map<String, dynamic> producto) {
    usuarioConectado.value = estaLogeado(); // Actualiza el estado de conexión

    if (!usuarioConectado.value) {
      // Si el usuario no está conectado, muestra un mensaje y termina la función aquí.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Por favor, inicia sesión para añadir productos al carrito.')));
      return;
    }

    if (producto['stock'] <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('El producto ya no tiene stock disponible.')));
      return;
    }

    final item = carrito.items.firstWhere(
      (element) => element.id == producto['id'],
      orElse: () => CarritoItem(
        id: producto['id'],
        nombre: producto['nombre'],
        precio: producto['precio'],
        stock: producto['stock']?.toDouble() ?? 0,
      ),
    );

    if (!carrito.items.contains(item)) {
      carrito.items.add(item);
    }

    if (producto['stock'] - item.cantidad > 0) {
      item.cantidad += 1;
      cantidadProductosCarrito.value = carrito.items
          .fold(0, (previousValue, item) => previousValue + item.cantidad);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Producto agregado.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No puedes agregar más unidades de este producto.')));
    }
  }

  void _mostrarBuscador(BuildContext context) async {
    String query = "";
    List<Map<String, dynamic>> productos = await obtenerProductos();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Buscar Producto"),
          content: TextField(
            onChanged: (value) {
              query = value;
            },
            onSubmitted: (value) {
              final resultados = productos
                  .where((producto) =>
                      producto['nombre']
                          .toLowerCase()
                          .contains(query.toLowerCase()) ||
                      producto['descripcion']
                          .toLowerCase()
                          .contains(query.toLowerCase()))
                  .toList();

              if (resultados.isNotEmpty) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ResultadosBusquedaPantalla(
                    resultados: resultados,
                    agregarAlCarrito: agregarAlCarrito,
                  ),
                ));
              }
            },
            decoration: InputDecoration(
                labelText: "Buscar...",
                hintText: "Presiona 'Enter' para buscar"),
          ),
        );
      },
    );
  }
}
