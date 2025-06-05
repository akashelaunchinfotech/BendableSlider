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

class _BendableSliderState extends State<BendableSlider> {
  double _progress = 0.3;
  bool _isCompleted = false;

  @override
  void initState() {
    _progress = widget.initialProgress;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final box = context.findRenderObject() as RenderBox;
        final local = box.globalToLocal(details.globalPosition);
        setState(() {
          _progress = local.dx / box.size.width;
          _progress = _progress.clamp(0.0, 1.0);
        });

        if (_progress >= 0.98 && !_isCompleted) {
          _isCompleted = true;
          widget.onSlideComplete?.call();
        } else if (_progress < 1.0) {
          _isCompleted = false;
        }
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
            ),
            size: const Size(double.infinity, 120),
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
