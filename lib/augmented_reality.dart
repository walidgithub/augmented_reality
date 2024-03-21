import 'package:augmented_reality_plugin/augmented_reality_plugin/init_augmented_reality_plugin.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class AugmentedRealityPlugin extends StatefulWidget {
  final String imageLink;
  final bool isScreenShotRunning;
  AugmentedRealityPlugin(this.imageLink, this.isScreenShotRunning);

  @override
  _AugmentedRealityPluginState createState() => _AugmentedRealityPluginState();
}

class _AugmentedRealityPluginState extends State<AugmentedRealityPlugin> {
  var _cameraController;
  List<CameraDescription> cameraMovements = [];
  bool isCameraLoading = false;

  void initCameraStreaming() async {
    setState(() {
      isCameraLoading = true;
    });

    try {
      cameraMovements = await availableCameras();
      _cameraController =
          CameraController(cameraMovements[0], ResolutionPreset.ultraHigh);
      await _cameraController.initialize();
      setState(() {
        isCameraLoading = false;
      });
    } catch (errorMessage) {
      setState(() {
        isCameraLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.isScreenShotRunning);
    initCameraStreaming();
  }

  double xAxisPosition = 130;
  double yAxisPosition = 150;
  double height = 150;
  double onchange = 150;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isCameraLoading
          ? const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            )
          : Stack(
              children: [
                SizedBox(
                    height: 1000,
                    width: MediaQuery.of(context).size.width,
                    child: AugmentedRealityWidget(_cameraController)),
                Positioned(
                  top: yAxisPosition,
                  left: xAxisPosition,
                  child: GestureDetector(
                    onPanUpdate: (tapInfo) {
                      setState(() {
                        xAxisPosition += tapInfo.delta.dx;
                        yAxisPosition += tapInfo.delta.dy;
                      });
                    },
                    child: Container(
                      height: onchange,
                      color: Colors.transparent,
                      child: Image.network(
                        widget.imageLink ??
                            'https://www.freepnglogos.com/uploads/furniture-png/furniture-png-transparent-furniture-images-pluspng-15.png',
                        height: onchange,
                        width: onchange,
                      ),
                    ),
                  ),
                ),
                !widget.isScreenShotRunning ? Positioned(
                    bottom: 0,
                    left: 0,
                    right: 10,
                    child: Slider(
                      activeColor: Colors.white,
                      value: onchange,
                      min: 10,
                      max: 300,
                      onChanged: (value) {
                        setState(() {
                          onchange = value;
                        });
                      },
                    )) : Container()
              ],
            ),
    );
  }
}
