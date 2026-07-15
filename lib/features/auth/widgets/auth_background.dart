import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../generated/assets.dart';

/// Decorative wavy mesh pattern for auth gradient backgrounds.
class AuthWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (var i = 0; i < 8; i++) {
      final path = Path();
      final startY = size.height * 0.05 + i * 18;
      path.moveTo(0, startY);
      for (var x = 0.0; x <= size.width; x += 20) {
        path.quadraticBezierTo(
          x + 10,
          startY + (i.isEven ? 12 : -12),
          x + 20,
          startY,
        );
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AuthLogo extends StatelessWidget {
  final double size;
  const AuthLogo({super.key, this.size = 72});

  @override
  Widget build(BuildContext context) {
    final logoSize = context.w(size);
    return Container(
      width: logoSize,
      height: logoSize,
      decoration: const BoxDecoration(
        color: AppColors.textWhite,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.handshake_rounded,
        size: logoSize * 0.5,
        color: AppColors.authPurple,
      ),
    );
  }
}

class AuthGradientBackground extends StatelessWidget {
  final Widget? child;
  const AuthGradientBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.authGradient),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppAssets.bgCommon,fit: BoxFit.cover,),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}
