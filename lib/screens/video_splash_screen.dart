import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import '../config/theme.dart';
import 'main_navigation.dart';

class VideoSplashScreen extends StatefulWidget {
  const VideoSplashScreen({super.key});

  @override
  State<VideoSplashScreen> createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen> with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller;
  bool _isVideoInitialized = false;
  bool _hasError = false;
  bool _useVideo = !kIsWeb;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
    
    if (_useVideo) {
      _initializeVideo();
    } else {
      Future.delayed(const Duration(seconds: 4), () {
        _navigateToHome();
      });
    }
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.asset('assets/videos/splash.mp4');
      await _controller!.initialize();
      
      setState(() {
        _isVideoInitialized = true;
      });

      await _controller!.play();

      _controller!.addListener(() {
        if (_controller!.value.position >= _controller!.value.duration) {
          _navigateToHome();
        }
      });
    } catch (e) {
      print('Error loading video: $e');
      setState(() {
        _hasError = true;
      });
      Future.delayed(const Duration(seconds: 4), () {
        _navigateToHome();
      });
    }
  }

  void _navigateToHome() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_useVideo || _hasError || !_isVideoInitialized) {
      return _buildKineticSplash();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: SafeArea(
              child: GestureDetector(
                onTap: _navigateToHome,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    border: Border.all(color: AppTheme.textPrimary, width: 3),
                  ),
                  child: Text(
                    'SKIP',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textPrimary,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKineticSplash() {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Blueprint Grid Background
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: CustomPaint(
                painter: BlueprintGridPainter(),
              ),
            ),
          ),
          
          // Kinetic Lines
          Positioned.fill(
            child: Opacity(
              opacity: 0.6,
              child: CustomPaint(
                painter: KineticLinesPainter(),
              ),
            ),
          ),
          
          // Diagonal Speed Element
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 128,
            left: -MediaQuery.of(context).size.width * 0.25,
            child: Transform.rotate(
              angle: -0.2,
              child: Container(
                width: MediaQuery.of(context).size.width * 1.5,
                height: 256,
                color: AppTheme.primary.withOpacity(0.1),
              ),
            ),
          ),
          
          // Background Map Image
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=1200',
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black,
                      BlendMode.saturation,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Top Tech Metadata
          Positioned(
            top: 48,
            left: 48,
            child: FadeTransition(
              opacity: _animationController,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: AppTheme.textPrimary, width: 4),
                  ),
                ),
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SYSTEM STATUS',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primary,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      'OPERATIONAL // 01',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Version Badge
          Positioned(
            top: 48,
            right: 48,
            child: FadeTransition(
              opacity: _animationController,
              child: Text(
                'v2.4.0_KIN',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textMuted,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          
          // Central Branding Cluster
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Overlap Icon
                Positioned(
                  top: -80,
                  left: -60,
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(
                      Icons.near_me,
                      size: 200,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                
                // Main Logo
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Massive Kinetic Logo
                    Stack(
                      children: [
                        Text(
                          'AAGMAN',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: MediaQuery.of(context).size.width * 0.18,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.italic,
                            color: AppTheme.textPrimary,
                            letterSpacing: -4,
                            height: 0.8,
                          ),
                        ),
                        
                        // Accent Dot
                        Positioned(
                          bottom: -8,
                          right: -16,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.textPrimary,
                                  offset: Offset(4, 4),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Stylized Divider
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 4,
                      color: AppTheme.textPrimary,
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        border: Border.all(color: AppTheme.textPrimary, width: 2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Bottom Tagline & Action Area
          Positioned(
            bottom: 64,
            left: 48,
            right: 48,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeOut,
              )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Tagline
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'YOUR JOURNEY,',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                          letterSpacing: -1,
                          height: 1,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'SIMPLIFIED',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primary,
                              letterSpacing: -1,
                              height: 1,
                            ),
                          ),
                          SizedBox(width: 16),
                          Container(
                            width: 96,
                            height: 2,
                            color: AppTheme.textPrimary,
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  // Kinetic Action Button
                  GestureDetector(
                    onTap: _navigateToHome,
                    child: Stack(
                      children: [
                        // Shadow
                        Positioned(
                          left: 8,
                          top: 8,
                          child: Container(
                            width: 200,
                            height: 60,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        
                        // Button
                        Container(
                          width: 200,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            border: Border.all(color: AppTheme.textPrimary, width: 2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'INITIALIZE',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.white,
                                  letterSpacing: 2,
                                ),
                              ),
                              SizedBox(width: 16),
                              Icon(
                                Icons.arrow_forward,
                                color: AppTheme.white,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Corner Decorative Blueprint
          Positioned(
            bottom: 0,
            left: 0,
            child: Opacity(
              opacity: 0.2,
              child: CustomPaint(
                size: Size(100, 100),
                painter: CornerBlueprintPainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Blueprint Grid Painter
class BlueprintGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFC3C6D7)
      ..style = PaintingStyle.fill;

    for (double x = 0; x < size.width; x += 40) {
      for (double y = 0; y < size.height; y += 40) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Kinetic Lines Painter
class KineticLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF1A1C1C).withOpacity(0.03)
      ..style = PaintingStyle.fill;

    for (double i = 0; i < size.width + size.height; i += 80) {
      final path = Path();
      path.moveTo(i, 0);
      path.lineTo(0, i);
      path.lineTo(0, i + 40);
      path.lineTo(i + 40, 0);
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Corner Blueprint Painter
class CornerBlueprintPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF1A1C1C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // L shape
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    canvas.drawPath(path, paint);

    // Circle
    canvas.drawCircle(Offset(size.width, size.height), 10, paint);

    // Diagonal line
    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
