import 'package:flutter/material.dart';

typedef SectionBuilder = Widget Function(BuildContext context, String subsection);

class SectionScaffold extends StatefulWidget {
  final String title;
  final List<String> subsections;
  final SectionBuilder builder;

  const SectionScaffold({required this.title, required this.subsections, required this.builder, super.key});

  @override
  State<SectionScaffold> createState() => _SectionScaffoldState();
}

class _SectionScaffoldState extends State<SectionScaffold> {
  late String _current;

  @override
  void initState() {
    super.initState();
    _current = widget.subsections.isNotEmpty ? widget.subsections.first : 'Overview';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _current,
                dropdownColor: Theme.of(context).primaryColor,
                items: widget.subsections
                    .map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(color: Colors.white))))
                    .toList(),
                onChanged: (v) => setState(() {
                  if (v != null) _current = v;
                }),
              ),
            ),
          )
        ],
      ),
      body: widget.builder(context, _current),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Modules should override/add specific actions when required via navigation to edit pages
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Use + inside a subsection to add an item')));
        },
      ),
    );
  }
}
