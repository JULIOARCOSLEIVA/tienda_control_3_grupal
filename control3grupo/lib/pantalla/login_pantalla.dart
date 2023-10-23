import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'registro_pantalla.dart';
import '../custom_app_bar.dart'; // Asegúrate de importar la ruta correcta
import '../main.dart'; // Asegúrate de importar la ruta correcta
import '../estado_global.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _estaLogeado = false;

  @override
  void initState() {
    super.initState();
    _verificarEstadoLogin();
  }

  _verificarEstadoLogin() {
    setState(() {
      _estaLogeado = (_auth.currentUser != null);
    });
  }

  Future<void> _login() async {
    try {
      await _auth
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Inicio de sesión exitoso!')));
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(title: 'Tienda Onlain')));
        // Si tienes una pantalla principal o algún lugar al que quieras navegar después de iniciar sesión, pon aquí el código de navegación
        // Por ejemplo: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
      });
    } catch (e) {
      print(e);

      String errorMessage;
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage =
                'No se encontró ningún usuario con ese correo electrónico.';
            break;
          case 'wrong-password':
            errorMessage = 'Contraseña incorrecta.';
            break;
          case 'invalid-email':
            errorMessage = 'El formato del correo electrónico no es válido.';
            break;
          case 'user-disabled':
            errorMessage = 'Este usuario ha sido deshabilitado.';
            break;
          default:
            errorMessage =
                'Ocurrió un error al iniciar sesión. Inténtalo de nuevo más tarde.';
        }
      } else {
        errorMessage =
            'Ocurrió un error desconocido. Inténtalo de nuevo más tarde.';
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  Future<void> _cerrarSesion() async {
    await _auth.signOut();
    _verificarEstadoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Inicia sesión',
        usuarioConectado: usuarioConectado,
        cantidadProductosCarrito: cantidadProductosCarrito,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _estaLogeado
            ? _construirUIUsuarioConectado()
            : _construirUIUsuarioNoConectado(),
      ),
    );
  }

  Widget _construirUIUsuarioConectado() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Ya estás conectado!'),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _cerrarSesion,
          child: Text('Cerrar sesión'),
        ),
      ],
    );
  }

  Widget _construirUIUsuarioNoConectado() {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(labelText: 'Correo electrónico'),
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 10),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(labelText: 'Contraseña'),
          obscureText: true,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _login,
          child: Text('Iniciar sesión'),
        ),
        SizedBox(height: 20),
        Text('¿No tiene cuenta?'),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegistroScreen()),
            );
          },
          child: Text('Regístrate aquí'),
        ),
      ],
    );
  }
}
