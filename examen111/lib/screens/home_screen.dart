import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/gastos_viewmodel.dart';
import '../models/gasto.dart';
import 'registro_screen.dart';
import 'detalle_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<String> categorias = [
    'Alimentacion',
    'Transporte',
    'Entretenimiento',
    'Salud',
    'Otros',
  ];

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GastosViewModel>();
    final gastos = vm.gastos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Control de Gastos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // --- Totales ---
          Container(
            width: double.infinity,
            color: Colors.indigo.shade50,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total general: S/. ${vm.totalGeneral.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Por categoría:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                ...categorias.map((cat) {
                  final total = vm.totalPorCategoria(cat);
                  return total > 0
                      ? Text('  $cat: S/. ${total.toStringAsFixed(2)}')
                      : const SizedBox.shrink();
                }),
              ],
            ),
          ),

          // --- Lista o estado vacío ---
          Expanded(
            child: gastos.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long,
                      size: 72, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No hay gastos registrados.\n¡Agrega tu primer gasto!',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: gastos.length,
              itemBuilder: (context, index) {
                final gasto = gastos[index];
                return ListTile(
                  leading: const Icon(Icons.attach_money),
                  title: Text(gasto.nombre),
                  subtitle: Text(gasto.categoria),
                  trailing: Text(
                    'S/. ${gasto.monto.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DetalleScreen(gasto: gasto),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegistroScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}