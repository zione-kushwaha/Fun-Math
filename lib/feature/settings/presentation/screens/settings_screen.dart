import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/core/theme/provider/theme_provider.dart';
import 'package:fun_math/core/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fun_math/core/utils/extensions.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _soundEnabled = prefs.getBool('sound_enabled') ?? true;
      _musicEnabled = prefs.getBool('music_enabled') ?? true;
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', _soundEnabled);
    await prefs.setBool('music_enabled', _musicEnabled);
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = ref.watch(themeProvider.notifier);
    final isDarkMode = themeNotifier.isDarkMode;
    
    final languageNotifier = ref.watch(languageProvider.notifier);
    final currentLocale = ref.watch(languageProvider);
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: (){
            context.go('/');
          },
        ),
        title: Text('settings'.tr(context)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Appearance Section
              SettingsSection(
                title: 'Appearance',
                icon: Iconsax.paintbucket,
                children: [
                  SettingsTile(
                    title: 'theme'.tr(context),
                    icon: isDarkMode ? Iconsax.moon : Iconsax.sun_1,
                    subtitle: isDarkMode 
                        ? 'darkMode'.tr(context) 
                        : 'lightMode'.tr(context),
                    trailing: Switch(
                      value: isDarkMode,
                      onChanged: (value) {
                        themeNotifier.toggleTheme();
                      },
                    ),
                  ),
                  SettingsTile(
                    title: 'language'.tr(context),
                    icon: Iconsax.language_square,
                    subtitle: currentLocale.languageCode == 'en' 
                        ? 'English' : 'नेपाली',
                    onTap: () {
                      _showLanguagePickerDialog(context, languageNotifier, currentLocale);
                    },
                  ),
                ],
              ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1, end: 0),
              
              const SizedBox(height: 20),
              
              // App Preferences Section
              SettingsSection(
                title: 'Preferences',
                icon: Iconsax.setting_2,
                children: [
                  SettingsTile(
                    title: 'sound'.tr(context),
                    icon: _soundEnabled ? Iconsax.volume_high : Iconsax.volume_slash,
                    subtitle: _soundEnabled 
                        ? 'Sound effects are enabled' 
                        : 'Sound effects are disabled',
                    trailing: Switch(
                      value: _soundEnabled,
                      onChanged: (value) {
                        setState(() {
                          _soundEnabled = value;
                          _saveSettings();
                        });
                      },
                    ),
                  ),
                  SettingsTile(
                    title: 'music'.tr(context),
                    icon: _musicEnabled ? Iconsax.music : Iconsax.music_filter,
                    subtitle: _musicEnabled 
                        ? 'Background music is enabled' 
                        : 'Background music is disabled',
                    trailing: Switch(
                      value: _musicEnabled,
                      onChanged: (value) {
                        setState(() {
                          _musicEnabled = value;
                          _saveSettings();
                        });
                      },
                    ),
                  ),
                  SettingsTile(
                    title: 'notifications'.tr(context),
                    icon: _notificationsEnabled ? Iconsax.notification : Iconsax.notification_bing,
                    subtitle: _notificationsEnabled 
                        ? 'Notifications are enabled' 
                        : 'Notifications are disabled',
                    trailing: Switch(
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                          _saveSettings();
                        });
                      },
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 300.ms, delay: 100.ms).slideX(begin: -0.1, end: 0),
              
              const SizedBox(height: 20),
              
              // About Section
              SettingsSection(
                title: 'About',
                icon: Iconsax.info_circle,
                children: [
                  SettingsTile(
                    title: 'about'.tr(context),
                    icon: Iconsax.book_1,
                    onTap: () {
                      _showAboutDialog(context);
                    },
                  ),
                  SettingsTile(
                    title: 'privacyPolicy'.tr(context),
                    icon: Iconsax.shield_tick,
                    onTap: () {
                      // Open privacy policy
                      _launchUrl('https://example.com/privacy');
                    },
                  ),
                  SettingsTile(
                    title: 'rateApp'.tr(context),
                    icon: Iconsax.star_1,
                    onTap: () async {
                      final InAppReview inAppReview = InAppReview.instance;
                      if (await inAppReview.isAvailable()) {
                        inAppReview.requestReview();
                      }
                    },
                  ),
                  SettingsTile(
                    title: 'shareApp'.tr(context),
                    icon: Iconsax.share,
                    onTap: () {
                      // Share app
                      _shareApp();
                    },
                  ),
                  SettingsTile(
                    title: 'contactUs'.tr(context),
                    icon: Iconsax.message,
                    onTap: () {
                      // Contact
                      _launchUrl('mailto:contact@example.com');
                    },
                  ),
                ],
              ).animate().fadeIn(duration: 300.ms, delay: 200.ms).slideX(begin: -0.1, end: 0),
              
              const SizedBox(height: 20),
              
              // Version info
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'version'.tr(context) + ' 1.0.0',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 300.ms),
            ],
          ),
        ),
      ),
    );
  }
  
  // Language picker dialog
  void _showLanguagePickerDialog(BuildContext context, LanguageNotifier languageNotifier, Locale currentLocale) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('language'.tr(context)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const CircleAvatar(child: Text('🇺🇸')),
                title: const Text('English'),
                trailing: currentLocale.languageCode == 'en' 
                    ? const Icon(Icons.check_circle, color: Colors.green) 
                    : null,
                onTap: () {
                  languageNotifier.setLanguage('en');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const CircleAvatar(child: Text('🇳🇵')),
                title: const Text('नेपाली'),
                trailing: currentLocale.languageCode == 'ne' 
                    ? const Icon(Icons.check_circle, color: Colors.green) 
                    : null,
                onTap: () {
                  languageNotifier.setLanguage('ne');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  // About dialog
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AboutDialog(
          applicationName: 'Fun Math',
          applicationVersion: '1.0.0',
          applicationIcon: Image.asset('assets/images/app_icon.png', width: 50, height: 50),
          children: [
            const Text(
              'Fun Math is an educational app designed to make learning mathematics enjoyable and engaging for learners of all ages. Through interactive games and puzzles, it helps build fundamental math skills while having fun.',
            ),
          ],
        );
      },
    );
  }
  
  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
  
  void _shareApp() {
    // Implement share functionality
    // This would typically use the share package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing functionality coming soon!')),
    );
  }
}
