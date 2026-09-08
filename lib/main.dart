import 'package:flutter/material.dart';

void main() {
  runApp(const Cam2PdfApp());
}

class Cam2PdfApp extends StatelessWidget {
  const Cam2PdfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cam2PDF',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Test Mode switch to trial PRO features freely during field testing
  bool _isProModeSimulated = true;
  bool _includeHeader = true;
  int _photosPerPage = 2; // Options: 1, 2, 4

  // Dati di test per simulare il frontespizio e i metadati
  final TextEditingController _clientController = TextEditingController(text: 'Studio Tecnico Associato');
  final TextEditingController _locationController = TextEditingController(text: 'Via Roma 14, Novara (NO)');
  final TextEditingController _noteController = TextEditingController(text: 'Sopralluogo lesioni strutturali piano terra');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cam2PDF',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.5),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Row(
            children: [
              Text(
                _isProModeSimulated ? 'PRO (Test)' : 'LITE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _isProModeSimulated ? Colors.amber[800] : Colors.grey,
                ),
              ),
              Switch(
                value: _isProModeSimulated,
                activeColor: Colors.black,
                onChanged: (value) {
                  setState(() {
                    _isProModeSimulated = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card / Configurazione
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Impostazioni Report PDF',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Intestazione di Perizia (Header)', style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Frontespizio tecnico pulito in alto alla prima pagina', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    value: _includeHeader,
                    activeColor: Colors.black,
                    onChanged: _isProModeSimulated ? (val) => setState(() => _includeHeader = val) : null,
                  ),
                  if (_includeHeader && _isProModeSimulated) ...[
                    const SizedBox(height: 8),
                    TextField(
                      controller: _clientController,
                      decoration: const InputDecoration(labelText: 'Cliente / Committente', border: OutlineInputBorder(), isDense: true),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: 'Località / Indirizzo', border: OutlineInputBorder(), isDense: true),
                    ),
                  ],
                  const Divider(height: 24),
                  const Text('Foto per pagina nel PDF:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(value: 1, label: Text('1 Grande')),
                      ButtonSegment(value: 2, label: Text('2 Foto')),
                      ButtonSegment(value: 4, label: Text('4 Griglia')),
                    ],
                    selected: {_photosPerPage},
                    onSelectionChanged: (Set<int> newSelection) {
                      setState(() {
                        _photosPerPage = newSelection.first;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Azioni principali
            ElevatedButton.icon(
              onPressed: () {
                _showInfoDialog(context, 'Mirino & Livella', 'Apre la fotocamera con griglia di centratura, livella in bolla digitale e salvataggio automatico di coordinate, bussola e mappa satellitare.');
              },
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              label: const Text('Scatta con Mirino e Livella', style: TextStyle(color: Colors.white, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                _showInfoDialog(context, 'Rullino & Metadati', 'Seleziona una foto esistente estraendo automaticamente i metadati EXIF (GPS, data, indirizzo e mappa satellitare).');
              },
              icon: const Icon(Icons.photo_library, color: Colors.black),
              label: const Text('Importa da Rullino (con Metadati)', style: TextStyle(color: Colors.black, fontSize: 16)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
