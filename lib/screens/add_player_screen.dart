import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

import '../../entities/player.dart';
import '../providers/player_provider.dart';

class AddPlayerScreen extends ConsumerStatefulWidget {
  final Player? player;

  const AddPlayerScreen({super.key, this.player});

  @override
  ConsumerState<AddPlayerScreen> createState() => _AddPlayerScreenState();
}

class _AddPlayerScreenState extends ConsumerState<AddPlayerScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageController;
  late final TextEditingController _teamController;
  late final TextEditingController _positionController;

  @override
  void initState() {
    super.initState();

    _nameController =
        TextEditingController(text: widget.player?.name ?? '');

    _descriptionController =
        TextEditingController(text: widget.player?.description ?? '');

    _imageController =
        TextEditingController(text: widget.player?.image ?? '');

    _teamController =
        TextEditingController(text: widget.player?.team ?? '');

    _positionController =
        TextEditingController(text: widget.player?.position ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    _teamController.dispose();
    _positionController.dispose();

    super.dispose();
  }

  void _savePlayer() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final isEditing = widget.player != null;

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final image = _imageController.text.trim();
    final team = _teamController.text.trim();
    final position = _positionController.text.trim();

    final now = Timestamp.now();

    if (isEditing) {
      // EDITAR
      // Conservamos el createdAt original
      // y actualizamos updatedAt.

      final updatedPlayer = Player(
        id: widget.player!.id,
        name: name,
        description: description,
        image: image,
        team: team,
        position: position,
        createdAt: widget.player!.createdAt,
        updatedAt: now,
        status: widget.player!.status,
      );

      ref
          .read(playerProvider.notifier)
          .updatePlayer(updatedPlayer);
    } else {
      // AGREGAR
      // Para un jugador nuevo createdAt y updatedAt
      // comienzan con la fecha actual.

      final newPlayer = Player(
        id: name,
        name: name,
        description: description,
        image: image,
        team: team,
        position: position,
        createdAt: now,
        updatedAt: now,
        status: 'enabled',
      );

      ref.read(playerProvider.notifier).addPlayer(newPlayer);
    }

    context.go('/players');
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.player != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar Jugador' : 'Agregar Jugador',
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Form(
          key: _formKey,

          child: ListView(
            children: [

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }

                  return null;
                },
              ),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripcion',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa una descripcion';
                  }

                  return null;
                },
              ),

              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'URL de Imagen',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa una URL de imagen';
                  }

                  return null;
                },
              ),

              TextFormField(
                controller: _teamController,
                decoration: const InputDecoration(
                  labelText: 'Equipo',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa un equipo';
                  }

                  return null;
                },
              ),

              TextFormField(
                controller: _positionController,
                decoration: const InputDecoration(
                  labelText: 'Posicion',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa una posicion';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _savePlayer,
                child: Text(
                  isEditing
                      ? 'Guardar Cambios'
                      : 'Guardar Jugador',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}