import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../widgets/main_button.dart';
import '../../widgets/text_input_field.dart';

class ReportScreen extends StatefulWidget {
  String lat;
  String long;
  ReportScreen(this.lat, this.long, {Key? key}) : super(key: key);
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  AudioPlayer audioPlayer = AudioPlayer();
  var voiceRecord = FlutterSoundRecorder();
  dynamic latitude = 12;
  dynamic longitude = 12;
  bool isRecording = false;
  bool hasRecorded = false;
  bool isReady = false;
  bool isPlaying = false;
  bool isLoading = false;
  String _description = '';
  Timer? _timer;
  int _timeCounter = 0;
  final multiPicker = ImagePicker();
  List<XFile> images = [];
  String? videoPath;
  File? videoFile;
  File? voiceFile;

  Future getMultiImage() async {
    // if (mediaStatus == PermissionStatus.granted) {
    if (images.isEmpty) {
      try {
        List<XFile>? selectedImages = await multiPicker.pickMultiImage();
        if (selectedImages.isNotEmpty && selectedImages.length <= 5) {
          setState(() {
            images.addAll(selectedImages);
          });
        } else {
          setState(() {
            images = [];
          });
        }
      } on PlatformException {
        rethrow;
      }
    } else {
      if (images.length < 6) {
        setState(() {
          images = [];
        });
        List<XFile>? selectedImages = await multiPicker.pickMultiImage();
        if (selectedImages.isNotEmpty && selectedImages.length <= 5) {
          setState(() {
            images.addAll(selectedImages);
          });
        } else {
          setState(() {
            images = images;
          });
        }
      }
    }
  }

  Future getCamera() async {
    final cameraStatus = await Permission.camera.request();

    if (cameraStatus == PermissionStatus.granted) {
      final XFile? cameraVideo = await multiPicker.pickVideo(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (cameraVideo == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Video qeyde alinmadi'),
        ));
      } else {
        setState(() {
          videoFile = File(cameraVideo.path);
          videoPath = cameraVideo.path;
          print('video $videoPath');
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Kameraya icaze verilmedi'),
      ));
    }
  }

  void _openModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: getCamera,
                child: const Text(
                  'Kameranı aç',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: getMultiImage,
                child: const Text(
                  'Qalereyanı aç',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeCounter++;
      });
    });
  }

  void stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timeCounter = 0;
    }
  }

  Future startRecording() async {
    if (!isReady) return;
    setState(() {
      isRecording = true;
      _timeCounter = 0;
      hasRecorded = false;
    });
    await voiceRecord.startRecorder(toFile: 'audio.wav');
    startTimer();
  }

  Future<void> stopRecording() async {
    if (!isReady) return;

    setState(() {
      isRecording = false;
      hasRecorded = true;
    });
    final voicePath = await voiceRecord.stopRecorder();
    final recordedVoice = File(voicePath!);
    setState(() {
      voiceFile = recordedVoice;
    });

    print('Ses yazisi ${voiceFile!.path}');

    stopTimer();
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tamamlandı'),
          content: const Text('Xəbərdarlıqınız üçün təşəkkür edirik!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Bağla'),
            ),
          ],
        );
      },
    ).then((value) => Navigator.pop(context));
  }

  // Future<void> pauseRecording() async {
  //   setState(() {
  //     isPlaying = false;
  //   });
  //   await audioPlayer.pause();
  // }

  // Future<void> playRecording() async {
  //   setState(() {
  //     isPlaying = true;
  //   });
  //   await audioPlayer.setSourceUrl(filePath.toString());
  // }

  Future<void> initRecorder() async {
    await voiceRecord.openRecorder();
    voiceRecord.setSubscriptionDuration(const Duration(milliseconds: 500));
    isReady = true;
  }

  Future<void> setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    audioPlayer.setSourceAsset(voiceFile as String);
  }

  void _updateDescription(String value) {
    setState(() {
      _description = value;
    });
  }

  @override
  void initState() {
    initRecorder();
    super.initState();
  }

  @override
  void dispose() {
    voiceRecord.closeRecorder();
    super.dispose();
  }

  Future<void> sendReport() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<Auth>(context, listen: false).sendReport(
        latitude: widget.lat,
        longitude: widget.long,
        description: _description,
        images: images,
        video: videoFile,
        voice: voiceFile,
      );
      setState(() {
        isLoading = false;
      });
      _showConfirmDialog();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$error'),
      ));

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          elevation: 0.2,
          title: const Text(
            'Hadisə detalları',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  height: 24,
                  color: Colors.white,
                ),
                const Text(
                  'Media :',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0XFF222B45),
                    fontSize: 14,
                  ),
                ),
                const Divider(
                  height: 12,
                  color: Colors.white,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _openModalBottomSheet(context),
                      child: SvgPicture.asset('assets/upload-image.svg'),
                    ),
                    SizedBox(
                      height: 104,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        // physics: const NeverScrollableScrollPhysics(),
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return images.isEmpty
                              ? const SizedBox()
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Image.file(
                                      File(
                                        images[index].path,
                                      ),
                                      fit: BoxFit.cover,
                                      width: 104,
                                    ),
                                  ),
                                );
                        },
                      ),
                    )
                  ],
                ),
                const Divider(
                  height: 6,
                  color: Colors.white,
                ),
                videoPath != null
                    ? const Text('1 video qeyde alindi')
                    : const SizedBox(),
                const Divider(
                  height: 24,
                  color: Colors.white,
                ),
                const Text(
                  'Təsvir :',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0XFF222B45),
                    fontSize: 14,
                  ),
                ),
                const Divider(
                  height: 12,
                  color: Colors.white,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextInputField(
                    'Hadisənin detalları',
                    _descriptionController,
                    _updateDescription,
                  ),
                ),
                Divider(
                  height: MediaQuery.of(context).size.height / 8,
                  color: Colors.white,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.only(bottom: 6),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 215, 215, 215)
                                    .withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: StreamBuilder<RecordingDisposition>(
                            stream: voiceRecord.onProgress,
                            builder: (context, snapshot) {
                              final duration = snapshot.hasData
                                  ? snapshot.data!.duration
                                  : Duration.zero;
                              return Text('${duration.inSeconds} s');
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // hasRecorded
                            //     ? GestureDetector(
                            //         onTap: () async {
                            //           isPlaying
                            //               ? await pauseRecording()
                            //               : await playRecording();
                            //         },
                            //         child: Container(
                            //           width: 40,
                            //           height: 40,
                            //           margin: const EdgeInsets.only(right: 8),
                            //           decoration: BoxDecoration(
                            //             color: Colors.white,
                            //             borderRadius: BorderRadius.circular(25),
                            //             boxShadow: [
                            //               BoxShadow(
                            //                 color: const Color.fromARGB(
                            //                         255, 215, 215, 215)
                            //                     .withOpacity(0.5),
                            //                 spreadRadius: 7,
                            //                 blurRadius: 10,
                            //                 offset: const Offset(0, 3),
                            //               ),
                            //             ],
                            //           ),
                            //           child: Icon(
                            //             isPlaying ? Icons.pause : Icons.play_arrow,
                            //             size: 28,
                            //             color:
                            //                 const Color.fromARGB(255, 0, 136, 255),
                            //           ),
                            //         ),
                            //       )
                            //     : const SizedBox(
                            //         width: 48,
                            //       ),
                            GestureDetector(
                              onTap: () async {
                                isRecording
                                    ? await stopRecording()
                                    : await startRecording();
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 0, 136, 255),
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 0, 136, 255),
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  isRecording ? Icons.stop : Icons.mic,
                                  size: 28,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // const SizedBox(
                            //   width: 48,
                            // ),
                          ],
                        ),
                        isRecording
                            ? const Text(
                                'Səs yazmanı dayandırmaq üçün düyməyə basın')
                            : const Text('Səs yazmaq üçün düyməyə basın')
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: MediaQuery.of(context).size.height / 10,
                  color: Colors.white,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : MainButton(
                          'Göndər',
                          Colors.black,
                          Colors.black,
                          Colors.white,
                          sendReport,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
