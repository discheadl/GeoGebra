import 'package:flutter/material.dart';

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({super.key});

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  bool _auxiliaryObjects = false;
  bool _showAxes = true;
  bool _showGrid = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF6762A6);

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: activeColor,
            unselectedLabelColor: Colors.black54,
            indicatorColor: activeColor,
            tabs: const [
              Tab(text: "General"),
              Tab(text: "Algebra"),
              Tab(text: "Graphics"),
            ],
          ),
          
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGeneralTab(),
                _buildAlgebraTab(),
                _buildGraphicsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _SettingsItem(title: "Language", subtitle: "English (US)"),
        _SettingsItem(title: "Rounding", subtitle: "13 Decimal Places"),
        _SettingsItem(title: "Coordinates", subtitle: "A = (x, y)"),
        _SettingsItem(title: "Angle Unit", subtitle: "Degree"),
        _SettingsItem(title: "Font Size", subtitle: "16 pt"),
      ],
    );
  }

  Widget _buildAlgebraTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _SettingsItem(title: "Display", subtitle: "Definition & Value"),
        SwitchListTile(
          title: const Text("Auxiliary Objects"),
          value: _auxiliaryObjects,
          activeThumbColor: const Color(0xFF6762A6),
          onChanged: (val) => setState(() => _auxiliaryObjects = val),
        ),
      ],
    );
  }

  Widget _buildGraphicsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(child: _buildGraphicButton(Icons.home, "Standard View")),
            const SizedBox(width: 16),
            Expanded(child: _buildGraphicButton(Icons.zoom_out_map, "Zoom to fit")),
          ],
        ),
        const SizedBox(height: 16),
        
        SwitchListTile(
          title: const Text("Show Axes"),
          value: _showAxes,
          activeThumbColor: const Color(0xFF6762A6),
          onChanged: (val) => setState(() => _showAxes = val),
        ),
        SwitchListTile(
          title: const Text("Show Grid"),
          value: _showGrid,
          activeThumbColor: const Color(0xFF6762A6),
          onChanged: (val) => setState(() => _showGrid = val),
        ),
        
        const ListTile(
          title: Text("Grid Type"),
          trailing: Icon(Icons.grid_3x3, color: Colors.black54),
        ),
         const _SettingsItem(title: "Point Capturing", subtitle: "Automatic"),
         const _SettingsItem(title: "Distance or Length", subtitle: ""),
         const _SettingsItem(title: "Labels", subtitle: ""),
      ],
    );
  }

  Widget _buildGraphicButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SettingsItem({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontSize: 16)),
      subtitle: subtitle.isNotEmpty 
          ? Text(subtitle, style: TextStyle(color: Colors.grey[600])) 
          : null,
    );
  }
}