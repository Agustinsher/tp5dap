import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Guarda el usuario actual (vale null si no inició sesión)
final currentUserProvider = StateProvider< User? >((ref) {
  return FirebaseAuth.instance.currentUser;
});

// Registrar usuario nuevo
Future< void > registerUser({
  required WidgetRef ref,
  required String name,
  required String email,
  required String password,
}) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Guarda el nombre en el perfil del usuario
    await credential.user?.updateDisplayName(name);
    await credential.user?.reload();

    ref.read(currentUserProvider.notifier).state =
        FirebaseAuth.instance.currentUser;
  } on FirebaseAuthException catch (e) {
    throw _mensajeDeError(e);
  }
}

// Iniciar sesión
Future< void > loginUser({
  required WidgetRef ref,
  required String email,
  required String password,
}) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    ref.read(currentUserProvider.notifier).state = credential.user;
  } on FirebaseAuthException catch (e) {
    throw _mensajeDeError(e);
  }
}

// Cerrar sesión
Future< void > logoutUser(WidgetRef ref) async {
  await FirebaseAuth.instance.signOut();
  ref.read(currentUserProvider.notifier).state = null;
}

String _mensajeDeError(FirebaseAuthException e) {
  switch (e.code) {
    case 'email-already-in-use':
      return 'Ya existe una cuenta con ese email.';
    case 'invalid-email':
      return 'El formato del email no es válido.';
    case 'weak-password':
    case 'password-does-not-meet-requirements':
      return 'La contraseña no cumple los requisitos (probá con mayúscula, minúscula y números).';
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      return 'Email o contraseña incorrectos.';
    default:
      return 'Error (${e.code}): ${e.message}';
  }
}