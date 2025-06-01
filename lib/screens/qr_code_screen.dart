import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../constants/app_constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;

class QRCodeScreen extends StatefulWidget {
  final bool isScanner;
  final String? cardNumber;
  final String? cardName;

  const QRCodeScreen({
    Key? key,
    this.isScanner = false,
    this.cardNumber,
    this.cardName,
  }) : super(key: key);

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _flashOn = false;
  bool _isFrontCamera = false;

  // QR kodunu temsil eden demo veri
  final String _qrData = "CityCard://Payment/123456789";

  // Kartlar listesi (aslında API'den gelecek)
  final List<Map<String, dynamic>> _cards = [
    {
      'name': 'Şehir Kartı',
      'number': '5312 **** **** 3456',
      'balance': '257,50 ₺',
      'color': AppTheme.blueGradient,
    },
    {
      'name': 'İkinci Kartım',
      'number': '4728 **** **** 9012',
      'balance': '125,75 ₺',
      'color': AppTheme.greenGradient,
    },
  ];

  int _selectedCardIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.isScanner ? 0 : 1,
    );

    // Eğer belirli bir kart numarası iletildiyse, o kartı seç
    if (widget.cardNumber != null) {
      final index = _cards.indexWhere(
        (card) => card['number'] == widget.cardNumber,
      );
      if (index != -1) {
        _selectedCardIndex = index;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          'QR Kod',
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.textSecondaryColor,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [Tab(text: 'QR TARA'), Tab(text: 'QR GÖSTER')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildScannerTab(), _buildShowQRTab()],
      ),
    );
  }

  Widget _buildScannerTab() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              // QR tarayıcı alanı (kamera izni gerektirir)
              Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    color: Colors.black.withOpacity(0.8),
                    child: Center(
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.primaryColor,
                            width: 2,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Köşe işaretleri
                            Positioned(
                              left: 0,
                              top: 0,
                              child: _buildCornerMarker(),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Transform.rotate(
                                angle: math.pi / 2,
                                child: _buildCornerMarker(),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Transform.rotate(
                                angle: math.pi,
                                child: _buildCornerMarker(),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              bottom: 0,
                              child: Transform.rotate(
                                angle: 3 * math.pi / 2,
                                child: _buildCornerMarker(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Tarama çizgisi animasyonu
              Positioned.fill(
                child: Center(
                  child: SizedBox(
                    width: 250,
                    height: 250,
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 2),
                        width: 220,
                        height: 2,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.5),
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Kamera kontrolleri
              Positioned(
                bottom: 24,
                right: 24,
                child: Column(
                  children: [
                    _buildCameraControlButton(
                      icon: _flashOn ? Icons.flash_on : Icons.flash_off,
                      label: _flashOn ? 'Flaş Açık' : 'Flaş Kapalı',
                      onTap: () {
                        setState(() {
                          _flashOn = !_flashOn;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildCameraControlButton(
                      icon:
                          _isFrontCamera
                              ? Icons.camera_front
                              : Icons.camera_rear,
                      label: _isFrontCamera ? 'Ön Kamera' : 'Arka Kamera',
                      onTap: () {
                        setState(() {
                          _isFrontCamera = !_isFrontCamera;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              Text(
                'QR kodu tarayıcı kare içerisine yerleştirin',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Galeriden QR kod seçme işlevi
                      },
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Galeriden Seç'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCornerMarker() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.primaryColor, width: 4),
          left: BorderSide(color: AppTheme.primaryColor, width: 4),
        ),
      ),
    );
  }

  Widget _buildCameraControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryColor),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShowQRTab() {
    return Column(
      children: [
        const SizedBox(height: 24),
        Expanded(
          child: Column(
            children: [
              _buildCardSelector(),
              const SizedBox(height: 24),
              _buildQRCodeDisplay(),
              const SizedBox(height: 24),
              _buildQRInfo(),
            ],
          ),
        ),
        _buildBottomActions(),
      ],
    );
  }

  Widget _buildCardSelector() {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];
          final isSelected = index == _selectedCardIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCardIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient:
                    isSelected
                        ? LinearGradient(
                          colors: card['color'],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                        : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.creditCard,
                      size: 16,
                      color:
                          isSelected
                              ? Colors.white
                              : AppTheme.textSecondaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      card['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            isSelected
                                ? Colors.white
                                : AppTheme.textPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQRCodeDisplay() {
    final selectedCard = _cards[_selectedCardIndex];
    return Column(
      children: [
        Text(
          'Kartınızın QR Kodu',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 250,
          height: 250,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/qr_code_placeholder.png',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                selectedCard['number'],
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQRInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Bu QR kodu ödeme yapmak veya kart bakiyenizi göstermek için kullanabilirsiniz.',
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.privacy_tip_outlined,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'QR kodunuzu güvenliğiniz için sadece işlem yapacağınız zaman gösterin.',
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // QR kodu paylaşma işlevi
              },
              icon: const Icon(Icons.share),
              label: const Text('QR Kodu Paylaş'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                // QR kodu yenileme işlevi
              },
              icon: Icon(Icons.refresh, color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
