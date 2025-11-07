import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotspots_hostes/constants/text_constants.dart';
import 'package:hotspots_hostes/constants/text_styles.dart';
import 'package:hotspots_hostes/models/wave_line.dart';
import 'package:hotspots_hostes/utils/app_colors.dart';
import 'package:hotspots_hostes/utils/next_button.dart';
import 'package:hotspots_hostes/utils/zig_zag_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class OnboardingQuestionScreen extends StatefulWidget {
  final List<int> selectedExperienceIds;
  final String experienceDescription;

  const OnboardingQuestionScreen({
    super.key,
    required this.selectedExperienceIds,
    required this.experienceDescription,
  });

  @override
  State<OnboardingQuestionScreen> createState() =>
      _OnboardingQuestionScreenState();
}

class _OnboardingQuestionScreenState extends State<OnboardingQuestionScreen>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();

  CameraController? _cameraController;
  VideoPlayerController? _videoPlayerController;

  bool _isRecordingAudio = false;
  bool _isRecordingVideo = false;
  bool _isPlayingAudio = false;

  String? _recordedAudioPath;
  String? _recordedVideoPath;

  List<double> _waveform = [];
  late AnimationController _micPulseController;
  Duration _recordingDuration = Duration.zero;
  Timer? _recordingTimer;

  int _cameraIndex = 0;
  List<CameraDescription> _availableCameras = [];
  bool get _isKeyboardVisible => MediaQuery.of(context).viewInsets.bottom > 0;

  @override
  void initState() {
    super.initState();
    _initRecorder();
    _initPlayer();
    _initCamera();

    _micPulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.8,
      upperBound: 1.2,
    )..repeat(reverse: true);
  }

  Future<void> _initRecorder() async {
    await _recorder.openRecorder();
    await Permission.microphone.request();
  }

  Future<void> _initPlayer() async {
    await _player.openPlayer();
  }

  Future<void> _initCamera() async {
    _availableCameras = await availableCameras();
    if (_availableCameras.isNotEmpty) {
      _cameraController = CameraController(
        _availableCameras[_cameraIndex],
        ResolutionPreset.medium,
      );
      await _cameraController?.initialize();
      setState(() {});
    }
  }

  void _switchCamera() async {
    if (_availableCameras.length < 2) return;

    // If recording, stop first
    if (_isRecordingVideo) {
      await _stopVideoRecording();
      await Future.delayed(const Duration(milliseconds: 400));
    }

    _cameraIndex = (_cameraIndex + 1) % _availableCameras.length;
    await _cameraController?.dispose();
    _cameraController = CameraController(
      _availableCameras[_cameraIndex],
      ResolutionPreset.medium,
    );

    await _cameraController?.initialize();
    setState(() {});
  }

  void _simulateWaveform() {
    if (!_isRecordingAudio) return;

    setState(() {
      _waveform = List.generate(30, (index) => Random().nextDouble() * 35 + 15);
    });

    // Slightly faster refresh for smoother animation
    Future.delayed(const Duration(milliseconds: 80), _simulateWaveform);
  }

  void _startTimer() {
    _recordingDuration = Duration.zero;
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _recordingDuration += const Duration(seconds: 1));
    });
  }

  void _stopTimer() => _recordingTimer?.cancel();

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  Future<void> _startAudioRecording() async {
    if (await Permission.microphone.isGranted) {
      final dir = await getApplicationDocumentsDirectory();
      final path =
          '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';
      await _recorder.startRecorder(toFile: path);
      setState(() {
        _recordedAudioPath = path;
        _isRecordingAudio = true;
        _waveform.clear();
      });
      _simulateWaveform();
      _startTimer();
    }
  }

  Future<void> _stopAudioRecording() async {
    await _recorder.stopRecorder();
    _stopTimer();
    setState(() => _isRecordingAudio = false);
  }

  Future<void> _startVideoRecording() async {
    final status = await Permission.camera.request();
    if (!status.isGranted || _cameraController == null) return;

    try {
      await _cameraController?.startVideoRecording();
      _startTimer();
      setState(() => _isRecordingVideo = true);
    } catch (e) {
      debugPrint('Error starting video: $e');
    }
  }

  Future<void> _stopVideoRecording() async {
    if (_cameraController == null ||
        !_cameraController!.value.isRecordingVideo) {
      return;
    }

    try {
      final result = await _cameraController?.stopVideoRecording();
      _stopTimer();
      if (result != null) {
        _recordedVideoPath = result.path;
        _videoPlayerController = VideoPlayerController.file(File(result.path))
          ..initialize().then((_) => setState(() {}));
      }
      setState(() => _isRecordingVideo = false);
    } catch (e) {
      debugPrint('Error stopping video: $e');
    }
  }

  void _deleteAudio() {
    if (_recordedAudioPath != null) File(_recordedAudioPath!).delete();
    setState(() => _recordedAudioPath = null);
  }

  void _deleteVideo() {
    if (_recordedVideoPath != null) File(_recordedVideoPath!).delete();
    setState(() {
      _recordedVideoPath = null;
      _videoPlayerController = null;
    });
  }

  Widget _buildWaveform() => SizedBox(
    height: 30,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _waveform
            .map(
              (h) => Container(
                width: 4.4,
                height: h,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: AppColors.whiteB8,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            )
            .toList(),
      ),
    ),
  );

  Widget _buildAudioSection() {
    if (_recordedAudioPath != null && _isKeyboardVisible) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.blue5961FF,
              ),
              child: Center(
                child: IconButton(
                  icon: Icon(
                    _isPlayingAudio
                        ? Icons.stop_circle
                        : Icons.play_arrow_outlined,
                    color: AppColors.white.withOpacity(0.9),
                  ),
                  onPressed: () async {
                    if (_isPlayingAudio) {
                      await _player.stopPlayer();
                      setState(() => _isPlayingAudio = false);
                    } else {
                      await _player.startPlayer(
                        fromURI: _recordedAudioPath!,
                        whenFinished: () =>
                            setState(() => _isPlayingAudio = false),
                      );
                      setState(() => _isPlayingAudio = true);
                    }
                  },
                ),
              ),
            ),

            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Audio Recorded",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Space Grotesk',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDuration(_recordingDuration),
                    style: const TextStyle(
                      color: Colors.white54,
                      fontFamily: 'Space Grotesk',
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _deleteAudio,
              child: SvgPicture.asset(
                'assets/icons/delete.svg',
                width: 20,
                color: AppColors.blue5961FF,
              ),
            ),
          ],
        ),
      );
    }

    // Full card as before
    if (_isRecordingAudio) {
      return _buildAudioCard(
        title: "Audio is recording...",

        trailing: SvgPicture.asset(
          'assets/icons/delete.svg',
          width: 20,
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _micPulseController,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.blue5961FF,
                ),
                child: const Icon(Icons.mic, color: Colors.white, size: 28),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(child: _buildWaveform()),
            const SizedBox(width: 8),
            Text(
              _formatDuration(_recordingDuration),
              style: const TextStyle(
                color: Color(0xFFDADADA),
                fontFamily: 'Space Grotesk',
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    } else if (_recordedAudioPath != null) {
      return _buildAudioCard(
        title: "Audio recorded - ${_formatDuration(_recordingDuration)}",
        trailing: GestureDetector(
          onTap: _deleteAudio,
          child: SvgPicture.asset(
            'assets/icons/delete.svg',
            width: 20,
            color: AppColors.blue5961FF,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.blue5961FF,
                shape: BoxShape.circle,
              ),

              child: Center(
                child: IconButton(
                  icon: Icon(
                    _isPlayingAudio ? Icons.stop : Icons.play_arrow_outlined,
                    color: AppColors.white.withOpacity(0.9),
                  ),
                  onPressed: () async {
                    if (_isPlayingAudio) {
                      await _player.stopPlayer();
                      setState(() => _isPlayingAudio = false);
                    } else {
                      await _player.startPlayer(
                        fromURI: _recordedAudioPath!,
                        whenFinished: () =>
                            setState(() => _isPlayingAudio = false),
                      );
                      setState(() => _isPlayingAudio = true);
                    }
                  },
                ),
              ),
            ),
            SizedBox(width: 4),
            Flexible(child: _buildWaveform()),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildAudioCard({
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  height: 20 / 14,
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildVideoSection() {
    // Compact card when keyboard is open + video recorded
    if (_recordedVideoPath != null &&
        _videoPlayerController != null &&
        _videoPlayerController!.value.isInitialized &&
        _isKeyboardVisible) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: VideoPlayer(_videoPlayerController!),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        _videoPlayerController!.value.isPlaying
                            ? Icons.pause_circle
                            : Icons.play_circle_fill,
                        size: 28,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      onPressed: () {
                        if (_videoPlayerController!.value.isPlaying) {
                          _videoPlayerController!.pause();
                        } else {
                          _videoPlayerController!.play();
                        }
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Video Recorded",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Space Grotesk',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDuration(_recordingDuration),
                    style: const TextStyle(
                      color: Colors.white54,
                      fontFamily: 'Space Grotesk',
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _deleteVideo,
              child: SvgPicture.asset(
                'assets/icons/delete.svg',
                width: 20,
                color: AppColors.blue5961FF,
              ),
            ),
          ],
        ),
      );
    }

    // Otherwise keep your full layout
    if (_isRecordingVideo) {
      return _buildVideoCard(
        title: "Recording Video... ${_formatDuration(_recordingDuration)}",
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 180,
                width: double.infinity,
                child:
                    _cameraController != null &&
                        _cameraController!.value.isInitialized
                    ? CameraPreview(_cameraController!)
                    : const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
              ),
            ),
            Positioned(
              bottom: 6,
              right: 6,
              child: IconButton(
                icon: const Icon(Icons.cameraswitch, color: Color(0xFF9196FF)),
                onPressed: _switchCamera,
              ),
            ),
          ],
        ),
      );
    } else if (_recordedVideoPath != null &&
        _videoPlayerController != null &&
        _videoPlayerController!.value.isInitialized) {
      return _buildVideoCard(
        title: "Video Recorded - ${_formatDuration(_recordingDuration)}",
        trailing: GestureDetector(
          onTap: _deleteVideo,
          child: SvgPicture.asset(
            'assets/icons/delete.svg',
            width: 20,
            color: AppColors.blue5961FF,
          ),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: double.infinity,
                height: 180,
                child: VideoPlayer(_videoPlayerController!),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: IconButton(
                  icon: Icon(
                    _videoPlayerController!.value.isPlaying
                        ? Icons.pause_circle
                        : Icons.play_circle_fill,
                    size: 50,
                    color: const Color(0xFF9196FF),
                  ),
                  onPressed: () {
                    if (_videoPlayerController!.value.isPlaying) {
                      _videoPlayerController!.pause();
                    } else {
                      _videoPlayerController!.play();
                    }
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildVideoCard({
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  height: 20 / 14,
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canProceed =
        _controller.text.isNotEmpty ||
        _recordedAudioPath != null ||
        _recordedVideoPath != null;

    final hasMedia = _recordedAudioPath != null || _recordedVideoPath != null;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: ZigzagBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {},
                    ),
                    StaticWaveformLine(fillFraction: 0.66),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  TextConstants.onboardingQuestionTitle,
                  style: !_isKeyboardVisible
                      ? CustomTextStyles.experienceSelectionTitleLarge
                      : CustomTextStyles.experienceSelectionTitleSmall,
                  textAlign: TextAlign.left,
                ),
                if (!hasMedia || !_isKeyboardVisible)
                  Padding(
                    padding: EdgeInsets.only(top: 6, bottom: 20),
                    child: Text(
                      TextConstants.onboardingQuestionHint,
                      style: GoogleFonts.spaceGrotesk(
                        // fontFamily: 'Space Grotesk',
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: MediaQuery.of(context).viewInsets.bottom > 0
                      ? 140
                      : 190, // adjust heights
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    expands: true,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Space Grotesk',
                    ),

                    decoration: InputDecoration(
                      hintText: "/Start typing here",
                      hintStyle: CustomTextStyles.experienceDescriptionHint,
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      fillColor: const Color(0xFF151515),
                      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: _isKeyboardVisible
                            ? BorderSide(color: AppColors.blue5961FF, width: 2)
                            : BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                _buildAudioSection(),
                _buildVideoSection(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                              gradient:
                                  _isRecordingAudio ||
                                      _recordedAudioPath != null
                                  ? LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(
                                          0x66FFFFFF,
                                        ), // bright edge top-left
                                        Color(
                                          0x33FFFFFF,
                                        ), // subtle mid transition
                                        Color(
                                          0x0DFFFFFF,
                                        ), // soft bottom-right fade
                                      ],
                                      stops: [0.0, 0.4, 1.0],
                                    )
                                  : null,
                            ),
                            child: IconButton(
                              icon: Icon(
                                _isRecordingAudio
                                    ? Icons.stop
                                    : Icons.mic_none_outlined,
                                color: _isRecordingAudio
                                    ? Colors.red
                                    : (_recordedVideoPath != null
                                          ? Colors.grey
                                          : Colors.white),
                              ),
                              onPressed:
                                  _recordedVideoPath != null ||
                                      _isRecordingVideo
                                  ? null
                                  : _isRecordingAudio
                                  ? _stopAudioRecording
                                  : _startAudioRecording,
                            ),
                          ),
                          SizedBox(width: hasMedia ? 0 : 3),
                          if (!hasMedia)
                            SizedBox(
                              height: 24,
                              child: VerticalDivider(
                                color: Colors.white24,
                                thickness: 1,
                              ),
                            ),
                          SizedBox(width: hasMedia ? 0 : 3),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              gradient:
                                  _isRecordingVideo ||
                                      _recordedVideoPath != null
                                  ? const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(
                                          0x66FFFFFF,
                                        ), // bright edge top-left
                                        Color(
                                          0x33FFFFFF,
                                        ), // subtle mid transition
                                        Color(
                                          0x0DFFFFFF,
                                        ), // soft bottom-right fade
                                      ],
                                      stops: [0.0, 0.4, 1.0],
                                    )
                                  : null,
                            ),
                            child: IconButton(
                              icon: Icon(
                                _isRecordingVideo
                                    ? Icons.stop
                                    : Icons.videocam_outlined,
                                color: _isRecordingVideo
                                    ? Colors.red
                                    : (_recordedAudioPath != null
                                          ? Colors.grey
                                          : Colors.white),
                              ),
                              onPressed:
                                  _recordedAudioPath != null ||
                                      _isRecordingAudio
                                  ? null
                                  : _isRecordingVideo
                                  ? _stopVideoRecording
                                  : _startVideoRecording,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: GradientNextButton(
                        isEnabled: canProceed,
                        onPressed: canProceed
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Response submitted successfully!",
                                    ),
                                  ),
                                );
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _recorder.closeRecorder();
    _player.closePlayer();
    _videoPlayerController?.dispose();
    _cameraController?.dispose();
    _micPulseController.dispose();
    _recordingTimer?.cancel();
    super.dispose();
  }
}
