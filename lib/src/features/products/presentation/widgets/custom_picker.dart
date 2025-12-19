import 'package:canteen_frontend_seller/src/core/enums/filter.dart';
import 'package:flutter/material.dart';

class Picker extends StatefulWidget {
  const Picker({super.key, required this.onChanged});

  final ValueChanged<Filter> onChanged;

  @override
  State<Picker> createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  Filter selectedFilter = Filter.all;

  void _updateFilter(Filter filter) {
    setState(() {
      selectedFilter = filter;
    });
    widget.onChanged(filter);
  }

  void _resetToAll() {
    setState(() {
      selectedFilter = Filter.all;
    });
    widget.onChanged(Filter.all);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(236, 237, 238, 1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          for (final filter in Filter.values)
            _buildOption(filter.label, filter),
        ],
      ),
    );
  }

  Widget _buildOption(String text, Filter filter) {
    final bool isSelected = selectedFilter == filter;

    return Expanded(
      child: GestureDetector(
        onDoubleTapCancel: () {
          _resetToAll();
        },
        onTap: () => _updateFilter(filter),
        onDoubleTap: _resetToAll,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromRGBO(36, 138, 255, 1)
                : Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
