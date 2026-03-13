import 'package:flutter/material.dart';

class MascotLogo extends StatelessWidget {
  final double size;
  const MascotLogo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 身体 (圆滚滚)
          Positioned(
            top: size * 0.4,
            child: Container(
              width: size * 0.5,
              height: size * 0.45,
              decoration: BoxDecoration(
                color: const Color(0xFFFF8C42),
                shape: BoxShape.ellipse,
              ),
            ),
          ),
          
          // 头部 (圆圆的脸)
          Container(
            width: size * 0.4,
            height: size * 0.4,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35),
              shape: BoxShape.circle,
            ),
          ),
          
          // 左耳朵
          Positioned(
            left: size * 0.05,
            top: size * 0.05,
            child: Container(
              width: size * 0.12,
              height: size * 0.12,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35),
                shape: BoxShape.circle,
              ),
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD7C4),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          
          // 右耳朵
          Positioned(
            right: size * 0.05,
            top: size * 0.05,
            child: Container(
              width: size * 0.12,
              height: size * 0.12,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35),
                shape: BoxShape.circle,
              ),
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD7C4),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          
          // 左眼睛
          Positioned(
            left: size * 0.12,
            top: size * 0.15,
            child: Container(
              width: size * 0.05,
              height: size * 0.05,
              decoration: const BoxDecoration(
                color: Color(0xFF2D3436),
                shape: BoxShape.circle,
              ),
              child: const Positioned(
                left: 2,
                top: 1,
                child: SizedBox(
                  width: 6,
                  height: 6,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // 右眼睛
          Positioned(
            right: size * 0.12,
            top: size * 0.15,
            child: Container(
              width: size * 0.05,
              height: size * 0.05,
              decoration: const BoxDecoration(
                color: Color(0xFF2D3436),
                shape: BoxShape.circle,
              ),
              child: const Positioned(
                left: 2,
                top: 1,
                child: SizedBox(
                  width: 6,
                  height: 6,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // 腮红
          Positioned(
            left: size * 0.08,
            top: size * 0.25,
            child: Container(
              width: size * 0.06,
              height: size * 0.06,
              decoration: BoxDecoration(
                color: const Color(0xFFFFB6C1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFB6C1).withOpacity(0.6),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: size * 0.08,
            top: size * 0.25,
            child: Container(
              width: size * 0.06,
              height: size * 0.06,
              decoration: BoxDecoration(
                color: const Color(0xFFFFB6C1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFB6C1).withOpacity(0.6),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
          ),
          
          // 鼻子
          Positioned(
            top: size * 0.22,
            child: Container(
              width: size * 0.04,
              height: size * 0.03,
              decoration: const BoxDecoration(
                color: Color(0xFF2D3436),
                shape: BoxShape.ellipse,
              ),
            ),
          ),
          
          // 嘴巴
          Positioned(
            top: size * 0.26,
            child: CustomPaint(
              size: Size(size * 0.1, size * 0.05),
              painter: MouthPainter(),
            ),
          ),
          
          // 门牙
          Positioned(
            top: size * 0.28,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: size * 0.03,
                  height: size * 0.05,
                  color: Colors.white,
                ),
                const SizedBox(width: 2),
                Container(
                  width: size * 0.03,
                  height: size * 0.05,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          
          // 左手 (抱算盘)
          Positioned(
            left: size * 0.05,
            top: size * 0.45,
            child: Container(
              width: size * 0.1,
              height: size * 0.1,
              decoration: const BoxDecoration(
                color: Color(0xFFFF6B35),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // 右手 (抱松果)
          Positioned(
            right: size * 0.1,
            top: size * 0.35,
            child: Container(
              width: size * 0.1,
              height: size * 0.1,
              decoration: const BoxDecoration(
                color: Color(0xFFFF6B35),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // 算盘
          Positioned(
            left: size * 0.02,
            top: size * 0.42,
            child: Container(
              width: size * 0.25,
              height: size * 0.18,
              decoration: BoxDecoration(
                color: const Color(0xFF8B4513),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 算盘梁
                  Container(
                    height: 3,
                    color: const Color(0xFFD2691E),
                  ),
                  // 算盘珠
                  Positioned(
                    top: size * 0.03,
                    child: Row(
                      children: List.generate(4, (i) => Padding(
                        padding: EdgeInsets.only(left: size * 0.03),
                        child: Container(
                          width: size * 0.03,
                          height: size * 0.03,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFD700),
                            shape: BoxShape.circle,
                          ),
                        ),
                      )),
                    ),
                  ),
                  Positioned(
                    top: size * 0.08,
                    child: Row(
                      children: List.generate(4, (i) => Padding(
                        padding: EdgeInsets.only(left: size * 0.03),
                        child: Container(
                          width: size * 0.03,
                          height: size * 0.03,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFD700),
                            shape: BoxShape.circle,
                          ),
                        ),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 大金色松果
          Positioned(
            right: size * 0.08,
            top: size * 0.22,
            child: Container(
              width: size * 0.18,
              height: size * 0.25,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700),
                shape: BoxShape.ellipse,
              ),
              child: Container(
                margin: EdgeInsets.all(size * 0.02),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFA500),
                  shape: BoxShape.ellipse,
                ),
              ),
            ),
          ),
          
          // 尾巴
          Positioned(
            right: 0,
            top: size * 0.45,
            child: CustomPaint(
              size: Size(size * 0.3, size * 0.35),
              painter: TailPainter(),
            ),
          ),
          
          // 爪子
          Positioned(
            bottom: size * 0.05,
            left: size * 0.1,
            child: Row(
              children: [
                Container(
                  width: size * 0.06,
                  height: size * 0.06,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF6B35),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: size * 0.06,
                  height: size * 0.06,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF6B35),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: size * 0.05,
            right: size * 0.15,
            child: Row(
              children: [
                Container(
                  width: size * 0.06,
                  height: size * 0.06,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF6B35),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: size * 0.06,
                  height: size * 0.06,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF6B35),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MouthPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2D3436)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.2)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.8,
        size.width * 0.8,
        size.height * 0.2,
      );
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF8C42)
      ..style = PaintingStyle.fill;
    
    final path = Path()
      ..moveTo(0, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.1,
        size.width,
        0,
      )
      ..quadraticBezierTo(
        size.width * 0.9,
        size.height * 0.2,
        size.width * 0.8,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.7,
        size.height * 0.8,
        size.width * 0.5,
        size.height * 0.7,
      )
      ..close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
