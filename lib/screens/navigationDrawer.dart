import 'package:flutter/material.dart';
import 'package:just_do_it/utilities/colors.dart';
import 'package:just_do_it/utilities/settingMenu.dart';
import 'package:just_do_it/widgets/sizedBox.dart';
import 'package:share_plus/share_plus.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  Widget About(context) {
    return ListTile(
        leading: Icon(
          Icons.info_outline_rounded,
          color: White(),
          size: 28,
        ),
        title: Text(
          'About',
          style: TextStyle(color: White(), fontSize: 22),
        ),
        onTap: () => showAboutDialog(
                context: context,
                applicationName: "Just Do It.",
                applicationVersion: '1.0',
                applicationIcon: Image.asset(
                  'assets/images/download.png',
                  height: 40,
                  width: 40,
                ),
                children: [
                  const Text(
                      "Just Do It. A kind of app that generally used to maintain our day-to-day tasks and schedule events. It is helpful in planning our daily routines and events and always reminds you with notification"),
                  const szdbx(ht: 18),
                  const Text("App developed by InShad K.")
                ]));
  }

  Widget PrivacyPolicy(context) {
    return ListTile(
      leading: Icon(
        Icons.policy_outlined,
        color: White(),
        size: 28,
      ),
      title: Text(
        'Privacy Policy',
        style: TextStyle(color: White(), fontSize: 22),
      ),
      onTap: () => showDialog(
          context: context,
          builder: (builder) {
            return settingmenupopup(mdFilename: 'privacy_policy.md');
          }),
    );
  }

  Widget TermsAndConditions(context) {
    return ListTile(
      leading: Icon(
        Icons.library_books_outlined,
        color: White(),
        size: 28,
      ),
      title: Text(
        'Terms And Conditions',
        style: TextStyle(color: White(), fontSize: 22),
      ),
      onTap: () => showDialog(
          context: context,
          builder: (builder) {
            return settingmenupopup(mdFilename: 'terms_and_conditions.md');
          }),
    );
  }

  Widget Share() {
    return ListTile(
        leading: Icon(
          Icons.share_outlined,
          color: White(),
          size: 28,
        ),
        title: Text(
          'Share',
          style: TextStyle(color: White(), fontSize: 22),
        ),
        onTap: () => {}
        // Share.share(" ",
        //       subject: "Github Repo Of This App"),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ThemeGreyfull(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(children: [
            About(context),
            PrivacyPolicy(context),
            TermsAndConditions(context),
            Share(),
            Padding(
              padding: const EdgeInsets.only(top: 600.0),
              child: Text(
                'version\n    1.0',
                style: TextStyle(color: White(), fontSize: 18),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
