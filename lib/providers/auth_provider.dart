import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../entities/user.dart';

// Lista de usuarios registrados
final usersListProvider = StateProvider<List<User>>((ref) => []);

// Usuario que actualmente inició sesión
final currentUserProvider = StateProvider<User?>((ref) => null);