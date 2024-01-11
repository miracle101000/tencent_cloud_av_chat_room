import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

class GiftSpecialEffectPlayerController extends ChangeNotifier {
  String url = "";
  bool isPlaying = false;
  play({
    String url = "",
  }) {
    this.url = url;
    notifyListeners();
  }
}

class GiftSpecialEffectPlayer extends StatefulWidget {
  // const GiftSpecialEffectPlayer({super.key, required this.controller});

  final GiftSpecialEffectPlayerController controller;

  const GiftSpecialEffectPlayer({Key? key, required this.controller})
      : super(key: key);

  @override
  State<GiftSpecialEffectPlayer> createState() =>
      _GiftSpecialEffectPlayerState();
}

class _GiftSpecialEffectPlayerState extends State<GiftSpecialEffectPlayer>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late GiftSpecialEffectPlayerController _giftSpecialEffectPlayerController;
  late SVGAAnimationController _svgaAnimationController;
  bool _isLocal = false;
  String _url = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _svgaAnimationController = SVGAAnimationController(vsync: this);
    _giftSpecialEffectPlayerController = widget.controller;
    _giftSpecialEffectPlayerController.addListener(_handler);
  }

  @override
  void didUpdateWidget(covariant GiftSpecialEffectPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_giftSpecialEffectPlayerController != widget.controller) {
      _giftSpecialEffectPlayerController.removeListener(_handler);
      _giftSpecialEffectPlayerController = widget.controller;
      _giftSpecialEffectPlayerController.addListener(_handler);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _svgaAnimationController.dispose();
    _giftSpecialEffectPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_url.isEmpty) {
      return Container();
    }
    final isSvga = _url.contains("svga");
    if (isSvga) {
      return Container(
        color: Colors.transparent,
        child: SVGAImage(_svgaAnimationController),
      );
    }

    if (_isLocal) {
      return Lottie.asset(_url,
          controller: _animationController,
          errorBuilder: (context, error, stackTrace) {
            debugPrint("error: ${error.toString()} ");
            widget.controller.isPlaying = false;
            return Container();
          },
          key: UniqueKey(),
          onLoaded: (composition) {
            _animationController
              ..duration = const Duration(milliseconds: 2000)
              ..forward().whenComplete(() {
                widget.controller.isPlaying = false;
                setState(() {
                  _url = "";
                });
              });
          });
    } else {
      return Lottie.network(_url,
          errorBuilder: (context, error, stackTrace) {
            debugPrint("error: ${error.toString()} ");
            widget.controller.isPlaying = false;
            return Container();
          },
          controller: _animationController,
          key: UniqueKey(),
          onLoaded: (composition) {
            _animationController
              ..duration = composition.duration
              ..forward().whenComplete(() {
                widget.controller.isPlaying = false;
                setState(() {
                  _url = "";
                });
              });
          });
    }
  }

  _handler() async {
    _url = widget.controller.url;
    _animationController.reset();
    _isLocal = !_url.startsWith("http");
    widget.controller.isPlaying = true;

    final isSvga = _url.contains("svga");
    if (isSvga) {
      _svgaAnimationController.reset();
      final videoItem = await (!_isLocal
          ? SVGAParser.shared.decodeFromURL(_url)
          : SVGAParser.shared.decodeFromAssets(_url));
      _svgaAnimationController.videoItem = videoItem;
      _svgaAnimationController.forward().whenComplete(() {
        _svgaAnimationController.videoItem = null;
        widget.controller.isPlaying = false;
        setState(() {
          _url = "";
        });
      });
    }
    setState(() {});
  }
}
