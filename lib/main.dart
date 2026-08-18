// main.dart
//
// A single-file Flutter "hub" app that showcases two web-based medical
// quiz games and launches each inside an in-app WebView.
//
// Visual direction: dark clinical / "scan" aesthetic, matched to the
// color palette of the existing GI Physiology game
// (https://edu-vocabulary-builder-valle-gi-phy.vercel.app):
//   - Deep navy background (#101823) and sidebar-dark (#0D131C)
//   - Slightly lighter navy cards (#19222E) with subtle borders (#2D3643)
//   - Teal/cyan primary accent (#2EACB8), like an ultrasound / scan glow
//   - Off-white foreground text (#E6EBEF), muted blue-gray secondary text
//   - Red destructive/error accent (#EF4343)
//   - Faint glowing teal anatomical line art (ribcage, spine) rendered
//     with CustomPainter — no external image assets required.
//
// Dependencies needed in pubspec.yaml (see bottom of this file / chat
// message for the full snippet):
//   webview_flutter: ^4.9.0
//
// EDIT ME: update the `games` list below with your real titles,
// descriptions, and URLs.

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const AnatomyHubApp());
}

// ---------------------------------------------------------------------
// THEME — colors pulled from the reference site's CSS custom properties
// ---------------------------------------------------------------------

class AnatomyColors {
  static const background = Color(0xFF101823); // --background
  static const sidebarDark = Color(0xFF0D131C); // --sidebar
  static const card = Color(0xFF19222E); // --card
  static const border = Color(0xFF2D3643); // --border
  static const primaryTeal = Color(0xFF2EACB8); // --primary
  static const accentTeal = Color(0xFF2E959E); // --accent
  static const foreground = Color(0xFFE6EBEF); // --foreground
  static const mutedForeground = Color(0xFF7B899D); // --muted-foreground
  static const destructive = Color(0xFFEF4343); // --destructive
  static const glowLine = Color(0x552EACB8); // faint teal line-art glow
}

ThemeData buildAnatomyTheme() {
  final base = ThemeData.dark();
  return base.copyWith(
    scaffoldBackgroundColor: AnatomyColors.background,
    colorScheme: base.colorScheme.copyWith(
      brightness: Brightness.dark,
      primary: AnatomyColors.primaryTeal,
      secondary: AnatomyColors.accentTeal,
      surface: AnatomyColors.card,
      error: AnatomyColors.destructive,
      onPrimary: AnatomyColors.sidebarDark,
      onSurface: AnatomyColors.foreground,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AnatomyColors.background,
      foregroundColor: AnatomyColors.foreground,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AnatomyColors.foreground,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 3,
      ),
    ),
    textTheme: base.textTheme
        .apply(
          bodyColor: AnatomyColors.foreground,
          displayColor: AnatomyColors.foreground,
        )
        .copyWith(
          headlineMedium: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AnatomyColors.foreground,
          ),
          titleLarge: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: AnatomyColors.foreground,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            height: 1.4,
            color: AnatomyColors.mutedForeground,
          ),
        ),
  );
}

// ---------------------------------------------------------------------
// APP ROOT
// ---------------------------------------------------------------------

class AnatomyHubApp extends StatelessWidget {
  const AnatomyHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GTArcade',
      debugShowCheckedModeBanner: false,
      theme: buildAnatomyTheme(),
      home: const HubScreen(),
    );
  }
}

// ---------------------------------------------------------------------
// GAME MODEL — EDIT THIS LIST WITH YOUR REAL GAMES
// ---------------------------------------------------------------------

class GameInfo {
  final String title;
  final String description;
  final String url;
  final String imageAsset;

  const GameInfo({
    required this.title,
    required this.description,
    required this.url,
    required this.imageAsset,
  });
}

const List<GameInfo> games = [
  GameInfo(
    title: 'TGI Quest',
    description: 'TGI Quest',
    url: 'https://edu-vocabulary-builder-valle-gi-phy.vercel.app', // EDIT ME
    imageAsset: 'assets/images/tgi_quest.png',
  ),
  GameInfo(
    title: 'Defesa Imune',
    description: 'Defesa Imune',
    url: 'https://web-game-maker--chatgptdarapazi.replit.app', // EDIT ME
    imageAsset: 'assets/images/defesa_imune.png',
  ),
  GameInfo(
    title: 'Missão Néfron',
    description: 'Missão Néfron',
    url: 'https://game-builder--vallemateus.replit.app', // EDIT ME
    imageAsset: 'assets/images/missao_nefron.png',
  ),
];

// ---------------------------------------------------------------------
// HUB SCREEN
// ---------------------------------------------------------------------

class HubScreen extends StatelessWidget {
  const HubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GTArcade')),
      body: Stack(
        children: [
          // Decorative faint anatomical line art background
          Positioned.fill(
            child: CustomPaint(painter: _AnatomyLineArtPainter()),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                const _HubHeader(),
                const SizedBox(height: 28),
                for (final game in games) ...[
                  GameCard(game: game),
                  const SizedBox(height: 18),
                ],
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'Monitoria GT2 2026.2-2027.2',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AnatomyColors.mutedForeground,
              fontSize: 12,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }
}

class _HubHeader extends StatelessWidget {
  const _HubHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            _DividerDot(),
            SizedBox(width: 8),
            Expanded(child: Divider(color: AnatomyColors.border, thickness: 1)),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'Escolha seu módulo:',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 6),
        Text(
          '3 games sobre Fisiologia',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AnatomyColors.foreground.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _DividerDot extends StatelessWidget {
  const _DividerDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AnatomyColors.primaryTeal,
        shape: BoxShape.circle,
      ),
    );
  }
}

// ---------------------------------------------------------------------
// GAME CARD
// ---------------------------------------------------------------------

class GameCard extends StatelessWidget {
  final GameInfo game;
  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AnatomyColors.card,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => GameWebViewScreen(game: game)),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AnatomyColors.border, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AnatomyColors.sidebarDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AnatomyColors.primaryTeal.withValues(alpha: 0.4),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AnatomyColors.primaryTeal.withValues(alpha: 0.12),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    game.imageAsset,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    // const SizedBox(height: 4),
                    // Text(
                    //   game.description,
                    //   style: Theme.of(context).textTheme.bodyMedium,
                    // ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AnatomyColors.accentTeal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------
// WEBVIEW SCREEN
// ---------------------------------------------------------------------

class GameWebViewScreen extends StatefulWidget {
  final GameInfo game;
  const GameWebViewScreen({super.key, required this.game});

  @override
  State<GameWebViewScreen> createState() => _GameWebViewScreenState();
}

class _GameWebViewScreenState extends State<GameWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AnatomyColors.background)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() {
            _isLoading = true;
            _hasError = false;
          }),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onWebResourceError: (_) => setState(() {
            _isLoading = false;
            _hasError = true;
          }),
        ),
      )
      ..loadRequest(Uri.parse(widget.game.url));
  }

  Future<bool> _handleBack() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false; // stay on this screen, just navigate the webview back
    }
    return true; // no webview history left, pop the route
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (await _handleBack()) {
          if (context.mounted) Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.game.title.toUpperCase()),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _handleBack()) {
                if (context.mounted) Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _controller.reload(),
            ),
          ],
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              Container(
                color: AnatomyColors.background,
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: AnatomyColors.primaryTeal,
                      ),
                      SizedBox(height: 14),
                      Text(
                        'Loading module…',
                        style: TextStyle(color: AnatomyColors.foreground),
                      ),
                    ],
                  ),
                ),
              ),
            if (_hasError)
              Container(
                color: AnatomyColors.background,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AnatomyColors.destructive,
                        size: 40,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Couldn't load this module.",
                        style: TextStyle(color: AnatomyColors.foreground),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AnatomyColors.primaryTeal,
                          foregroundColor: AnatomyColors.sidebarDark,
                        ),
                        onPressed: () => _controller.reload(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------
// DECORATIVE ANATOMICAL LINE ART (rib cage / spine motif)
// Pure vector art, no external assets, drawn very faintly behind content.
// ---------------------------------------------------------------------

class _AnatomyLineArtPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AnatomyColors.glowLine
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final w = size.width;
    final h = size.height;

    // Spine: a vertical dashed-ish wavy line down the right edge
    final spinePath = Path();
    final spineX = w * 0.92;
    spinePath.moveTo(spineX, h * 0.05);
    for (double y = h * 0.05; y < h * 0.95; y += 24) {
      spinePath.quadraticBezierTo(spineX + 6, y + 12, spineX, y + 24);
    }
    canvas.drawPath(spinePath, paint);

    // Small vertebra ticks
    for (double y = h * 0.06; y < h * 0.94; y += 24) {
      canvas.drawLine(Offset(spineX - 6, y), Offset(spineX + 6, y), paint);
    }

    // Rib-cage-like arcs in the top-left corner, very faint
    final ribPaint = Paint()
      ..color = AnatomyColors.glowLine.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 0; i < 5; i++) {
      final rect = Rect.fromCenter(
        center: Offset(-20, h * 0.02 + i * 22),
        width: 160 + i * 10,
        height: 60,
      );
      canvas.drawArc(rect, -0.9, 1.8, false, ribPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
