import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:desktop_drop/desktop_drop.dart';
import '../data/forensics_repository.dart';
import '../../../../shared/widgets/master_eye_widget.dart';

final forensicAnalysisProvider = StateNotifierProvider<ForensicAnalysisNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
  return ForensicAnalysisNotifier(ref.read(forensicsRepositoryProvider));
});

class ForensicAnalysisNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final ForensicsRepository _repository;
  ForensicAnalysisNotifier(this._repository) : super(const AsyncData(null));

  Future<void> analyze(Uint8List bytes, String fileName) async {
    state = const AsyncLoading();
    try {
      final result = await _repository.analyzeImage(bytes, fileName);
      state = AsyncData(result);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

class ForensicsScreen extends ConsumerStatefulWidget {
  const ForensicsScreen({super.key});

  @override
  ConsumerState<ForensicsScreen> createState() => _ForensicsScreenState();
}

class _ForensicsScreenState extends ConsumerState<ForensicsScreen> {
  Uint8List? _selectedImageBytes;
  bool _isDragging = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      final bytes = await xFile.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
      });
      ref.read(forensicAnalysisProvider.notifier).analyze(bytes, xFile.name);
    }
  }

  Widget _buildGlassmorphicCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final analysisState = ref.watch(forensicAnalysisProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Forensic Lab', style: TextStyle(color: Color(0xFF00FFCC))),
        backgroundColor: Colors.transparent,
      ),
      body: DropTarget(
        onDragDone: (detail) async {
          if (detail.files.isNotEmpty) {
            final file = detail.files.first;
            final bytes = await file.readAsBytes();
            setState(() {
              _selectedImageBytes = bytes;
            });
            ref.read(forensicAnalysisProvider.notifier).analyze(bytes, file.name);
          }
        },
        onDragEntered: (detail) => setState(() => _isDragging = true),
        onDragExited: (detail) => setState(() => _isDragging = false),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: _isDragging ? const Color(0xFF00FFCC).withOpacity(0.1) : Colors.transparent,
          padding: const EdgeInsets.all(24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Image View & Picker
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _selectedImageBytes == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.upload_file, size: 64, color: Colors.white54),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _pickImage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00FFCC),
                                  foregroundColor: Colors.black,
                                ),
                                child: const Text('Select or Drop Target Media'),
                              ),
                            ],
                          ),
                        )
                      : Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(_selectedImageBytes!, fit: BoxFit.cover),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(width: 24),
              // Right: Analysis Panel
              Expanded(
                flex: 1,
                child: analysisState.when(
                  data: (data) {
                    if (data == null) {
                      return const Center(
                        child: Text('Awaiting payload for structural analysis...', 
                                    style: TextStyle(color: Colors.white54, fontFamily: 'monospace')),
                      );
                    }
                    
                    final witnessData = data['technical_witness'] as List<dynamic>? ?? [];
                    final judgeVerdict = data['brutal_judge']?.toString() ?? 'N/A';
                    
                    final hasGeminiError = judgeVerdict.toLowerCase().contains('error') || judgeVerdict.toLowerCase().contains('quota');
                    final isSynthetic = !hasGeminiError && judgeVerdict.contains('SYNTHETIC');

                    String headerText;
                    Color headerColor;
                    
                    if (hasGeminiError) {
                      headerText = '⚠️ AUDIT UNAVAILABLE';
                      headerColor = Colors.orangeAccent;
                    } else if (isSynthetic) {
                      headerText = '🚨 SYNTHETIC ANOMALY DETECTED';
                      headerColor = const Color(0xFFFF0055);
                    } else {
                      headerText = '✅ AUTHENTICATED';
                      headerColor = const Color(0xFF00FFCC);
                    }

                    return ListView(
                      children: [
                        Row(
                          children: [
                            const MasterEyeWidget(),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                headerText,
                                style: TextStyle(
                                  fontSize: 24, 
                                  fontWeight: FontWeight.bold, 
                                  color: headerColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        
                        // Technical Witness (YOLOv12) Section
                        const Text('TECHNICAL WITNESS (YOLOv12)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 1.2)),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white10)),
                          child: witnessData.isEmpty 
                            ? const Text('No structural objects detected or API unavailable.', style: TextStyle(color: Colors.white54, fontFamily: 'monospace'))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: witnessData.map((obj) {
                                  final label = obj['label'] ?? 'Unknown';
                                  final conf = (obj['confidence'] ?? 0.0) * 100;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('OBJ: ${label.toString().toUpperCase()}', style: const TextStyle(fontFamily: 'monospace', color: Colors.white70)),
                                        Text('${conf.toStringAsFixed(2)}%', style: const TextStyle(fontFamily: 'monospace', color: Color(0xFF00FFCC))),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Brutal Judge (Glassmorphic Card)
                        const Text('BRUTAL JUDGE VERDICT (GEMINI 2.5 FLASH)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 1.2)),
                        const SizedBox(height: 12),
                        _buildGlassmorphicCard(
                          child: Text(
                            judgeVerdict,
                            style: const TextStyle(height: 1.6, fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        MasterEyeWidget(),
                        SizedBox(height: 24),
                        Text('Executing multi-stage anatomical audit...', style: TextStyle(color: Color(0xFF00FFCC), fontFamily: 'monospace')),
                      ],
                    ),
                  ),
                  error: (err, st) => Center(
                    child: Text('Audit Failed: $err', style: const TextStyle(color: Color(0xFFFF0055))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
