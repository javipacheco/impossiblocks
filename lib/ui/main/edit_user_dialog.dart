import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/res/res_dimensions.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/ui/widgets/avatar.dart';
import 'package:impossiblocks/ui/widgets/dialogs/action_button_dialog.dart';
import 'package:impossiblocks/ui/widgets/dialogs/common_dialog_view_model.dart';

class EditUserDialog extends StatefulWidget {
  static show(BuildContext context, Function(String, int) onChangeName,
      {String defaultName: "", int defaultAvatar: 0, String defaultMessage}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => EditUserDialog(
        onChangeName: onChangeName,
        defaultName: defaultName,
        defaultAvatar: defaultAvatar,
        defaultMessage: defaultMessage,
      ),
    );
  }

  final Function(String, int) onChangeName;

  final String defaultName;

  final int defaultAvatar;

  final String defaultMessage;

  EditUserDialog({
    Key key,
    @required this.onChangeName,
    this.defaultName: "",
    this.defaultAvatar: 0,
    this.defaultMessage,
  }) : super(key: key);

  _EditUserDialogState createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  TextEditingController _controller;

  PageController _pageController;

  int _page;

  @override
  void initState() {
    _controller = new TextEditingController(text: widget.defaultName);
    _pageController = PageController(
        viewportFraction: 0.4, initialPage: widget.defaultAvatar ?? 0);
    _page = widget.defaultAvatar;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.roundedLayout),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return StoreConnector<AppState, CommonDialogViewModel>(
        distinct: true,
        converter: (store) => CommonDialogViewModel.build(store),
        builder: (context, viewModel) {
          double avatarRadiusDialog =
              Dimensions.avatarRadiusDialog(viewModel.sizeScreen);
          return Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: avatarRadiusDialog + Dimensions.paddingDialog,
                  bottom: Dimensions.paddingDialog,
                  left: Dimensions.paddingDialog,
                  right: Dimensions.paddingDialog,
                ),
                margin: EdgeInsets.only(top: avatarRadiusDialog),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(Dimensions.paddingDialog),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (widget.defaultMessage != null)
                        Text(
                          widget.defaultMessage,
                          style: ResStyles.subtitleMainScreen,
                          textAlign: TextAlign.center,
                        ),
                      if (widget.defaultMessage != null) SizedBox(height: 16.0),
                      Container(
                        height: 60,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: 8,
                          onPageChanged: (page) {
                            setState(() {
                              _page = page;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(right: 8.0, left: 8.0),
                              child: Avatar(avatar: index, color: index),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 24.0),
                      Text(
                          ImpossiblocksLocalizations.of(context)
                              .text("enter_user_name"),
                          style: ResStyles.titleMainScreen),
                      SizedBox(height: 12.0),
                      TextFormField(
                        controller: _controller,
                        style: ResStyles.normal(viewModel.sizeScreen),
                        //textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24.0),
                      ActionButtonDialog(
                          sizeScreen: viewModel.sizeScreen,
                          text:
                              ImpossiblocksLocalizations.of(context).text("ok"),
                          pressed: () {
                            if (_controller.text != null &&
                                _controller.text.isNotEmpty) {
                              widget.onChangeName(_controller.text, _page);
                              Navigator.pop(context);
                            }
                          })
                    ],
                  ),
                ),
              ),
              Positioned(
                left: Dimensions.paddingDialog,
                right: Dimensions.paddingDialog,
                child: CircleAvatar(
                  backgroundColor: ResColors.colorTile1,
                  radius: avatarRadiusDialog,
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: avatarRadiusDialog + 14,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
