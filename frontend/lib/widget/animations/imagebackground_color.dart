import 'package:flutter/material.dart';

class ImageAnimationGradien extends StatefulWidget {
  final String imageUrl;
  final double size;

  const ImageAnimationGradien({
    super.key,
    required this.imageUrl,
    this.size = 150.0,
  });

  @override
  State<ImageAnimationGradien> createState() => _ImageAnimationGradienState();
}

class _ImageAnimationGradienState extends State<ImageAnimationGradien>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for pulsing glow
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Glow animation for pulsing effect
    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Glowing background
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(
                      255,
                      50,
                      203,
                      217,
                    ).withOpacity(_glowAnimation.value * 0.5),
                    blurRadius: 20.0 * _glowAnimation.value,
                    spreadRadius: 5.0 * _glowAnimation.value,
                  ),
                ],
              ),
            ),

            // Profile image
            Container(
              width: widget.size - 16,
              height: widget.size - 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 2.0,
                ),
              ),
              child: ClipOval(
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 50.0,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
