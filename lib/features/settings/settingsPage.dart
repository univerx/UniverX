import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:univerx/features/common/widgets/logout.dart';
import 'package:univerx/features/settings/widgets/privacy_policy_page.dart';
import 'package:univerx/services/notification_service.dart.dart';
import 'package:url_launcher/url_launcher.dart';

// ---------------------Widgets--------------------------
import 'package:univerx/features/common/widgets/default_app_bar.dart';
import 'package:univerx/features/common/widgets/profile_menu.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _notificationsEnabled = true; // Default value

  @override
  void initState() {
    super.initState();
    // Initialize notification state or preferences if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 18, 32),
      body: CustomScrollView(
        slivers: <Widget>[
          DefaultAppBar(
            title: 'Settings',
            showBackButton: true,
            showProfileMenu: false,
            showDoneButton: false,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildSettingsItem(
                  context,
                  icon: CupertinoIcons.bell,
                  text: 'Notification',
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                        if (_notificationsEnabled) {
                          // Enable notifications
                          print('Notifications enabled');
                          NotificationService().showNotification('Notifications Enabled', 'You will now receive notifications.');
                        } else {
                          // Disable notifications
                          // Optionally, cancel notifications if needed
                        }
                      });
                    },
                  ),
                ),
                _buildSettingsItem(
                  context,
                  icon: CupertinoIcons.moon,
                  text: 'Dark Mode',
                ),
                _buildSettingsItem(
                  context,
                  icon: CupertinoIcons.star,
                  text: 'Rate App',
                  onTap: _rateApp,
                ),
                _buildSettingsItem(
                  context,
                  icon: CupertinoIcons.share,
                  text: 'Share App',
                  onTap: _shareApp,
                ),
                _buildSettingsItem(
                  context,
                  icon: CupertinoIcons.lock,
                  text: 'Privacy Policy',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
                    );
                  },
                ),
                _buildSettingsItem(
                  context,
                  icon: CupertinoIcons.chat_bubble,
                  text: 'Feedback',
                  onTap: _sendFeedbackEmail,
                ),
                _buildSettingsItem(
                  context,
                  icon: CupertinoIcons.mail,
                  text: 'Contact',
                  onTap: _sendContactEmail,
                ),
                _buildSettingsItem(
                  context,
                  icon: CupertinoIcons.arrow_right,
                  text: 'Logout',
                  onTap: () async {
                    await showLogoutDialog(context, () {});
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    Widget? trailing,
    Function()? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      trailing: trailing ??
          Icon(
            CupertinoIcons.forward,
            color: Colors.white,
          ),
      onTap: onTap,
    );
  }

  void _rateApp() async {
    final Uri appStoreUri = Uri(
      scheme: 'https',
      host: 'apps.apple.com',
      path: '/app/id6504604445',
      queryParameters: {'action': 'write-review'},
    );

    if (await canLaunchUrl(appStoreUri)) {
      await launchUrl(appStoreUri);
    } else {
      throw 'Could not launch App Store';
    }
  }

  void _shareApp() async {
    final Uri appStoreUri = Uri(
      scheme: 'https',
      host: 'apps.apple.com',
      path: '/app/id6504604445',
    );
    
    final String shareText = 'Check out this app: ${appStoreUri.toString()}';

    // Uncomment if using `share_plus` package
    // import 'package:share_plus/share_plus.dart';
    // Share.share(shareText);

    // For simplicity, we'll just open the URL for now
    if (await canLaunchUrl(appStoreUri)) {
      await launchUrl(appStoreUri);
    } else {
      throw 'Could not share App Store link';
    }
  }

  void _sendFeedbackEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'univerxapp@gmail.com',
      queryParameters: {
        'subject': 'App Feedback',
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch email client';
    }
  }

  void _sendContactEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'univerxapp@gmail.com',
      queryParameters: {
        'subject': 'Contact Us',
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch email client';
    }
  }
}
