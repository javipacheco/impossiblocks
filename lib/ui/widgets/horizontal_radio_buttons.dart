import 'package:flutter/material.dart';
import 'package:impossiblocks/models/preferences_state.dart';
import 'package:impossiblocks/res/res_styles.dart';

class HorizontalRadioButtons extends StatefulWidget {
  final SizeScreen sizeScreen;

  final List<String> items;

  final Function(int) onTap;

  final String itemSelected;

  final Color selectedColor;

  final Color normalColor;

  final List<String> disabled;

  HorizontalRadioButtons({
    Key key,
    @required this.sizeScreen,
    @required this.items,
    @required this.onTap,
    @required this.itemSelected,
    @required this.selectedColor,
    @required this.normalColor,
    this.disabled = const [],
  }) : super(key: key);

  _HorizontalRadioButtonsState createState() => _HorizontalRadioButtonsState();
}

class _HorizontalRadioButtonsState extends State<HorizontalRadioButtons> {
  String _itemSelected;

  @override
  void initState() {
    _itemSelected = widget.itemSelected;
    super.initState();
  }

  @override
  void didUpdateWidget(HorizontalRadioButtons oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _itemSelected = widget.itemSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: new Border.all(color: Colors.grey.withAlpha(50)),
            borderRadius: BorderRadius.circular(30.0)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (var item in widget.items)
              ItemRadioButton(
                sizeScreen: widget.sizeScreen,
                selectedColor: widget.selectedColor,
                normalColor: widget.normalColor,
                text: item,
                selected: item == _itemSelected,
                disabled: widget.disabled.contains(item),
                onTap: () {
                  if (!widget.disabled.contains(item)) {
                    setState(() {
                      _itemSelected = item;
                    });
                    widget.onTap(widget.items.indexOf(item));
                  }
                },
              )
          ],
        ));
  }
}

class ItemRadioButton extends StatelessWidget {
  final SizeScreen sizeScreen;

  final String text;

  final bool selected;

  final bool disabled;

  final Function onTap;

  final Color selectedColor;

  final Color normalColor;

  const ItemRadioButton(
      {Key key,
      @required this.sizeScreen,
      @required this.text,
      @required this.selected,
      @required this.disabled,
      @required this.onTap,
      @required this.selectedColor,
      @required this.normalColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: RaisedButton(
          color: selected ? selectedColor : normalColor,
          colorBrightness: Brightness.dark,
          onPressed: onTap,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          child: Text(
            text,
            style: ResStyles.normal(sizeScreen,
                color: disabled
                    ? Colors.grey
                    : selected ? normalColor : selectedColor),
          )),
    );
  }
}
