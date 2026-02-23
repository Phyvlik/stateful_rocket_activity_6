import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rocket Launch Controller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;
  bool _shownLiftoffPopup = false;

  Color _statusColor() {
    if (_counter == 0) return Colors.red;
    if (_counter <= 50) return Colors.orange;
    return Colors.green;
  }

  void _maybeShowLiftoffPopup() {
    if (_counter == 100 && !_shownLiftoffPopup) {
      _shownLiftoffPopup = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel: 'Launch Successful',
          barrierColor: Colors.black.withOpacity(0.65),
          transitionDuration: const Duration(milliseconds: 280),
          pageBuilder: (context, anim1, anim2) {
            return Center(
              child: LiftoffDialog(
                onClose: () => Navigator.pop(context),
              ),
            );
          },
          transitionBuilder: (context, anim1, anim2, child) {
            final curved = CurvedAnimation(parent: anim1, curve: Curves.easeOutBack);
            return FadeTransition(
              opacity: anim1,
              child: ScaleTransition(
                scale: curved,
                child: child,
              ),
            );
          },
        );
      });
    }
  }

  void _ignite() {
    setState(() {
      _counter = (_counter + 1).clamp(0, 100);
    });
    _maybeShowLiftoffPopup();
  }

  void _decrement() {
    setState(() {
      _counter = (_counter - 1).clamp(0, 100);
    });
    _maybeShowLiftoffPopup();
  }

  void _reset() {
    setState(() {
      _counter = 0;
      _shownLiftoffPopup = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color panelColor = _statusColor();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rocket Launch Controller'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
              decoration: BoxDecoration(
                color: panelColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _counter == 100 ? "LIFTOFF!" : '$_counter',
                style: const TextStyle(
                  fontSize: 50.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Slider(
              min: 0,
              max: 100,
              value: _counter.toDouble(),
              onChanged: (double value) {
                setState(() {
                  _counter = value.toInt().clamp(0, 100);
                });
                _maybeShowLiftoffPopup();
              },
              activeColor: Colors.blue,
              inactiveColor: Colors.red,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _ignite,
                child: const Text('Ignite'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _decrement,
                child: const Text('Decrement'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _reset,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A nicer, animated launch success popup (no external packages).
class LiftoffDialog extends StatelessWidget {
  final VoidCallback onClose;

  const LiftoffDialog({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    // Keeps it responsive across phones/tablets.
    final width = MediaQuery.of(context).size.width;
    final dialogWidth = width < 420 ? width * 0.90 : 420.0;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: dialogWidth,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0B1020),
              Color(0xFF141B36),
              Color(0xFF0B1020),
            ],
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 30,
              color: Colors.black.withOpacity(0.45),
              offset: const Offset(0, 18),
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.10),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header row with close button
            Row(
              children: [
                _chip('MISSION', Icons.shield, const Color(0xFF8AB4F8)),
                const SizedBox(width: 8),
                _chip('SUCCESS', Icons.check_circle, const Color(0xFF7EE787)),
                const Spacer(),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close, color: Colors.white70),
                  tooltip: 'Close',
                ),
              ],
            ),

            const SizedBox(height: 6),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '🚀 Launch Successful!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ),

            const SizedBox(height: 6),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'LIFTOFF achieved at max fuel (100). All systems nominal.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.25,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Animated rocket lift-off scene
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white.withOpacity(0.06),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // subtle stars
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.55,
                      child: CustomPaint(
                        painter: _StarsPainter(),
                      ),
                    ),
                  ),

                  // Rocket lift animation
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 1400),
                    curve: Curves.easeInOutCubic,
                    builder: (context, t, child) {
                      // Rocket moves up and lightly wobbles
                      final y = (1 - t) * 42.0;
                      final wobble = (t * 6.28318); // 2π
                      final rot = 0.04 * (1 - t) * (wobble.sin());

                      return Transform.translate(
                        offset: Offset(0, y),
                        child: Transform.rotate(
                          angle: rot,
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'LIFTOFF!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Icon(
                          Icons.rocket_launch,
                          size: 56,
                          color: Color(0xFF8AB4F8),
                        ),
                        const SizedBox(height: 8),
                        // “Thruster” glow
                        Container(
                          width: 26,
                          height: 18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFFFD166),
                                Color(0xFFFF6B6B),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 18,
                                color: const Color(0xFFFF6B6B).withOpacity(0.55),
                                spreadRadius: 2,
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

            const SizedBox(height: 14),

            // A "completed" progress bar for extra polish
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 1,
                minHeight: 10,
                backgroundColor: Colors.white.withOpacity(0.10),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF7EE787)),
              ),
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onClose,
                icon: const Icon(Icons.celebration),
                label: const Text('Close & Continue'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7EE787),
                  foregroundColor: const Color(0xFF0B1020),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withOpacity(0.08),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple star background painter (tiny, lightweight, looks nice).
class _StarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.25);

    // Hand-placed “stars” (no randomness so it looks stable).
    final stars = <Offset>[
      Offset(size.width * 0.12, size.height * 0.25),
      Offset(size.width * 0.22, size.height * 0.55),
      Offset(size.width * 0.35, size.height * 0.18),
      Offset(size.width * 0.48, size.height * 0.42),
      Offset(size.width * 0.62, size.height * 0.22),
      Offset(size.width * 0.74, size.height * 0.58),
      Offset(size.width * 0.86, size.height * 0.30),
      Offset(size.width * 0.80, size.height * 0.15),
      Offset(size.width * 0.15, size.height * 0.75),
      Offset(size.width * 0.55, size.height * 0.70),
    ];

    for (final s in stars) {
      canvas.drawCircle(s, 1.6, paint);
    }
    canvas.drawCircle(Offset(size.width * 0.68, size.height * 0.80), 2.2,
        paint..color = Colors.white.withOpacity(0.18));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

extension on double {
  double sin() => MathLike.sin(this);
}

/// Minimal “sin” helper without importing dart:math in the main file.
/// (Keeps everything in one file for easy copy/paste.)
class MathLike {
  static double sin(double x) {
    // Taylor approximation is fine for tiny wobble.
    // Good enough visually and avoids extra imports.
    final x3 = x * x * x;
    final x5 = x3 * x * x;
    final x7 = x5 * x * x;
    return x - (x3 / 6) + (x5 / 120) - (x7 / 5040);
  }
}