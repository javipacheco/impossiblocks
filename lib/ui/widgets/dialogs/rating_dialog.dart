import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/res/res_dimensions.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/ui/coins/viewmodels/coins_container_view_model.dart';
import 'package:impossiblocks/ui/widgets/dialogs/action_button_dialog.dart';
import 'package:store_redirect/store_redirect.dart';

class RatingDialog extends StatelessWidget {
  RatingDialog();

  static show(BuildContext context) {
    showGeneralDialog(
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return;
        },
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.4),
        barrierLabel: '',
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: RatingDialog(),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 300));
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
    return StoreConnector<AppState, CoinsContainerViewModel>(
        distinct: true,
        converter: (store) => CoinsContainerViewModel.build(store),
        builder: (context, viewModel) {
          double avatarRadiusDialog =
              Dimensions.avatarRadiusDialog(viewModel.sizeScreen);
          double spaceDialog = Dimensions.spaceDialog(viewModel.sizeScreen);
          return Stack(
            children: <Widget>[
              Container(
                constraints: new BoxConstraints(
                  minWidth: 300.0,
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
                      Text(
                        ImpossiblocksLocalizations.of(context)
                            .text("really_good"),
                        style: ResStyles.big(
                          viewModel.sizeScreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        ImpossiblocksLocalizations.of(context)
                            .text("store_msg"),
                        textAlign: TextAlign.center,
                        style: ResStyles.normal(
                            viewModel.sizeScreen,
                            fontWeight: FontWeight.w700,
                            height: 1.4),
                      ),
                      Text(
                        "50 ${ImpossiblocksLocalizations.of(context).text("coins").toLowerCase()}",
                        textAlign: TextAlign.center,
                        style: ResStyles.big(
                            viewModel.sizeScreen,
                            color: ResColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            height: 1.4),
                      ),
                      SizedBox(height: spaceDialog),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ActionButtonDialog(
                              sizeScreen: viewModel.sizeScreen,
                              text: ImpossiblocksLocalizations.of(context)
                                  .text("later"),
                              pressed: () {
                                Navigator.pop(context);
                              }),
                          ActionButtonDialog(
                              sizeScreen: viewModel.sizeScreen,
                              bgColor: ResColors.primaryColor,
                              text: ImpossiblocksLocalizations.of(context)
                                  .text("go_to_store"),
                              pressed: () {
                                viewModel.onVisitedStore();
                                viewModel.onAddCoins(50);
                                StoreRedirect.redirect(
                                    androidAppId: "com.impossibleblocks",
                                    iOSAppId: "1477714898");
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
                  backgroundColor: ResColors.colorTile2,
                  radius: avatarRadiusDialog,
                  child: Icon(
                    Icons.store,
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
