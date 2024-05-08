import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/app_colors.dart';
import 'package:to_do/controller/settings_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:to_do/controller/todo_provider.dart';
import 'package:to_do/model/user_dm.dart';
import 'package:to_do/screens/auth_screen.dart';

class AppBarBuild extends StatelessWidget {
  AppBarBuild(this.title, {super.key});
  String title;

  @override
  Widget build(BuildContext context) {
    TodoProvider todoProvider = Provider.of(context);
    SettingsProvider settingsProvider=Provider.of(context);
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.25,
      width: double.infinity,
      color: Colors.blue,
      child: Container(
        margin: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                  color:settingsProvider.mode =='Dark'|| settingsProvider.mode=='مظلم'? AppColors.darkSecoundaryColor: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            IconButton(
                onPressed: (){
                  UserDm.currentUser = null;
                  todoProvider.todos=[];
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const AuthScreen()));
                },
                icon: Icon(Icons.logout,size: 30,color:settingsProvider.mode =='Dark'|| settingsProvider.mode=='مظلم'? AppColors.darkSecoundaryColor: Colors.white,),
            )
          ],
        ),
      ),
    );
  }
}
