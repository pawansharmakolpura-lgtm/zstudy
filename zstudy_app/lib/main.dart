import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ZStudyApp());
}

class ZStudyApp extends StatelessWidget {
  const ZStudyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZStudy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4318FF)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WebViewScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4318FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: const Icon(
                Icons.school_rounded,
                size: 60,
                color: Color(0xFF4318FF),
              ),
            ),
            const SizedBox(height: 24),
            const Text('ZStudy',
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.w800,
                color: Colors.white, letterSpacing: 1.5)),
            const SizedBox(height: 8),
            const Text('Learn. Test. Grow.',
              style: TextStyle(fontSize: 16, color: Colors.white70)),
            const SizedBox(height: 60),
            const SizedBox(width: 32, height: 32,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)),
            const SizedBox(height: 40),
            const Text('Developed by',
              style: TextStyle(fontSize: 13, color: Colors.white54)),
            const SizedBox(height: 4),
            const Text('Pawan Hunter',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});
  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebViewController? _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApp();
  }

  Future<void> _loadApp() async {
    try {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0xFFF5F6FA))
        ..setNavigationDelegate(NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onWebResourceError: (error) {
            debugPrint('WebView error: ${error.description}');
          },
        ));

      // Load HTML file directly as Flutter asset
      await controller.loadFlutterAsset('assets/index.html');

      if (mounted) {
        setState(() {
          _controller = controller;
          _isLoading = true;
        });
      }
    } catch (e) {
      debugPrint('Error loading app: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: _controller == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF4318FF)),
                  SizedBox(height: 16),
                  Text('Starting ZStudy...',
                    style: TextStyle(color: Color(0xFF4318FF),
                      fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            )
          : Stack(
              children: [
                WebViewWidget(controller: _controller!),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(color: Color(0xFF4318FF)),
                  ),
              ],
            ),
      ),
    );
  }
}
