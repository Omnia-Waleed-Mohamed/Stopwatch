import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const StopwatchApp());
}

class StopwatchApp extends StatelessWidget {
  const StopwatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const StopwatchScreen(),
    );
  }
}

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  Timer? _timer;
  int _elapsedMs = 0;
  bool _isRunning = false;

  void _start() {
    if (_isRunning) return;
    _isRunning = true;

    _timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      setState(() {
        _elapsedMs += 10;
      });
    });
  }

  void _stop() {
    _timer?.cancel();
    _isRunning = false;
  }

  void _reset() {
    _stop();
    setState(() {
      _elapsedMs = 0;
    });
  }

  String _formatTime() {
    final minutes = (_elapsedMs ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((_elapsedMs % 60000) ~/ 1000).toString().padLeft(2, '0');
    final ms = ((_elapsedMs % 1000) ~/ 10).toString().padLeft(2, '0');
    return '$minutes:$seconds:$ms';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Today's Challenge"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular Timer
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 220,
                height: 220,
                child: CircularProgressIndicator(
                  value: (_elapsedMs % 60000) / 60000,
                  strokeWidth: 10,
                  backgroundColor: Colors.grey.shade800,
                  valueColor: const AlwaysStoppedAnimation(
                    Color(0xFF27E0D6),
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    _formatTime(),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF27E0D6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'ELAPSED',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 50),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ControlButton(
                icon: Icons.refresh,
                label: 'Reset',
                onTap: _reset,
              ),
              _ControlButton(
                icon: _isRunning ? Icons.pause : Icons.play_arrow,
                label: _isRunning ? 'Stop' : 'Start',
                onTap: _isRunning ? _stop : _start,
                main: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool main;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.main = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: main ? 70 : 55,
            height: main ? 70 : 55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: main ? const Color(0xFF27E0D6) : Colors.grey.shade800,
            ),
            child: Icon(
              icon,
              color: main ? Colors.black : Colors.white,
              size: main ? 36 : 26,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
