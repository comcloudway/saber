
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:saber/components/theming/adaptive_toggle_buttons.dart';
import 'package:saber/data/prefs.dart';

class SettingsSelection extends StatefulWidget {
  const SettingsSelection({
    super.key,
    required this.title,
    this.subtitle,
    required this.pref,
    required this.options,
    this.afterChange,
  });

  final String title;
  final String? subtitle;
  final IPref<int, dynamic> pref;
  final List<ToggleButtonsOption<int>> options;
  final ValueChanged<int>? afterChange;

  @override
  State<SettingsSelection> createState() => _SettingsSelectionState();
}

class _SettingsSelectionState extends State<SettingsSelection> {
  @override
  void initState() {
    widget.pref.addListener(onChanged);
    super.initState();
  }

  void onChanged() {
    widget.afterChange?.call(widget.pref.value);
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.options.any((ToggleButtonsOption option) => widget.pref.value == option.value)) {
      if (kDebugMode) print("WARNING: SettingsSelection: Value ${widget.pref.value} is not in the list of values, setting it to ${widget.options.first.value}");
      widget.pref.value = widget.options.first.value;
    }
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      title: Text(widget.title),
      subtitle: Text(widget.subtitle ?? "", style: const TextStyle(fontSize: 13)),
      trailing: AdaptiveToggleButtons(
        value: widget.pref.value,
        options: widget.options,
        onChange: (int? value) {
          // setState is automatically called when the pref changes
          if (value != null) {
            widget.pref.value = value;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    widget.pref.removeListener(onChanged);
    super.dispose();
  }
}
