// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

import 'reference_screen.dart';
import '../widgets/custom_icon.dart';
import '../popups/popup_handler.dart';
import '../popups/speed_popup.dart';
import '../popups/settings_popup.dart';
import '../popups/error_message_popup.dart';

List<CameraDescription> _availableCameras = [];

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  String _cameraStatusMessage = "Initializing Camera...";
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCameraIfPermissionsGranted();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _cameraController!.dispose();
      if (mounted) {
        setState(() {
          _isCameraInitialized = false;
          _cameraStatusMessage = "Camera inactive.";
        });
      }
    } else if (state == AppLifecycleState.resumed) {
      if (_availableCameras.isNotEmpty) {
        _initCameraController(_availableCameras[_selectedCameraIndex]);
      } else {
        _initCameraIfPermissionsGranted();
      }
    }
  }

  Future<bool> isCameraAccessDeniedOrPermanently() async {
    return await Permission.camera.isPermanentlyDenied;
  }

  Future<bool> isCameraAccessDeniedOnly() async {
    return await Permission.camera.isDenied;
  }

  Future<void> requestCameraAccessAgain() async {
    await Permission.camera.request();
    if (mounted) {
      _initCameraIfPermissionsGranted();
    }
  }

  Future<void> forceExitApplication() async {
    exit(0);
  }

  Future<void> checkCameraAccess() async {
    if (!mounted) return;

    final status = await Permission.camera.status;

    if (status.isDenied) {
      PopupHandler.instance.showPopup(context,
        ErrorMessage(
          title: "Warning",
          buttonMessage: "Allow Access",
          message: "The application doesn't have the permission for camera access, please allow camera access.",
          subEvent: () async {
            await requestCameraAccessAgain();
          },
        ),
      );
    } else if (status.isPermanentlyDenied) {
      PopupHandler.instance.showPopup(context,
        ErrorMessage(
          title: "Error",
          buttonMessage: "Quit App",
          message: "Permanent Denied Camera Access, please allow camera access on the app settings.\nErr:CAM_ACCESS_400",
          subEvent: () {
            forceExitApplication();
          },
        ),
      );
    }
  }

  Future<void> _initCameraIfPermissionsGranted() async {
    if (!mounted) return;

    setState(() {
      _isCameraInitialized = false;
      _cameraStatusMessage = "Checking permissions...";
    });

    final status = await Permission.camera.status;

    if (status.isGranted) {
      setState(() {
        _cameraStatusMessage = "Permissions granted, finding cameras...";
      });
      try {
        if (_availableCameras.isEmpty) {
          final List<CameraDescription>? discoveredCameras = await availableCameras();
          if (discoveredCameras != null) {
            _availableCameras = discoveredCameras;
          } else {
            print("availableCameras() returned null on web. No cameras found.");
            if (mounted) {
              setState(() {
                _cameraStatusMessage = "No cameras found on device.";
              });
            }
            return;
          }
        }

        if (_availableCameras.isNotEmpty) {
          if (_cameraController != null && _cameraController!.value.isInitialized) {
            await _cameraController!.dispose();
          }
          await _initCameraController(_availableCameras[_selectedCameraIndex]);
        } else {
          print("No cameras found on this device after discovery.");
          if (mounted) {
            setState(() {
              _cameraStatusMessage = "No cameras found on device.";
            });
          }
        }
      } on CameraException catch (e) {
        print("Camera initialization error: $e");
        if (mounted) {
          setState(() {
            _isCameraInitialized = false;
            _cameraStatusMessage = "Error initializing camera: ${e.code}";
          });
        }
      } catch (e) {
        print("An unexpected error occurred during camera setup: $e");
        if (mounted) {
          setState(() {
            _isCameraInitialized = false;
            _cameraStatusMessage = "An unknown error occurred.";
          });
        }
      }
    } else {
      checkCameraAccess();
      if (mounted) {
        setState(() {
          _cameraStatusMessage = "Camera access denied.";
        });
      }
    }
  }

  Future<void> _initCameraController(CameraDescription cameraDescription) async {
    if (!mounted) return;

    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
        _cameraStatusMessage = "Camera ready.";
      });
    } on CameraException catch (e) {
      print("Error initializing camera controller: $e");
      if (mounted) {
        setState(() {
          _isCameraInitialized = false;
          _cameraStatusMessage = "Failed to start camera: ${e.code}";
        });
      }
    }
  }

  void _switchCamera() async {
    if (_availableCameras.isEmpty || _availableCameras.length < 2) {
      setState(() {
        _cameraStatusMessage = "Only one camera found or no cameras to switch.";
      });
      return;
    }

    setState(() {
      _isCameraInitialized = false;
      _cameraStatusMessage = "Switching camera...";
    });

    _selectedCameraIndex = (_selectedCameraIndex + 1) % _availableCameras.length;

    await _cameraController?.dispose();

    try {
      await _initCameraController(_availableCameras[_selectedCameraIndex]);
    } on CameraException catch (e) {
      print("Error switching camera: $e");
      setState(() {
        _cameraStatusMessage = "Error switching camera: ${e.code}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: _isCameraInitialized && _cameraController != null && _cameraController!.value.isInitialized
                ? Transform.scale(
                    scale: _cameraController!.value.aspectRatio / deviceRatio,
                    alignment: Alignment.center,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: _cameraController!.value.aspectRatio,
                        child: CameraPreview(_cameraController!),
                      ),
                    ),
                  )
                : Container(
                    color: Colors.black,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _cameraStatusMessage.contains("Error") || _cameraStatusMessage.contains("No cameras")
                              ? const Icon(Icons.camera_alt_outlined, color: Colors.white70, size: 60)
                              : const CircularProgressIndicator(color: Colors.white),
                          const SizedBox(height: 16),
                          Text(
                            _cameraStatusMessage,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 80,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color.fromARGB(255, 0, 0, 0),
                    Color.fromARGB(255, 0, 0, 0),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => PopupHandler.instance.showPopup(context, const SettingsPopup()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const CustomIcon(icon: Icons.menu, iconSize: 32),
                        ),
                      ),
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ReferenceScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const CustomIcon(icon: Icons.menu_book_outlined, iconSize: 32),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                const Padding(
                  padding: EdgeInsets.only(left: 16.0, bottom: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Magandang Umaga!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Ako si JOE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: 16,
                    top: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => PopupHandler.instance.showPopup(context, const SpeedPopup()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const CustomIcon(icon: Icons.tune, iconSize: 32),
                        ),
                      ),
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _switchCamera, // Switched to _switchCamera function
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const CustomIcon(icon: Icons.cameraswitch_outlined, iconSize: 35),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}