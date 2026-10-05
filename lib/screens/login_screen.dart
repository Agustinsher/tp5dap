import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../entities/user.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Complete todos los campos"),
        ),
      );

      return;
    }

    // Obtiene los usuarios guardados en Riverpod
    final users = ref.read(usersListProvider);

    User? matchedUser;

    // Busca un usuario cuyo email y contraseña coincidan
    for (var u in users) {
      if (u.email == email && u.password == password) {
        matchedUser = u;
        break;
      }
    }

    if (matchedUser != null) {
      // Guarda el usuario que inició sesión
      ref.read(currentUserProvider.notifier).state = matchedUser;

      // Va a la pantalla de jugadores
      context.go('/players');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Credenciales incorrectas o usuario no registrado",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iniciar Sesión"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            TextField(
              controller: emailController,

              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: true,

              decoration: const InputDecoration(
                labelText: "Contraseña",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _login,
              child: const Text("Ingresar"),
            ),

            TextButton(
              onPressed: () => context.go('/register'),

              child: const Text(
                "¿No tienes cuenta? Regístrate aquí",
              ),
            ),
          ],
        ),
      ),
    );
  }
}