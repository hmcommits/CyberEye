import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/master_eye_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Adaptive Layout: Row for Desktop, Column for Mobile
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CyberEye | Judicial Defense'),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: isDesktop ? _buildDesktopLayout(context) : _buildMobileLayout(context),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Panel (Tools)
        Expanded(
          flex: 2,
          child: _buildToolsMenu(context),
        ),
        // Center Panel (Master Eye)
        const Expanded(
          flex: 3,
          child: Center(child: MasterEyeWidget()),
        ),
        // Right Panel (Evidence/Logs)
        Expanded(
          flex: 2,
          child: _buildLogsPanel(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40, child: MasterEyeWidget()),
          const SizedBox(height: 40),
          _buildToolsMenu(context),
          const SizedBox(height: 40),
          _buildLogsPanel(),
        ],
      ),
    );
  }

  Widget _buildToolsMenu(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Forensic Modules', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70)),
        const SizedBox(height: 16),
        _buildModuleCard(context, 'Media Forensic Lab', 'Deepfake & AI generation detection', '/forensics'),
        _buildModuleCard(context, 'Neural Link Triage', 'URL Fraud & Typosquatting analysis', ''),
        _buildModuleCard(context, 'Breach Guard', 'Dark web identity exposure monitor', ''),
        _buildModuleCard(context, 'Legal Scout', 'TOS predatory clause auditor', ''),
      ],
    );
  }

  Widget _buildModuleCard(BuildContext context, String title, String subtitle, String route) {
    return Card(
      color: const Color(0xFF1A1A1A),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF00FFCC)),
        onTap: () {
          if (route.isNotEmpty) {
            context.push(route);
          }
        },
      ),
    );
  }

  Widget _buildLogsPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('System Logs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70)),
          SizedBox(height: 16),
          Text('[SYS] CyberEye initialized.', style: TextStyle(color: Colors.green, fontFamily: 'monospace')),
          Text('[SYS] Awaiting target payload...', style: TextStyle(color: Colors.white54, fontFamily: 'monospace')),
        ],
      ),
    );
  }
}
