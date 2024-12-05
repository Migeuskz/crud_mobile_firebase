import 'package:flutter/material.dart';
import 'package:games/fire_store_service.dart';
import 'package:games/game.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  final FireStoreService _fireStoreService = FireStoreService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _consoleController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  void _agregarEquipo(){
    _fireStoreService.insertData('games', {
      'Nombre': _nameController.text,
      'Consola': _consoleController.text,
      'Tipo': _typeController.text
    });
    _nameController.clear();
    _consoleController.clear();
    _typeController.clear();
  }

  void _actualizarJuego(String docId){
    _fireStoreService.updateData('games', docId, {
      'Nombre': _nameController.text,
      'Consola': _consoleController.text,
      'Tipo': _typeController.text
    });
    _nameController.clear();
    _consoleController.clear();
    _typeController.clear();
  }

  void  _eliminarJuego(String docId){
    _fireStoreService.deleteData('games', docId);
  }

  void _mostrarDialogoEditar(Game game){
    _nameController.text = game.nombre;
    _consoleController.text = game.consola;
    _typeController.text = game.tipo;
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(title: const Text('Editar equipo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          TextField(
            controller: _consoleController,
            decoration: const InputDecoration(labelText: 'Consola'),
          ),
          TextField(
            controller: _typeController,
            decoration: const InputDecoration(labelText: 'Tipo'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => _actualizarJuego(game.id), 
          child: const Text('Guardar')
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: const Text('Cancelar')
          ),
      ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Catalogo de Videojuegos'),
        ),
        body: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Equipo'),
            ),
            TextField(
              controller: _consoleController,
              decoration: const InputDecoration(labelText: 'Consola'),
            ),
            TextField(
              controller: _typeController,
              decoration: const InputDecoration(labelText: 'Tipo'),
            ),
            ElevatedButton(
              onPressed: _agregarEquipo,
              child: const Text('Agregar Juego'),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder(
                stream: _fireStoreService.getData('games'),
                builder: (context, AsyncSnapshot<List<Game>> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return ListView(
                    children: snapshot.data!.map((Game game) {
                      return ListTile(
                        title: Text(game.nombre),
                        subtitle: Text('Consola: ${game.consola}, Tipo: ${game.tipo} '),
                        onTap: () {
                          _nameController.text = game.nombre;
                          _consoleController.text = game.consola;
                          _typeController.text = game.tipo;
                          _mostrarDialogoEditar(game);
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _eliminarJuego(game.id);
                          },
                        ),
                      );
                    }).toList()
                  );
                },
              ),
            ),
          ],
        ));
  }
}


