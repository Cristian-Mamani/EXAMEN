import 'package:flutter/material.dart';
import '../models/gasto.dart';

// StatelessWidget porque no necesita estado propio
class DetalleScreen extends StatelessWidget {
  final Gasto gasto; // ← Recibe via argumentos del Navigator

  const DetalleScreen({super.key, required this.gasto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Gasto'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _fila('Nombre', gasto.nombre),
                const Divider(),
                _fila('Categoría', gasto.categoria),
                const Divider(),
                _fila('Monto', 'S/. ${gasto.monto.toStringAsFixed(2)}'),
                const Divider(),
                _fila(
                  'Descripción',
                  gasto.descripcion.isNotEmpty
                      ? gasto.descripcion
                      : 'Sin descripción', // ← Caso borde
                ),
                const Divider(),
                _fila(
                  'Fecha de registro',
                  '${gasto.fechaRegistro.day}/${gasto.fechaRegistro.month}/${gasto.fechaRegistro.year} '
                      '${gasto.fechaRegistro.hour}:${gasto.fechaRegistro.minute.toString().padLeft(2, '0')}',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fila(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              etiqueta,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ),
          Expanded(child: Text(valor)),
        ],
      ),
    );
  }
}