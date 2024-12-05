import 'package:cloud_firestore/cloud_firestore.dart';

class Game {
  final String id;
  final String nombre;
  final String consola;
  final String tipo;

  Game({required this.id, required this.nombre, required this.consola, required this.tipo});

  Map<String, dynamic> toMap(){
    return {
      'Nombre': nombre,
      'Consola': consola,
      'Tipo': tipo, 
    };
  }

  // Crear un Game desde un DocumentSnapshot
  factory Game.fromDocumentSnapShot(DocumentSnapshot doc){
    return Game(
      id: doc.id, 
      nombre: doc['Nombre'], 
      consola: doc['Consola'], 
      tipo: doc['Tipo']
    );
  }
}