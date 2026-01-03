import 'dart:ui';
import 'package:flutter/material.dart';

class ModernBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const ModernBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _icons = [
    Icons.home_rounded,
    Icons.explore_rounded,
    Icons.person_rounded,
    Icons.settings_rounded,
  ];

  static const double _barHeight = 90.0;
  static const double _circleDiameter = 78.0;
  static const double _notchPadding = 4.0;

  static double get _circleRadius => _circleDiameter / 2;
  static double get _notchRise => _circleRadius + 8.0;
  static double get _notchWidth => _circleDiameter + (_notchPadding * 2);

  @override
  Widget build(BuildContext context) {
    final circleCenter = _circleCenter(currentIndex, context);
    final circleLeft = circleCenter - (_circleDiameter / 2);

    final circleBottom = _barHeight - _notchRise;

    return SizedBox(
      height: 132,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: NavBarPainter(
                circleX: circleCenter,
                notchWidth: _notchWidth,
                notchRise: _notchRise,
              ),
              child: Container(height: _barHeight),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: NavBarClipper(
                circleX: circleCenter,
                notchWidth: _notchWidth,
                notchRise: _notchRise,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  height: _barHeight,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF686A70),
                        Color(0xFF6C6E75),
                        Color(0xFF744B4D),
                      ],
                      stops: [0.0, 0.6, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.28),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 22,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_icons.length, (i) {
                final isActive = i == currentIndex;
                return GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isActive ? 0.0 : 0.9,
                    child: Icon(
                      _icons[i],
                      size: 30,
                      color: const Color(0xFFBAC4DA),
                    ),
                  ),
                );
              }),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutBack,
            bottom: circleBottom,
            left: circleLeft,
            child: Container(
              height: _circleDiameter,
              width: _circleDiameter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF3A3638), Color(0xFF1C191D)],
                ),
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.65),
                  width: 2.4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.55),
                    blurRadius: 18,
                    offset: const Offset(0, 9),
                  ),
                ],
              ),
              child: Icon(
                _icons[currentIndex],
                size: 32,
                color: const Color(0xFFD82626),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _circleCenter(int index, BuildContext ctx) {
    final w = MediaQuery.of(ctx).size.width;
    final segment = w / _icons.length;
    return (segment * index) + (segment / 2);
  }
}

class NavBarPainter extends CustomPainter {
  final double circleX;
  final double notchWidth;
  final double notchRise;

  const NavBarPainter({
    required this.circleX,
    required this.notchWidth,
    required this.notchRise,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF7B7D84), Color(0xFF6E7077), Color(0xFF5B4345)],
        stops: [0.0, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(_buildPath(size), paint);
  }

  Path _buildPath(Size size) {
    const corner = 32.0;
    final inset = 10.0;
    final maxLeft = size.width - inset - notchWidth;
    final left = (circleX - (notchWidth / 2)).clamp(
      inset,
      maxLeft > inset ? maxLeft : inset,
    );
    final right = left + notchWidth;

    final controlOffset = notchWidth * 0.24;

    final path = Path()
      ..moveTo(corner, 0)
      ..lineTo(left, 0)
      ..cubicTo(
        left + controlOffset,
        -notchRise,
        right - controlOffset,
        -notchRise,
        right,
        0,
      )
      ..lineTo(size.width - corner, 0)
      ..quadraticBezierTo(size.width, 0, size.width, corner)
      ..lineTo(size.width, size.height - corner)
      ..quadraticBezierTo(
        size.width,
        size.height,
        size.width - corner,
        size.height,
      )
      ..lineTo(corner, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - corner)
      ..lineTo(0, corner)
      ..quadraticBezierTo(0, 0, corner, 0)
      ..close();

    return path;
  }

  @override
  bool shouldRepaint(covariant NavBarPainter oldDelegate) {
    return circleX != oldDelegate.circleX ||
        notchWidth != oldDelegate.notchWidth ||
        notchRise != oldDelegate.notchRise;
  }
}

class NavBarClipper extends CustomClipper<Path> {
  final double circleX;
  final double notchWidth;
  final double notchRise;

  const NavBarClipper({
    required this.circleX,
    required this.notchWidth,
    required this.notchRise,
  });

  @override
  Path getClip(Size size) {
    const corner = 28.0;
    final inset = 10.0;
    final maxLeft = size.width - inset - notchWidth;
    final left = (circleX - (notchWidth / 2)).clamp(
      inset,
      maxLeft > inset ? maxLeft : inset,
    );
    final right = left + notchWidth;

    final controlOffset = notchWidth * 0.24;

    return Path()
      ..moveTo(corner, 0)
      ..lineTo(left, 0)
      ..cubicTo(
        left + controlOffset,
        -notchRise,
        right - controlOffset,
        -notchRise,
        right,
        0,
      )
      ..lineTo(size.width - corner, 0)
      ..quadraticBezierTo(size.width, 0, size.width, corner)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, corner)
      ..quadraticBezierTo(0, 0, corner, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant NavBarClipper oldClipper) {
    return circleX != oldClipper.circleX ||
        notchWidth != oldClipper.notchWidth ||
        notchRise != oldClipper.notchRise;
  }
}
