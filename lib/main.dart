import 'package:flutter/material.dart';
import 'graph_widget.dart';

void main() => runApp(const MaterialApp(home: GeoGebraClone()));

class GeoGebraClone extends StatefulWidget {
  const GeoGebraClone({super.key});

  @override
  State<GeoGebraClone> createState() => _GeoGebraCloneState();
}

class _GeoGebraCloneState extends State<GeoGebraClone> {
  final List<String> _equations = [];
  final TextEditingController _controller = TextEditingController();
  int _selectedIndex = 0;

  double _scale = 40.0;
  Offset _offset = Offset.zero;

  double _baseScale = 1.0;
  Offset _baseOffset = Offset.zero;
  Offset _baseFocalPoint = Offset.zero;

  void _addEquation(String value) {
    setState(() {
      _equations.add(value);
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: Text(
                'GeoGebra 👻', 
                style: TextStyle(
                  color: Color.fromARGB(255, 54, 53, 63), 
                  fontSize: 20, 
                  fontWeight: FontWeight.bold
                )
              ),
            ),
            ListTile(
              leading: const Icon(Icons.close), 
              title: const Text('Clear All'), 
              onTap: () {
                setState(() {
                  _equations.clear();
                  _offset = Offset.zero;
                  _scale = 40.0;
                });
                Navigator.pop(context);
              }
            ),
            ListTile(leading: const Icon(Icons.search), title: const Text('Open'), onTap: () {}),
            ListTile(leading: const Icon(Icons.share), title: const Text('Share'), onTap: () {}),
            ListTile(leading: const Icon(Icons.image), title: const Text('Export Image'), onTap: () {}),
            ListTile(leading: const Icon(Icons.timer), title: const Text('Exam Mode'), onTap: () {}),
            const Divider(),
            ListTile(leading: const Icon(Icons.settings), title: const Text('Settings'), onTap: () {}),
            ListTile(leading: const Icon(Icons.help), title: const Text('Help & Feedback'), onTap: () {}),
          ],
        ),
      ),
      
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),

      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onScaleStart: (details) {
                _baseScale = _scale;
                _baseOffset = _offset;
                _baseFocalPoint = details.localFocalPoint;
              },
              onScaleUpdate: (details) {
                setState(() {
                  _scale = (_baseScale * details.scale).clamp(5.0, 500.0);
                  final dx = details.localFocalPoint.dx - _baseFocalPoint.dx;
                  final dy = details.localFocalPoint.dy - _baseFocalPoint.dy;
                  _offset = _baseOffset + Offset(dx, dy);
                });
              },
              child: Container(
                color: Colors.white,
                child: GraphWidget(
                  equations: _equations,
                  scale: _scale,
                  offset: _offset,
                ), 
              ),
            ),
          ),

          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   if (_equations.isNotEmpty) 
                     Container(
                       constraints: const BoxConstraints(maxHeight: 150),
                       child: ListView(
                         shrinkWrap: true,
                         children: _equations.map((e) => ListTile(
                           dense: true,
                           leading: const CircleAvatar(backgroundColor: Colors.purple, radius: 5),
                           title: Text("f(x) = $e"),
                           trailing: IconButton(
                             icon: const Icon(Icons.close, size: 18), 
                             onPressed: (){ setState(() => _equations.remove(e)); }
                           ),
                         )).toList(),
                       ),
                     ),
                   
                   Row(
                    children: [
                      const Icon(Icons.add, color: Colors.purple),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Input... (ej: x^2, sin(x))',
                            border: InputBorder.none,
                          ),
                          onSubmitted: _addEquation,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF6762A6),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Algebra'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Tools'),
          BottomNavigationBarItem(icon: Icon(Icons.table_chart), label: 'Table'),
        ],
      ),
    );
  }
}