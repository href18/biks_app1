import 'dart:math' as math;

import 'package:flutter/material.dart';

const _biksNavy = Color(0xFF040D3C);
const _biksOrange = Color(0xFFF47B20);
const _panelNavy = Color(0xFF091543);
const _panelRaised = Color(0xFF101E4D);
const _panelLine = Color(0xFF35406A);

class CranePlanExamplesPage extends StatefulWidget {
  const CranePlanExamplesPage({super.key});

  @override
  State<CranePlanExamplesPage> createState() => _CranePlanExamplesPageState();
}

class _CranePlanExamplesPageState extends State<CranePlanExamplesPage> {
  double _boomLength = 32;
  double _boomAngle = 57;
  double _objectDistance = 18;
  double _objectHeight = 12;
  bool _isDrawingLocked = false;

  double get _radius =>
      _boomLength * math.cos(_boomAngle * math.pi / 180).clamp(0.0, 1.0);

  double get _tipHeight =>
      _boomLength * math.sin(_boomAngle * math.pi / 180).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kranplan')),
      backgroundColor: _biksNavy,
      body: ListView(
        physics: _isDrawingLocked
            ? const NeverScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        children: [
          _DragPlanExample(
            boomLength: _boomLength,
            boomAngle: _boomAngle,
            radius: _radius,
            tipHeight: _tipHeight,
            objectDistance: _objectDistance,
            objectHeight: _objectHeight,
            onBoomLengthChanged: (value) => setState(() {
              _boomLength = value;
            }),
            onBoomAngleChanged: (value) => setState(() {
              _boomAngle = value;
            }),
            onObjectDistanceChanged: (value) => setState(() {
              _objectDistance = value;
            }),
            onObjectHeightChanged: (value) => setState(() {
              _objectHeight = value;
            }),
            onTipDragged: (update) => setState(() {
              _boomLength = update.boomLength;
              _boomAngle = update.boomAngle;
            }),
            onObjectDragged: (update) => setState(() {
              _objectDistance = update.distance;
              _objectHeight = update.height;
            }),
            onDrawingLockChanged: (isLocked) => setState(() {
              _isDrawingLocked = isLocked;
            }),
          ),
        ],
      ),
    );
  }
}

class _DragPlanExample extends StatelessWidget {
  const _DragPlanExample({
    required this.boomLength,
    required this.boomAngle,
    required this.radius,
    required this.tipHeight,
    required this.objectDistance,
    required this.objectHeight,
    required this.onBoomLengthChanged,
    required this.onBoomAngleChanged,
    required this.onObjectDistanceChanged,
    required this.onObjectHeightChanged,
    required this.onTipDragged,
    required this.onObjectDragged,
    required this.onDrawingLockChanged,
  });

  final double boomLength;
  final double boomAngle;
  final double radius;
  final double tipHeight;
  final double objectDistance;
  final double objectHeight;
  final ValueChanged<double> onBoomLengthChanged;
  final ValueChanged<double> onBoomAngleChanged;
  final ValueChanged<double> onObjectDistanceChanged;
  final ValueChanged<double> onObjectHeightChanged;
  final ValueChanged<_PlanDragUpdate> onTipDragged;
  final ValueChanged<_ObjectDragUpdate> onObjectDragged;
  final ValueChanged<bool> onDrawingLockChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PlanDrawingCard(
          title: 'Tegn og dra',
          subtitle:
              'Ta på tegningen og dra. Alle verdier oppdateres automatisk.',
          boomLength: boomLength,
          boomAngle: boomAngle,
          objectDistance: objectDistance,
          objectHeight: objectHeight,
          showGridLabels: true,
          isInteractive: true,
          onTipDragged: onTipDragged,
          onObjectDragged: onObjectDragged,
          onInteractionLockChanged: onDrawingLockChanged,
        ),
        const SizedBox(height: 12),
        _ValueGrid(
          values: [
            _PlanValue('Bomlengde', boomLength, 'm'),
            _PlanValue('Bomvinkel', boomAngle, '°'),
            _PlanValue('Radius', radius, 'm'),
            _PlanValue('Tupphøyde', tipHeight, 'm'),
            _PlanValue('Objektavstand', objectDistance, 'm'),
            _PlanValue('Objekthøyde', objectHeight, 'm'),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          color: _panelNavy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: _panelLine),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _LargeSlider(
                  label: 'Bomlengde',
                  value: boomLength,
                  min: 8,
                  max: 48,
                  unit: 'm',
                  onChanged: onBoomLengthChanged,
                ),
                _LargeSlider(
                  label: 'Bomvinkel',
                  value: boomAngle,
                  min: 15,
                  max: 75,
                  unit: '°',
                  onChanged: onBoomAngleChanged,
                ),
                _LargeSlider(
                  label: 'Objektavstand',
                  value: objectDistance,
                  min: 6,
                  max: 40,
                  unit: 'm',
                  onChanged: onObjectDistanceChanged,
                ),
                _LargeSlider(
                  label: 'Objekthøyde',
                  value: objectHeight,
                  min: 2,
                  max: 24,
                  unit: 'm',
                  onChanged: onObjectHeightChanged,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PlanDrawingCard extends StatefulWidget {
  const _PlanDrawingCard({
    required this.title,
    required this.subtitle,
    required this.boomLength,
    required this.boomAngle,
    required this.objectDistance,
    required this.objectHeight,
    required this.showGridLabels,
    this.isInteractive = false,
    this.onTipDragged,
    this.onObjectDragged,
    this.onInteractionLockChanged,
  });

  final String title;
  final String subtitle;
  final double boomLength;
  final double boomAngle;
  final double objectDistance;
  final double objectHeight;
  final bool showGridLabels;
  final bool isInteractive;
  final ValueChanged<_PlanDragUpdate>? onTipDragged;
  final ValueChanged<_ObjectDragUpdate>? onObjectDragged;
  final ValueChanged<bool>? onInteractionLockChanged;

  @override
  State<_PlanDrawingCard> createState() => _PlanDrawingCardState();
}

class _PlanDrawingCardState extends State<_PlanDrawingCard> {
  _DragHandle? _activeHandle;
  int? _activePointer;

  @override
  void dispose() {
    if (_activePointer != null) {
      widget.onInteractionLockChanged?.call(false);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: _panelNavy,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: _panelLine, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 13),
              color: _biksNavy,
              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _biksOrange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title.toUpperCase(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withAlpha(205),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'BIKS',
                    style: TextStyle(
                      color: _biksOrange,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            AspectRatio(
              aspectRatio: 0.78,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size = Size(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    );
                    return Listener(
                      behavior: HitTestBehavior.opaque,
                      onPointerDown: widget.isInteractive
                          ? (event) => _startDrag(
                                size,
                                event.localPosition,
                                event.pointer,
                              )
                          : null,
                      onPointerMove: widget.isInteractive
                          ? (event) => _updateDrag(
                                size,
                                event.localPosition,
                                event.pointer,
                              )
                          : null,
                      onPointerUp: widget.isInteractive
                          ? (event) => _finishDrag(event.pointer)
                          : null,
                      onPointerCancel: widget.isInteractive
                          ? (event) => _finishDrag(event.pointer)
                          : null,
                      child: CustomPaint(
                        painter: _CranePlanPainter(
                          boomLength: widget.boomLength,
                          boomAngle: widget.boomAngle,
                          objectDistance: widget.objectDistance,
                          objectHeight: widget.objectHeight,
                          showGridLabels: widget.showGridLabels,
                          isInteractive: widget.isInteractive,
                          activeHandle: _activeHandle,
                          theme: theme,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (widget.isInteractive) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.touch_app_outlined,
                    size: 20,
                    color: _biksOrange,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _activeHandle == null
                          ? 'Ta hvor som helst på tegningen: øvre felt styrer bommen, '
                              'hinderet styrer objektet.'
                          : 'Låst på ${_activeHandle!.label}. Slipp fingeren for å velge noe annet.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withAlpha(190),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _startDrag(Size size, Offset localPosition, int pointer) {
    if (_activePointer != null) return;

    final geometry = _CranePlanGeometry(size);
    final boomTip = geometry.boomTip(widget.boomLength, widget.boomAngle);
    final origin = geometry.origin.translate(8, -8);
    final objectRect = geometry.objectRect(
      widget.objectDistance,
      widget.objectHeight,
    );
    final objectCorner = objectRect.topLeft;

    final boomDistance = (localPosition - boomTip).distance;
    final objectDistance = (localPosition - objectCorner).distance;
    final boomLineDistance = _distanceToSegment(localPosition, origin, boomTip);
    final inflatedObject = objectRect.inflate(64);

    final _DragHandle handle;
    if (inflatedObject.contains(localPosition) || objectDistance <= 92) {
      handle = _DragHandle.objectCorner;
    } else if (boomDistance <= 108 ||
        boomLineDistance <= 68 ||
        localPosition.dy < geometry.origin.dy - 24) {
      handle = _DragHandle.boomTip;
    } else {
      handle = boomDistance <= objectDistance
          ? _DragHandle.boomTip
          : _DragHandle.objectCorner;
    }

    setState(() {
      _activeHandle = handle;
      _activePointer = pointer;
    });
    widget.onInteractionLockChanged?.call(true);
    _updateDrag(size, localPosition, pointer);
  }

  void _updateDrag(Size size, Offset localPosition, int pointer) {
    if (_activePointer != pointer) return;

    final geometry = _CranePlanGeometry(size);
    switch (_activeHandle) {
      case _DragHandle.boomTip:
        widget.onTipDragged?.call(
          geometry.boomUpdateFromPosition(localPosition),
        );
      case _DragHandle.objectCorner:
        widget.onObjectDragged?.call(
          geometry.objectUpdateFromPosition(localPosition),
        );
      case null:
        break;
    }
  }

  void _finishDrag(int pointer) {
    if (_activePointer != pointer) return;

    if (_activeHandle != null || _activePointer != null) {
      setState(() {
        _activeHandle = null;
        _activePointer = null;
      });
      widget.onInteractionLockChanged?.call(false);
    }
  }

  double _distanceToSegment(Offset point, Offset start, Offset end) {
    final segment = end - start;
    final segmentLengthSquared =
        segment.dx * segment.dx + segment.dy * segment.dy;
    if (segmentLengthSquared == 0) return (point - start).distance;

    final t = (((point.dx - start.dx) * segment.dx +
                (point.dy - start.dy) * segment.dy) /
            segmentLengthSquared)
        .clamp(0.0, 1.0);
    final projection = Offset(
      start.dx + segment.dx * t,
      start.dy + segment.dy * t,
    );
    return (point - projection).distance;
  }
}

enum _DragHandle { boomTip, objectCorner }

extension _DragHandleLabel on _DragHandle {
  String get label {
    switch (this) {
      case _DragHandle.boomTip:
        return 'bom';
      case _DragHandle.objectCorner:
        return 'objekt';
    }
  }
}

class _CranePlanPainter extends CustomPainter {
  const _CranePlanPainter({
    required this.boomLength,
    required this.boomAngle,
    required this.objectDistance,
    required this.objectHeight,
    required this.showGridLabels,
    required this.isInteractive,
    required this.activeHandle,
    required this.theme,
  });

  final double boomLength;
  final double boomAngle;
  final double objectDistance;
  final double objectHeight;
  final bool showGridLabels;
  final bool isInteractive;
  final _DragHandle? activeHandle;
  final ThemeData theme;

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = _panelNavy;
    canvas.drawRect(Offset.zero & size, background);

    final geometry = _CranePlanGeometry(size);
    final chart = geometry.chart;
    final origin = geometry.origin;

    final guidePaint = Paint()
      ..color = Colors.white.withAlpha(22)
      ..strokeWidth = 1;
    for (var i = 1; i <= 4; i++) {
      final y = origin.dy - i * (chart.height - 30) / 5;
      canvas.drawLine(
          Offset(chart.left, y), Offset(chart.right, y), guidePaint);
    }

    final radiusPaint = Paint()
      ..color = _biksOrange.withAlpha(35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (final radius in [12.0, 24.0, 36.0, 48.0]) {
      final edge = geometry.point(radius, 0).dx - origin.dx;
      canvas.drawArc(
        Rect.fromCircle(center: origin, radius: edge),
        -math.pi / 2,
        math.pi / 2,
        false,
        radiusPaint,
      );
    }

    final axisPaint = Paint()
      ..color = Colors.white.withAlpha(90)
      ..strokeWidth = 2.4;
    canvas.drawLine(origin, Offset(chart.right, origin.dy), axisPaint);

    final groundRect = Rect.fromLTRB(
      chart.left,
      origin.dy + 3,
      chart.right,
      origin.dy + 15,
    );
    canvas.drawRect(groundRect, Paint()..color = const Color(0xFF020719));
    canvas.save();
    canvas.clipRect(groundRect);
    final stripePaint = Paint()
      ..color = _biksOrange
      ..strokeWidth = 5;
    for (double x = chart.left - 20; x < chart.right + 20; x += 22) {
      canvas.drawLine(
        Offset(x, groundRect.bottom),
        Offset(x + 15, groundRect.top),
        stripePaint,
      );
    }
    canvas.restore();

    final objectRect = geometry.objectRect(objectDistance, objectHeight);
    final objectLeft = objectRect.left;
    final objectTop = objectRect.top;
    canvas.drawRect(
      objectRect,
      Paint()..color = const Color(0xFF5D688F),
    );
    canvas.drawRect(
      Rect.fromLTWH(objectLeft + 7, objectTop + 8, 5, 5),
      Paint()..color = _biksOrange,
    );
    if (isInteractive) {
      final objectHandle = Offset(objectLeft, objectTop);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          objectRect
              .inflate(activeHandle == _DragHandle.objectCorner ? 20 : 14),
          const Radius.circular(12),
        ),
        Paint()
          ..color = activeHandle == _DragHandle.objectCorner
              ? Colors.white.withAlpha(32)
              : Colors.white.withAlpha(13),
      );
      canvas.drawCircle(
        objectHandle,
        activeHandle == _DragHandle.objectCorner ? 40 : 30,
        Paint()..color = Colors.white.withAlpha(38),
      );
      canvas.drawCircle(
        objectHandle,
        activeHandle == _DragHandle.objectCorner ? 17 : 12,
        Paint()..color = Colors.white,
      );
      canvas.drawCircle(
        objectHandle,
        activeHandle == _DragHandle.objectCorner ? 40 : 32,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    final boomEnd = geometry.boomTip(boomLength, boomAngle);
    final boomPaint = Paint()
      ..color = _biksOrange
      ..strokeWidth = activeHandle == _DragHandle.boomTip ? 13 : 10
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(origin.translate(8, -8), boomEnd, boomPaint);
    if (isInteractive) {
      canvas.drawLine(
        origin.translate(8, -8),
        boomEnd,
        Paint()
          ..color = _biksOrange.withAlpha(28)
          ..strokeWidth = 42
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawLine(origin.translate(8, -8), boomEnd, boomPaint);
    }
    canvas.drawCircle(
      boomEnd,
      isInteractive
          ? activeHandle == _DragHandle.boomTip
              ? 44
              : 32
          : 5,
      Paint()..color = isInteractive ? _biksOrange.withAlpha(55) : _biksOrange,
    );
    canvas.drawCircle(boomEnd, 15, Paint()..color = _biksOrange);
    if (isInteractive) {
      canvas.drawCircle(
        boomEnd,
        activeHandle == _DragHandle.boomTip ? 44 : 34,
        Paint()
          ..color = _biksOrange
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    final cranePaint = Paint()..color = const Color(0xFFCAD0E3);
    final wheelPaint = Paint()..color = const Color(0xFF1C1F24);
    final base = Rect.fromLTWH(origin.dx - 36, origin.dy - 10, 70, 13);
    canvas.drawRRect(
      RRect.fromRectAndRadius(base, const Radius.circular(3)),
      cranePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(origin.dx - 18, origin.dy - 46, 14, 40),
      cranePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(origin.dx - 16, origin.dy - 42, 10, 12),
      Paint()..color = _biksOrange,
    );
    canvas.drawCircle(Offset(origin.dx - 20, origin.dy + 7), 7, wheelPaint);
    canvas.drawCircle(Offset(origin.dx + 22, origin.dy + 7), 7, wheelPaint);
    canvas.drawCircle(origin.translate(8, -8), 7, Paint()..color = _biksOrange);

    final labelStyle = TextStyle(
      color: Colors.white,
      fontSize: showGridLabels ? 11 : 13,
      fontWeight: FontWeight.w800,
    );
    _paintText(
      canvas,
      '${boomLength.toStringAsFixed(0)} m',
      boomEnd.translate(isInteractive ? -34 : -18, isInteractive ? -42 : -26),
      labelStyle,
    );
    if (isInteractive) {
      _paintText(
        canvas,
        'Bom',
        boomEnd.translate(-11, 22),
        labelStyle.copyWith(
          color: _biksOrange,
          fontSize: 12,
        ),
      );
      _paintText(
        canvas,
        'Objekt',
        Offset(objectLeft + 12, objectTop - 20),
        labelStyle.copyWith(
          color: Colors.white,
          fontSize: 12,
        ),
      );
    }
    _paintText(
      canvas,
      '${objectDistance.toStringAsFixed(0)} m',
      Offset(objectLeft, origin.dy + 12),
      labelStyle.copyWith(color: Colors.white),
    );
    if (showGridLabels) {
      _paintText(canvas, '0', origin.translate(-4, 14), labelStyle);
      _paintText(
          canvas, 'm', Offset(chart.right - 6, origin.dy + 14), labelStyle);
    }
  }

  void _paintText(Canvas canvas, String text, Offset offset, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(_CranePlanPainter oldDelegate) {
    return oldDelegate.boomLength != boomLength ||
        oldDelegate.boomAngle != boomAngle ||
        oldDelegate.objectDistance != objectDistance ||
        oldDelegate.objectHeight != objectHeight ||
        oldDelegate.showGridLabels != showGridLabels ||
        oldDelegate.isInteractive != isInteractive ||
        oldDelegate.activeHandle != activeHandle;
  }
}

class _CranePlanGeometry {
  _CranePlanGeometry(Size size)
      : chart = Rect.fromLTWH(
          20,
          16,
          size.width - 36,
          size.height - 58,
        ) {
    origin = Offset(chart.left + 38, chart.bottom - 20);
  }

  static const maxX = 52.0;
  static const maxY = 50.0;

  final Rect chart;
  late final Offset origin;

  Offset point(double x, double y) {
    return Offset(
      origin.dx + (x / maxX) * (chart.width - 44),
      origin.dy - (y / maxY) * (chart.height - 30),
    );
  }

  Rect objectRect(double objectDistance, double objectHeight) {
    final left = point(objectDistance, 0).dx;
    final top = point(objectDistance, objectHeight).dy;
    final right = point(objectDistance + 12, 0).dx;
    return Rect.fromLTRB(left, top, right, origin.dy);
  }

  Offset boomTip(double boomLength, double boomAngle) {
    final radians = boomAngle * math.pi / 180;
    return point(
      boomLength * math.cos(radians),
      boomLength * math.sin(radians),
    );
  }

  _PlanDragUpdate boomUpdateFromPosition(Offset position) {
    final usableWidth = chart.width - 44;
    final usableHeight = chart.height - 30;
    final xMeters = ((position.dx - origin.dx) / usableWidth * maxX)
        .clamp(2.0, maxX)
        .toDouble();
    final yMeters = ((origin.dy - position.dy) / usableHeight * maxY)
        .clamp(2.0, maxY)
        .toDouble();
    final length = math
        .sqrt(xMeters * xMeters + yMeters * yMeters)
        .clamp(8.0, 48.0)
        .toDouble();
    final angle = (math.atan2(yMeters, xMeters) * 180 / math.pi)
        .clamp(15.0, 75.0)
        .toDouble();
    return _PlanDragUpdate(boomLength: length, boomAngle: angle);
  }

  _ObjectDragUpdate objectUpdateFromPosition(Offset position) {
    final usableWidth = chart.width - 44;
    final usableHeight = chart.height - 30;
    final distance = ((position.dx - origin.dx) / usableWidth * maxX)
        .clamp(6.0, 40.0)
        .toDouble();
    final height = ((origin.dy - position.dy) / usableHeight * maxY)
        .clamp(2.0, 24.0)
        .toDouble();
    return _ObjectDragUpdate(distance: distance, height: height);
  }
}

class _PlanDragUpdate {
  const _PlanDragUpdate({
    required this.boomLength,
    required this.boomAngle,
  });

  final double boomLength;
  final double boomAngle;
}

class _ObjectDragUpdate {
  const _ObjectDragUpdate({
    required this.distance,
    required this.height,
  });

  final double distance;
  final double height;
}

class _PlanValue {
  const _PlanValue(this.label, this.value, this.unit);

  final String label;
  final double value;
  final String unit;
}

class _ValueGrid extends StatelessWidget {
  const _ValueGrid({required this.values});

  final List<_PlanValue> values;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: values.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.55,
      ),
      itemBuilder: (context, index) {
        final value = values[index];
        return Card(
          elevation: 0,
          color: index.isEven ? _panelRaised : _panelNavy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: index.isEven ? _panelLine : _biksOrange.withAlpha(130),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withAlpha(180),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _format(value.value, value.unit),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: index.isEven ? _biksOrange : Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LargeSlider extends StatelessWidget {
  const _LargeSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final String unit;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white.withAlpha(210),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                _format(value, unit),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: _biksOrange,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _biksOrange,
              inactiveTrackColor: _panelLine,
              thumbColor: _biksOrange,
              overlayColor: _biksOrange.withAlpha(35),
              valueIndicatorColor: _biksOrange,
              valueIndicatorTextStyle: const TextStyle(
                color: _biksNavy,
                fontWeight: FontWeight.w800,
              ),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: (max - min).round(),
              label: _format(value, unit),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

String _format(double value, String unit) {
  if (unit == '°') {
    return '${value.toStringAsFixed(0)}$unit';
  }
  return '${value.toStringAsFixed(1)} $unit';
}
