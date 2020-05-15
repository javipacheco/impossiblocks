import 'package:flutter/material.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/ui/main/edit_user_dialog.dart';
import 'package:impossiblocks/ui/main/viewmodels/main_screen_view_model.dart';
import 'package:impossiblocks/ui/widgets/avatar.dart';
import 'package:impossiblocks/ui/widgets/dialogs/simple_alert_dialog.dart';
import 'package:impossiblocks/ui/widgets/rounded_container.dart';

class UsersDialog extends StatefulWidget {
  const UsersDialog({
    Key key,
  }) : super(key: key);

  _UserDialogState createState() => _UserDialogState();
}

class _UserDialogState extends State<UsersDialog> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MainScreenViewModel>(
        converter: (store) => MainScreenViewModel.build(store),
        onInitialBuild: (viewModel) {
          viewModel.onLoadUsers();
        },
        builder: (context, viewModel) {
          return RoundedContainer(
              color: Colors.white,
              bgColor: Colors.transparent,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints.expand(height: 64),
                      color: ResColors.colorTile1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 10),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Icon(Icons.account_circle,
                                  color: Colors.white),
                            ),
                            Expanded(
                              child: Text(
                                ImpossiblocksLocalizations.of(context)
                                    .text("users"),
                                style: ResStyles.titleScreen(viewModel.sizeScreen),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              onPressed: () => {
                                EditUserDialog.show(context, (name, avatar) {
                                  viewModel.onAddUser(name, avatar);
                                })
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: false,
                        itemCount: viewModel.users.length,
                        itemBuilder: (context, i) {
                          var user = viewModel.users[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: ListTile(
                                leading: Avatar(
                                    avatar: user?.avatar, color: user?.color),
                                title: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4.0),
                                            child: Text(
                                              user.name,
                                              style: ResStyles.normal(
                                                  viewModel.sizeScreen),
                                            ),
                                          ),
                                          Text(
                                            "${user.coins} ${ImpossiblocksLocalizations.of(context).text("coins")}",
                                            style: ResStyles.small(
                                                viewModel.sizeScreen,
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.blueGrey,
                                      ),
                                      onPressed: () => {
                                        EditUserDialog.show(context,
                                            (name, avatar) {
                                          viewModel.onUpdateUser(
                                              user.id, name, avatar);
                                        },
                                            defaultName: user.name,
                                            defaultAvatar: user.avatar)
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.blueGrey,
                                      ),
                                      onPressed: () => {
                                        if (viewModel.currentUser.id != user.id)
                                          {
                                            SimpleAlertDialog.show(
                                                context,
                                                Icons.info,
                                                ImpossiblocksLocalizations.of(
                                                        context)
                                                    .text("delete_user"),
                                                ImpossiblocksLocalizations.of(
                                                        context)
                                                    .text("delete_user_msg"),
                                                () {
                                              viewModel.onDeleteUser(user.id);
                                            })
                                          }
                                        else
                                          {
                                            SimpleAlertDialog.show(
                                                context,
                                                Icons.info,
                                                ImpossiblocksLocalizations.of(
                                                        context)
                                                    .text("delete_user"),
                                                ImpossiblocksLocalizations.of(
                                                        context)
                                                    .text(
                                                        "no_detete_active_user_msg"),
                                                null)
                                          }
                                      },
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  viewModel.onSelectUser(user.id);
                                  Navigator.pop(context);
                                }),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}
