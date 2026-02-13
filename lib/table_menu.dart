import 'package:flutter/material.dart';

class TableMenu extends StatelessWidget {
  final ScrollController? controller;

  const TableMenu({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: ListView(
        controller: controller, // ¡Vital para que funcione el arrastre!
        padding: EdgeInsets.zero,
        children: [
          // 1. Manija gris (Drag Handle)
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40, 
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300], 
                borderRadius: BorderRadius.circular(2)
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 2. Encabezado de la Tabla (Gris claro)
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[100], // Fondo gris suave como en la foto
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!), // Línea divisoria
              ),
            ),
            child: Row(
              children: [
                // Columna X (Izquierda)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "x", 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.more_vert, size: 18, color: Colors.black54),
                    ],
                  ),
                ),
                // Divisor Vertical
                Container(width: 1, color: Colors.grey[300]),
                
                // Columna Y / f(x) (Derecha - Vacía por ahora)
                const Expanded(child: SizedBox()), 
              ],
            ),
          ),

          // 3. Filas Vacías (Generamos 20 para que se vea lleno)
          ...List.generate(20, (index) => _buildEmptyRow(index)),
        ],
      ),
    );
  }

  // Widget auxiliar para cada fila vacía
  Widget _buildEmptyRow(int index) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!), // Líneas horizontales sutiles
        ),
      ),
      child: Row(
        children: [
          Expanded(child: Container()), // Celda izquierda vacía
          Container(width: 1, color: Colors.grey[200]), // Divisor vertical sutil
          Expanded(child: Container()), // Celda derecha vacía
        ],
      ),
    );
  }
}