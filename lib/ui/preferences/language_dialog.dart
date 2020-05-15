import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/models/app_state.dart';
import 'package:impossiblocks/res/res_dimensions.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/ui/preferences/viewmodels/language_dialog_view_model.dart';
import 'package:impossiblocks/ui/widgets/dialogs/action_button_dialog.dart';
import 'package:impossiblocks/ui/widgets/dialogs/simple_alert_dialog.dart';

class LanguageDialog extends StatefulWidget {
  static show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => LanguageDialog(),
    );
  }

  LanguageDialog({Key key}) : super(key: key);

  _LanguageDialogState createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  List<String> langs = [
    "en",
    "es",
    "pt",
    "de",
    "it",
    "hi",
    "fr",
    "ru",
    "ja",
    "zh",
  ];

  List<String> langsName = [
    "English",
    "Spanish",
    "Portuguese",
    "German",
    "Italian",
    "Hindu",
    "French",
    "Russian",
    "Japanese",
    "Chinese",
  ];

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LanguageDialogViewModel>(
        converter: (store) => LanguageDialogViewModel.build(store),
        distinct: true,
        builder: (context, viewModel) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.roundedLayout),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: dialogContent(context, viewModel),
          );
        });
  }

  dialogContent(BuildContext context, LanguageDialogViewModel viewModel) {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                  ImpossiblocksLocalizations.of(context)
                      .text("select_language"),
                  style: ResStyles.big(viewModel.sizeScreen)),
              SizedBox(height: spaceDialog),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: langsName.length,
                    itemBuilder: (context, i) {
                      var name = langsName[i];
                      var lang = langs[i];
                      String currentLocale = viewModel.locale;
                      return ListTile(
                          leading: currentLocale == lang
                              ? Icon(Icons.check)
                              : SizedBox(
                                  width: 20,
                                  height: 20,
                                ),
                          title: Row(
                            children: <Widget>[
                              Text(
                                name,
                                style: ResStyles.normal(viewModel.sizeScreen),
                              ),
                            ],
                          ),
                          onTap: () {
                            viewModel.onSelectLang(lang);
                            Navigator.pop(context);
                            SimpleAlertDialog.show(
                                context,
                                Icons.language,
                                ImpossiblocksLocalizations.of(context)
                                    .text("language"),
                                ImpossiblocksLocalizations.of(context)
                                    .text("reset_lang"),
                                null);
                          });
                    }),
              ),
              SizedBox(height: spaceDialog),
              ActionButtonDialog(
                  sizeScreen: viewModel.sizeScreen,
                  text: ImpossiblocksLocalizations.of(context).text("back"),
                  pressed: () {
                    Navigator.pop(context);
                  })
            ],
          ),
        ),
        Positioned(
          left: Dimensions.paddingDialog,
          right: Dimensions.paddingDialog,
          child: CircleAvatar(
            backgroundColor: ResColors.colorTile1,
            radius: avatarRadiusDialog,
            child: SvgPicture.asset(
              "assets/images/ic_language.svg",
              color: Colors.white,
              width: avatarRadiusDialog + 14,
              height: avatarRadiusDialog + 14,
            ),
          ),
        ),
      ],
    );
  }
}
