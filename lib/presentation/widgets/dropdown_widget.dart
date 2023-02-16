import 'package:flutter/material.dart';

class DropdownWidgetQ extends StatefulWidget {
  final List<dynamic>? items;
  final Function onChanged;
  final String hint;
  final dynamic value;
  final String label;
  final List<DropdownMenuItem>? customItems;
  final bool isValidate;

  const DropdownWidgetQ({
    Key? key,
    this.items,
    required this.onChanged,
    required this.hint,
    required this.label,
    required this.value,
    this.customItems,
    this.isValidate = false,
  }) : super(key: key);

  @override
  State<DropdownWidgetQ> createState() => _DropdownWidgetQState();
}

class _DropdownWidgetQState extends State<DropdownWidgetQ> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField<dynamic>(
        validator: widget.isValidate
            ? (value) {
                if (widget.value == "" || widget.value == null) {
                  return "กรุณาเลือก${widget.label}";
                }
                return null;
              }
            : null,
        alignment: Alignment.centerLeft,
        decoration: InputDecoration(
          labelText: widget.label,
        ),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
        items: widget.customItems ??
            widget.items!.map<DropdownMenuItem<String>>(
              (value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                );
              },
            ).toList(),
        onChanged: (value) {
          widget.onChanged(value);
        },
        hint: Text(
          widget.hint,
        ),
        value: widget.value == "" ? null : widget.value,
      ),
    );
  }
}
