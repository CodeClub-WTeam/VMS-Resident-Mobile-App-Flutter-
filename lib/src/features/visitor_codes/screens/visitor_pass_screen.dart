import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

class VisitorPassScreen extends StatelessWidget {
final Map<String, dynamic> codeData;

 const VisitorPassScreen({super.key, required this.codeData});

  @override
  Widget build(BuildContext context) {
    final String visitorName = codeData['visitor_name'] ?? 'Unknown Visitor';
    // REMOVED: final String visitorPhone = codeData['visitor_phone'] ?? 'Not provided';
    final String visitDate = codeData['visit_date'] ?? '';
    final String startTime = codeData['start_time'] ?? '';
    final String endTime = codeData['end_time'] ?? '';
    
    // MODIFIED: Check for 'access_code' or 'code' to ensure we get the value.
    final String accessCode = codeData['access_code'] ?? codeData['code'] ?? 'N/A';

    // Optional: format date for readability
    String formattedDate = '';
    try {
      formattedDate =
          DateFormat('EEEE, MMM d, yyyy').format(DateTime.parse(visitDate));
    } catch (e) {
      formattedDate = visitDate;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitor Pass'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // ✅ Visitor Info
            Text(
              visitorName,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            // REMOVED: const SizedBox(height: 8),
            // REMOVED: Text('Phone: $visitorPhone'),
            const SizedBox(height: 8), 
            Text('Visit Date: $formattedDate'),
            const SizedBox(height: 8),
            Text('Time: $startTime - $endTime'),
            const SizedBox(height: 20),
            const Divider(thickness: 1.2),
            const SizedBox(height: 20),

            // ✅ QR Code Display
            QrImageView(
              data: accessCode,
              version: QrVersions.auto,
              size: 220.0,
              backgroundColor: Colors.white,
            ),

            const SizedBox(height: 25),
            Text(
              'Access Code: $accessCode',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),

            // ✅ Done Button
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Done'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
 }
}