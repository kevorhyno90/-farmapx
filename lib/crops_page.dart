import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../models/crop_model.dart';
import 'widgets/section_scaffold.dart';

class CropsPage extends StatelessWidget {
  const CropsPage({super.key});

  Widget _overview(BuildContext context, AppState app) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Crops Overview', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Total cycles: ${app.crops.length}'),
        ]),
      );

  Widget _list(BuildContext context, AppState app) => ListView.builder(
        itemCount: app.crops.length,
        itemBuilder: (context, idx) {
          final c = app.crops[idx];
          return ListTile(
            title: Text('${c.cropName} — ${c.fieldId}'),
            subtitle: Text('Planted: ${c.plantingDate.toString().split(' ')[0]}'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final changed = await Navigator.push<CropModel?>(context, MaterialPageRoute(builder: (_) => CropEditPage(crop: c)));
                    if (changed != null) await app.updateCrop(changed);
                  }),
              IconButton(icon: const Icon(Icons.delete), onPressed: () => app.deleteCrop(c.id))
            ]),
          );
        },
      );

  Widget _csv(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final s = context.read<AppState>().exportCropsCsv();
          await showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Export CSV'), content: SingleChildScrollView(child: SelectableText(s)), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))]));
        },
        child: const Text('Export CSV'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return SectionScaffold(
      title: 'Crops',
      subsections: const ['Overview', 'List', 'CSV'],
      builder: (ctx, sub) {
        if (sub == 'Overview') return _overview(ctx, app);
        if (sub == 'List') return _list(ctx, app);
        return _csv(ctx);
      },
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
    _crop = TextEditingController(text: widget.crop.cropName);
    _planting = TextEditingController(text: widget.crop.plantingDate.toString().split(' ')[0]);
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
              cropName: _crop.text,
              plantingDate: DateTime.tryParse(_planting.text) ?? DateTime.now(),
            );
            Navigator.pop(context, updated);
          }, child: const Text('Save'))
        ]),
      ),
    );
  }
}
