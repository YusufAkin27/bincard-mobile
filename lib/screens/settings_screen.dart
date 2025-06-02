import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../constants/app_constants.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isNotificationsEnabled = true;
  bool _isBiometricEnabled = false;
  double _textScale = 0.5;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    // Bildirim ayarlarını yükleme
    setState(() {
      _isNotificationsEnabled = true; // Varsayılan değer
      _isBiometricEnabled = false; // Varsayılan değer
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() {
      _isNotificationsEnabled = value;
    });
    // Bildirim ayarını kaydet
  }

  Future<void> _toggleBiometric(bool value) async {
    setState(() {
      _isBiometricEnabled = value;
    });
    // Biyometrik ayarını kaydet
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Ayarlar',
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Görünüm Ayarları'),
              _buildAppearanceSettings(themeService),
              const SizedBox(height: 24),
              _buildSectionTitle('Bildirim Ayarları'),
              _buildNotificationSettings(),
              const SizedBox(height: 24),
              _buildSectionTitle('Güvenlik Ayarları'),
              _buildSecuritySettings(),
              const SizedBox(height: 24),
              _buildSectionTitle('Dil Ayarları'),
              _buildLanguageSettings(languageService),
              const SizedBox(height: 24),
              _buildSectionTitle('Hakkında'),
              _buildAboutSettings(),
              const SizedBox(height: 32),
              _buildHelpButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildAppearanceSettings(ThemeService themeService) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSwitchItem(
            icon: Icons.dark_mode,
            title: 'Karanlık Mod',
            value: themeService.isDarkMode,
            onChanged: (value) {
              themeService.setDarkMode(value);
            },
          ),
          const Divider(),
          _buildSliderItem(
            icon: Icons.text_fields,
            title: 'Yazı Boyutu',
            value: themeService.textScale * 0.5, // Ölçek için dönüşüm
            onChanged: (value) {
              double actualScale =
                  0.8 + (value * 0.4); // 0.8 ile 1.2 arasında ölçek
              themeService.setTextScale(actualScale);
              setState(() {
                _textScale = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSwitchItem(
            icon: Icons.notifications,
            title: 'Tüm Bildirimler',
            value: _isNotificationsEnabled,
            onChanged: _toggleNotifications,
          ),
          const Divider(),
          _buildSwitchItem(
            icon: Icons.money,
            title: 'Bakiye Bildirimleri',
            value: _isNotificationsEnabled,
            onChanged: (value) {
              setState(() {
                if (value) {
                  _isNotificationsEnabled = true;
                }
              });
              _toggleNotifications(value);
            },
          ),
          const Divider(),
          _buildSwitchItem(
            icon: Icons.campaign,
            title: 'Kampanya Bildirimleri',
            value: _isNotificationsEnabled,
            onChanged: (value) {
              setState(() {
                if (value) {
                  _isNotificationsEnabled = true;
                }
              });
              _toggleNotifications(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSwitchItem(
            icon: Icons.fingerprint,
            title: 'Biyometrik Kimlik Doğrulama',
            value: _isBiometricEnabled,
            onChanged: _toggleBiometric,
          ),
          const Divider(),
          _buildInfoItem(
            icon: Icons.security,
            title: 'Şifre Değiştir',
            hasArrow: true,
            onTap: () {
              // Şifre değiştirme sayfasına yönlendir
            },
          ),
          const Divider(),
          _buildInfoItem(
            icon: Icons.privacy_tip,
            title: 'Gizlilik Ayarları',
            hasArrow: true,
            onTap: () {
              // Gizlilik ayarları sayfasına yönlendir
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSettings(LanguageService languageService) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children:
            languageService.availableLanguages.map((language) {
              return Column(
                children: [
                  _buildRadioItem(
                    icon: Icons.language,
                    title: language,
                    value: language,
                    groupValue: languageService.selectedLanguage,
                    onChanged: (value) {
                      if (value != null) {
                        languageService.setLanguage(value);
                      }
                    },
                  ),
                  if (language != languageService.availableLanguages.last)
                    const Divider(),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildAboutSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoItem(
            icon: Icons.info,
            title: 'Uygulama Versiyonu',
            subtitle: AppConstants.appVersion,
          ),
          const Divider(),
          _buildInfoItem(
            icon: Icons.description,
            title: 'Kullanım Koşulları',
            hasArrow: true,
            onTap: () {
              // Kullanım koşulları sayfasına yönlendir
            },
          ),
          const Divider(),
          _buildInfoItem(
            icon: Icons.privacy_tip,
            title: 'Gizlilik Politikası',
            hasArrow: true,
            onTap: () {
              // Gizlilik politikası sayfasına yönlendir
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderItem({
    required IconData icon,
    required String title,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppTheme.primaryColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ),
              Text(
                '${(value * 100).round()}%',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.primaryColor,
              inactiveTrackColor: AppTheme.primaryColor.withOpacity(0.2),
              thumbColor: AppTheme.primaryColor,
              overlayColor: AppTheme.primaryColor.withOpacity(0.1),
            ),
            child: Slider(value: value, onChanged: onChanged),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioItem({
    required IconData icon,
    required String title,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ),
          Radio<String>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    String? subtitle,
    bool hasArrow = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.primaryColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (hasArrow)
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.primaryColor,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          // Yardım sayfasına yönlendir
        },
        icon: const Icon(Icons.help),
        label: const Text(
          'Yardım ve Destek',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
