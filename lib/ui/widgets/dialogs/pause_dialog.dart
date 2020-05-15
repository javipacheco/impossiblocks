import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/models/app_state.dart';
import 'package:impossiblocks/res/res_dimensions.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/ui/widgets/dialogs/action_button_dialog.dart';
import 'package:impossiblocks/ui/widgets/dialogs/common_dialog_view_model.dart';

class PauseDialog extends StatefulWidget {
  static show(BuildContext context, Function onResume) {
    showGeneralDialog(
            context: context,
            pageBuilder: (context, anim1, anim2) {
              return;
            },
            barrierDismissible: true,
            barrierColor: Colors.black.withOpacity(0.4),
            barrierLabel: '',
            transitionBuilder: (context, a1, a2, widget) {
              final curvedValue =
                  Curves.easeInOutBack.transform(a1.value) - 1.0;
              return Transform(
                transform:
                    Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                child: Opacity(
                  opacity: a1.value,
                  child: PauseDialog(
                    onResume: onResume,
                  ),
                ),
              );
            },
            transitionDuration: Duration(milliseconds: 300))
        .then((v) {
      // Si fue llamado onNextLevel desde una acción, v tiene true
      if (v == null) onResume();
    });
  }

  final Function onResume;

  PauseDialog({Key key, @required this.onResume}) : super(key: key);

  _PauseDialogState createState() => _PauseDialogState();
}

class _PauseDialogState extends State<PauseDialog> {
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
                      Text(ImpossiblocksLocalizations.of(context).text("pause"),
                          style: ResStyles.big(viewModel.sizeScreen)),
                      SizedBox(height: spaceDialog),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ActionButtonDialog(
                              sizeScreen: viewModel.sizeScreen,
                              text: ImpossiblocksLocalizations.of(context)
                                  .text("back"),
                              pressed: () {
                                widget.onResume();
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
                    Icons.pause,
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
