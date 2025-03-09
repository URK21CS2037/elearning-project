import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../models/study_material_model.dart';

class PDFViewerScreen extends StatefulWidget {
  final StudyMaterial material;

  const PDFViewerScreen({
    super.key,
    required this.material,
  });

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  late PdfViewerController _controller;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _controller = PdfViewerController();
    _checkBookmarkStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.material.title),
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            ),
            onPressed: _toggleBookmark,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadPDF,
          ),
        ],
      ),
      body: SfPdfViewer.network(
        widget.material.url,
        controller: _controller,
        onDocumentLoadFailed: (details) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${details.description}')),
          );
        },
      ),
    );
  }

  Future<void> _checkBookmarkStatus() async {
    // Check if PDF is bookmarked in local storage
    // Implementation
  }

  Future<void> _toggleBookmark() async {
    // Toggle bookmark status and save to local storage
    // Implementation
  }

  Future<void> _downloadPDF() async {
    // Download PDF for offline access
    // Implementation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
} 