import 'package:bendable_slider/painter/curvered_painter.dart';
import 'package:flutter/material.dart';

class BendableSlider extends StatefulWidget {
  final void Function()? onSlideComplete;
  final String? title;
  final TextStyle? titleTextStyle;
  final bool isTitleFixed;
  final Color backgroundTrackColor;
  final List<Color>? foregroundGradiantColor;
  final double initialProgress;

  const BendableSlider({
    super.key,
    this.onSlideComplete,
    this.title,
    this.titleTextStyle,
    this.isTitleFixed = true,
    required this.backgroundTrackColor,
    this.foregroundGradiantColor,
    this.initialProgress = 0.3,
  });

  @override
  State<BendableSlider> createState() => _BendableSliderState();
}

class _BendableSliderState extends State<BendableSlider> with SingleTickerProviderStateMixin {
  double _progress = 0.3;
  bool _isCompleted = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isDragging = false;
  Offset? _startDragOffset;

  void _animateTo(double from, double to, VoidCallback? onComplete) {
    _animation = Tween<double>(begin: from, end: to).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _animationController
      ..reset()
      ..forward();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (onComplete != null) {
          onComplete();
        }
      }
    });
  }

  @override
  void initState() {
    _progress = widget.initialProgress;
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

    _animationController.addListener(() {
      setState(() {
        _progress = _animation.value;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("_progress:::$_progress");
    final double calculatedOpacity = (1 - (_progress * 2)).clamp(0.0, 1.0);

    return GestureDetector(
      onHorizontalDragStart: (details) {
        _isDragging = false;
        _startDragOffset = details.globalPosition;
      },
      onHorizontalDragUpdate: (details) {
        final box = context.findRenderObject() as RenderBox;
        final local = box.globalToLocal(details.globalPosition);

        // Activate drag only after 5 logical pixels of movement
        if (!_isDragging && _startDragOffset != null && (details.globalPosition.dx - _startDragOffset!.dx).abs() > 5) {
          _isDragging = true;
        }

        if (_isDragging) {
          final newProgress = (local.dx / box.size.width).clamp(0.0, 1.0);
          if (!_isCompleted && newProgress < 0.90) {
            setState(() {
              _progress = newProgress;
            });
          } else if (!_isCompleted && newProgress >= 0.90) {
            _isCompleted = true;
            _animateTo(newProgress, 1.0, widget.onSlideComplete);
          }
        }
      },
      onHorizontalDragEnd: (details) {
        if (_isDragging && !_isCompleted && _progress < 0.90) {
          _animateTo(_progress, widget.initialProgress, () {});
        }
        _isDragging = false;
      },

      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: BendableSliderPainter(
              progress: _progress,
              title: widget.title,
              titleTextStyle: widget.titleTextStyle,
              isTitleFixed: widget.isTitleFixed,
              backgroundTrackColor: widget.backgroundTrackColor,
              foregroundGradiantColor: widget.foregroundGradiantColor,
              hideThumbProgress: 0.25,

              /// when hide Arrow
            ),
            size: const Size(double.infinity, 120),
          ),
          if (widget.title != null && !widget.isTitleFixed && calculatedOpacity <= 0.0)
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 76),
              child: Align(
                alignment: Alignment.center,
                child: Text(widget.title ?? '', style: widget.titleTextStyle),
              ),
            ),
          if (widget.title != null && widget.isTitleFixed)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 50, bottom: 36),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Transform.rotate(
                  angle: -0.30,
                  alignment: Alignment.center,
                  child: Text(widget.title ?? '', style: widget.titleTextStyle),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
