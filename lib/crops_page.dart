import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../models/crop.dart';

class CropsPage extends StatelessWidget {
  const CropsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Crops & Cycles'), actions: [
        IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {
          final s = context.read<AppState>().exportCropsCsv();
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(title: const Text('Export CSV'), content: SingleChildScrollView(child: SelectableText(s)), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))]));
            }),
      ]),
      body: ListView.builder(
        itemCount: app.crops.length,
        itemBuilder: (context, idx) {
          final c = app.crops[idx];
          return ListTile(
            title: Text('${c.crop} — ${c.fieldId}'),
            subtitle: Text('Planted: ${c.plantingDate}'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final changed = await Navigator.push<CropModel?>(
                      context,
                      MaterialPageRoute(builder: (_) => CropEditPage(crop: c)),
                    );
                    if (changed != null) await app.updateCrop(changed);
                  }),
              IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await app.deleteCrop(c.id);
                  })
            ]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          final newCrop = CropModel(id: id, fieldId: '', crop: 'New crop', plantingDate: DateTime.now().toIso8601String());
          final created = await Navigator.push<CropModel?>(context, MaterialPageRoute(builder: (_) => CropEditPage(crop: newCrop)));
          if (created != null) await app.addCrop(created);
        },
      ),
    );
  }
}

class CropEditPage extends StatefulWidget {
  final CropModel crop;
  const CropEditPage({required this.crop, super.key});

  @override
  State<CropEditPage> createState() => _CropEditPageState();
}

class _CropEditPageState extends State<CropEditPage> {
  late final TextEditingController _fieldId;
  late final TextEditingController _crop;
  late final TextEditingController _planting;

  @override
  void initState() {
    super.initState();
    _fieldId = TextEditingController(text: widget.crop.fieldId);
    _crop = TextEditingController(text: widget.crop.crop);
    _planting = TextEditingController(text: widget.crop.plantingDate);
  }

  @override
  void dispose() {
    _fieldId.dispose();
    _crop.dispose();
    _planting.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Crop Cycle')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          TextField(controller: _fieldId, decoration: const InputDecoration(labelText: 'Field ID')),
          TextField(controller: _crop, decoration: const InputDecoration(labelText: 'Crop')),
          TextField(controller: _planting, decoration: const InputDecoration(labelText: 'Planting Date (ISO)')),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () {
            final updated = CropModel(
              id: widget.crop.id,
              fieldId: _fieldId.text,
              crop: _crop.text,
              plantingDate: _planting.text,
            );
            Navigator.pop(context, updated);
          }, child: const Text('Save'))
        ]),
      ),
    );
  }
}
