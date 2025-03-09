import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/materials_provider.dart';
import '../widgets/material_card.dart';
import '../widgets/subject_filter.dart';

class MaterialsScreen extends ConsumerStatefulWidget {
  const MaterialsScreen({super.key});

  @override
  ConsumerState<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends ConsumerState<MaterialsScreen> {
  String _selectedSubject = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final materialsState = ref.watch(materialsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Materials'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SearchBar(
              hintText: 'Search materials...',
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SubjectFilter(
            selectedSubject: _selectedSubject,
            onSubjectChanged: (subject) {
              setState(() => _selectedSubject = subject);
            },
          ),
          Expanded(
            child: materialsState.when(
              data: (materials) => _buildMaterialsList(materials),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMaterialDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMaterialsList(List<StudyMaterial> materials) {
    final filteredMaterials = materials.where((material) {
      final matchesSubject = _selectedSubject == 'All' || 
                           material.subject == _selectedSubject;
      final matchesSearch = material.title.toLowerCase()
                           .contains(_searchQuery.toLowerCase());
      return matchesSubject && matchesSearch;
    }).toList();

    return filteredMaterials.isEmpty
        ? const Center(
            child: Text('No materials found'),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredMaterials.length,
            itemBuilder: (context, index) {
              return MaterialCard(
                material: filteredMaterials[index],
                onTap: () => _openMaterial(filteredMaterials[index]),
              );
            },
          );
  }

  void _showAddMaterialDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddMaterialSheet(),
    );
  }

  void _openMaterial(StudyMaterial material) {
    // Implementation for opening different types of materials
    switch (material.type) {
      case MaterialType.pdf:
        _openPDF(material);
        break;
      case MaterialType.video:
        _openVideo(material);
        break;
      case MaterialType.document:
        _openDocument(material);
        break;
    }
  }

  void _openPDF(StudyMaterial material) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerScreen(material: material),
      ),
    );
  }

  void _openVideo(StudyMaterial material) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(material: material),
      ),
    );
  }

  void _openDocument(StudyMaterial material) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentViewerScreen(material: material),
      ),
    );
  }
} 