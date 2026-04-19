import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/gasto.dart';
import '../viewmodels/gastos_viewmodel.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>(); // ← OBLIGATORIO
  final _nombreCtrl = TextEditingController();
  final _montoCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();
  String? _categoriaSeleccionada;

  static const List<String> _categorias = [
    'Alimentacion',
    'Transporte',
    'Entretenimiento',
    'Salud',
    'Otros',
  ];

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _montoCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  void _guardar() {
    // Solo guarda si el formulario es valido
    if (!_formKey.currentState!.validate()) return;

    final gasto = Gasto(
      nombre: _nombreCtrl.text.trim(),
      monto: double.parse(_montoCtrl.text.trim()),
      categoria: _categoriaSeleccionada!,
      descripcion: _descripcionCtrl.text.trim(),
    );

    context.read<GastosViewModel>().agregarGasto(gasto);
    Navigator.pop(context); // Regresa a Home
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Gasto'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Nombre
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre del gasto',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  if (value.trim().length < 3) {
                    return 'Mínimo 3 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Monto
              TextFormField(
                controller: _montoCtrl,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Monto (S/.)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El monto es obligatorio';
                  }
                  final monto = double.tryParse(value.trim());
                  if (monto == null) {
                    return 'Ingresa un número válido';
                  }
                  if (monto <= 0) {
                    return 'El monto debe ser mayor a 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Categoria
              DropdownButtonFormField<String>(
                value: _categoriaSeleccionada,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: _categorias
                    .map((cat) => DropdownMenuItem(
                  value: cat,
                  child: Text(cat),
                ))
                    .toList(),
                onChanged: (val) =>
                    setState(() => _categoriaSeleccionada = val),
                validator: (value) =>
                value == null ? 'Selecciona una categoría' : null,
              ),
              const SizedBox(height: 16),

              // Descripcion (opcional)
              TextFormField(
                controller: _descripcionCtrl,
                maxLength: 100,
                decoration: const InputDecoration(
                  labelText: 'Descripción (opcional)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != null && value.length > 100) {
                    return 'Máximo 100 caracteres';
                  }
                  return null; // Es opcional
                },
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _guardar,
                  child: const Text('Guardar Gasto',
                      style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}