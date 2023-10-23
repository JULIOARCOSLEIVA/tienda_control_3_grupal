import 'package:flutter/material.dart';
import 'carrito_model.dart';

ValueNotifier<bool> usuarioConectado = ValueNotifier<bool>(false);
Carrito carrito = Carrito();
ValueNotifier<int> cantidadProductosCarrito = ValueNotifier<int>(0);
