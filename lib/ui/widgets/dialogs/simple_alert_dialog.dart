import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/models/app_state.dart';
import 'package:impossiblocks/res/res_dimensions.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/ui/widgets/dialogs/action_button_dialog.dart';
import 'package:impossiblocks/ui/widgets/dialogs/common_dialog_view_model.dart';

class SimpleAlertDialog extends StatefulWidget {
  static show(BuildContext context, IconData icon, String title, String message,
      Function() onOkClick) {
    showDialog(
      context: context,
      builder: (BuildContext context) => SimpleAlertDialog(
        icon: icon,
        onOkClick: onOkClick,
        title: title,
        message: message,
      ),
    );
  }

  final IconData icon;

  final Function() onOkClick;

  final String title;

  final String message;

  SimpleAlertDialog(
      {Key key,
      @required this.icon,
      @required this.onOkClick,
      this.title,
      this.message})
      : super(key: key);

  _SimpleAlertDialogState createState() => _SimpleAlertDialogState();
}

class _SimpleAlertDialogState extends State<SimpleAlertDialog> {
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
          double spaceDialog = Dimensions.spaceDialog(viewModel.sizeScreen);
          return Stack(
            children: <Widget>[
              Container(
                constraints: new BoxConstraints(
                  minWidth: 250.0,
                ),
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
                      Text(widget.title,
                          style: ResStyles.big(viewModel.sizeScreen)),
                      SizedBox(height: spaceDialog),
                      Text(widget.message,
                          textAlign: TextAlign.center,
                          style: ResStyles.normal(viewModel.sizeScreen,
                              color: Colors.black87)),
                      SizedBox(height: spaceDialog),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (widget.onOkClick != null)
                            ActionButtonDialog(
                                sizeScreen: viewModel.sizeScreen,
                                text: ImpossiblocksLocalizations.of(context)
                                    .text("ok"),
                                pressed: () {
                                  widget.onOkClick();
                                  Navigator.pop(context);
                                }),
                          ActionButtonDialog(
                              sizeScreen: viewModel.sizeScreen,
                              text: ImpossiblocksLocalizations.of(context)
                                  .text("cancel"),
                              pressed: () {
                                Navigator.pop(context);
                              }),
                        ],
                      )
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
                    widget.icon,
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
