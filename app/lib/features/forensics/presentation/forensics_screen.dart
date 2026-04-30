import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:desktop_drop/desktop_drop.dart';
import '../data/forensics_repository.dart';
import '../../../../shared/widgets/master_eye_widget.dart';

// Riverpod Provider for State
final forensicAnalysisProvider = StateNotifierProvider<ForensicAnalysisNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
  return ForensicAnalysisNotifier(ref.read(forensicsRepositoryProvider));
});

class ForensicAnalysisNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final ForensicsRepository _repository;
  ForensicAnalysisNotifier(this._repository) : super(const AsyncData(null));

  Future<void> analyze(String filePath) async {
    state = const AsyncLoading();
    try {
      final result = await _repository.analyzeImage(filePath);
      state = AsyncData(result);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
  
  void reset() {
    state = const AsyncData(null);
  }
}

class ForensicsScreen extends ConsumerStatefulWidget {
  const ForensicsScreen({super.key});

  @override
  ConsumerState<ForensicsScreen> createState() => _ForensicsScreenState();
}

class _ForensicsScreenState extends ConsumerState<ForensicsScreen> {
  String? _selectedFilePath;
  bool _isDragging = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      setState(() {
        _selectedFilePath = xFile.path;
      });
      ref.read(forensicAnalysisProvider.notifier).analyze(xFile.path);
    }
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
        onDragDone: (detail) {
          if (detail.files.isNotEmpty) {
            setState(() {
              _selectedFilePath = detail.files.first.path;
            });
            ref.read(forensicAnalysisProvider.notifier).analyze(_selectedFilePath!);
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
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white24, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: _selectedFilePath == null
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
                                    child: Image.file(File(_selectedFilePath!), fit: BoxFit.cover),
                                  ),
                                  // Placeholder for Grad-CAM overlay if analysis is done
                                  if (analysisState is AsyncData && analysisState.value != null)
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: RadialGradient(
                                          colors: [
                                            Colors.red.withOpacity(0.4),
                                            Colors.transparent,
                                          ],
                                          radius: 0.8,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Right: Analysis Panel
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: analysisState.when(
                    data: (data) {
                      if (data == null) {
                        return const Center(
                          child: Text('Awaiting payload for structural analysis...', 
                                      style: TextStyle(color: Colors.white54, fontFamily: 'monospace')),
                        );
                      }
                      
                      final tw = data['report']['technical_witness'];
                      final judge = data['report']['brutal_judge_verdict'];
                      final isSynthetic = judge.contains('SYNTHETIC') || tw['technical_witness_verdict'] == 'review_required';

                      return ListView(
                        children: [
                          Row(
                            children: [
                              const MasterEyeWidget(), // Smaller size ideally, but placeholder ok
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  isSynthetic ? '🚨 SYNTHETIC ANOMALY DETECTED' : '✅ AUTHENTICATED',
                                  style: TextStyle(
                                    fontSize: 24, 
                                    fontWeight: FontWeight.bold, 
                                    color: isSynthetic ? const Color(0xFFFF0055) : const Color(0xFF00FFCC),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 48, color: Colors.white24),
                          const Text('TECHNICAL WITNESS (SWIN-B)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70)),
                          const SizedBox(height: 8),
                          Text('Predicted Class: ${tw['predicted_class'] ?? 'N/A'}', style: const TextStyle(fontFamily: 'monospace')),
                          Text('Confidence Score: ${tw['confidence_score'] ?? 'N/A'}', style: const TextStyle(fontFamily: 'monospace')),
                          const SizedBox(height: 24),
                          const Text('BRUTAL JUDGE (GEMINI 3.1 PRO)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70)),
                          const SizedBox(height: 8),
                          Text(judge, style: const TextStyle(height: 1.5)),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
