import 'package:flutter/material.dart';

class ToolsMenu extends StatelessWidget {
  // 1. Agregamos esta variable para controlar el deslizamiento
  final ScrollController? controller; 

  const ToolsMenu({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      // 2. Le damos estilo de "hoja" (bordes redondos arriba y sombra)
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: ListView(
        // 3. Conectamos el controlador aquí. ¡ESTO ES LA CLAVE!
        controller: controller, 
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          // Una pequeña barrita gris para indicar que se puede deslizar
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
            ),
          ),
          
          _buildSection('Herramientas básicas', [
            _ToolItem(Icons.near_me_outlined, 'Mueve', Colors.indigo),
            _ToolItem(Icons.fiber_manual_record, 'Punto', Colors.blue),
            _ToolItem(Icons.linear_scale, 'Deslizador', Colors.grey[700]!),
            _ToolItem(Icons.close, 'Intersección', Colors.grey[700]!), // Corregí el color a gris/negro
            _ToolItem(Icons.timeline, 'Extremos', Colors.grey[700]!),
            _ToolItem(Icons.waves, 'Raíces', Colors.grey[700]!),
            _ToolItem(Icons.bubble_chart, 'Ajuste lineal', Colors.grey[700]!),
          ]),
          const SizedBox(height: 30),
          _buildSection('Edición', [
            _ToolItem(Icons.select_all, 'Seleccionar', Colors.black54),
            _ToolItem(Icons.open_with, 'Desplaza Vista', Colors.black54),
            _ToolItem(Icons.delete_outline, 'Borrar', Colors.black),
            _ToolItem(Icons.visibility_off_outlined, 'Mostrar/\nocultar', Colors.black54),
            _ToolItem(Icons.label_outline, 'Mostrar/\nocultar etiqueta', Colors.black54),
          ]),
        ],
      ),
    );
  }

  // ... (El resto de tu código _buildSection y _ToolItem sigue igual)
  Widget _buildSection(String title, List<_ToolItem> tools) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400, 
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            // Dividimos por 4 para tener 4 columnas exactas
            final double itemWidth = (constraints.maxWidth) / 4;
            return Wrap(
              runSpacing: 20,
              children: tools
                  .map((tool) => _buildToolButton(tool, itemWidth))
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildToolButton(_ToolItem tool, double width) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(tool.icon, color: tool.color, size: 32),
          const SizedBox(height: 8),
          Text(
            tool.label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.1),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

class _ToolItem {
  final IconData icon;
  final String label;
  final Color color;
  _ToolItem(this.icon, this.label, this.color);
}