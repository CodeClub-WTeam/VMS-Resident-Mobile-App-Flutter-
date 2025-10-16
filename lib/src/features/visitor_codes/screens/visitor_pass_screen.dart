import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart'; 
// NOTE: For production, you MUST also add 'package:url_launcher/url_launcher.dart' 
// to your imports and pubspec.yaml

// Placeholder stubs for the url_launcher package since I cannot import it directly
Future<bool> canLaunchUrl(Uri url) async => true; // Simulating availability
Future<bool> launchUrl(Uri url, {LaunchMode mode = LaunchMode.platformDefault}) async {
  // Production code would actually launch the URL.
  // We'll use a print/snackbar to simulate success.
  debugPrint('Attempting to launch: ${url.toString()}');
  return true; 
}
enum LaunchMode { platformDefault }
// End Placeholder stubs

// FIX 1: Converted StatelessWidget to StatefulWidget
class VisitorPassScreen extends StatefulWidget {
  final Map<String, dynamic> codeData;

  const VisitorPassScreen({super.key, required this.codeData});

  @override
  State<VisitorPassScreen> createState() => _VisitorPassScreenState();
}

class _VisitorPassScreenState extends State<VisitorPassScreen> {
  
  // Function with platform-specific deep linking logic
  void _sharePass(String platform) async {
    // Access codeData via widget.codeData
    final String visitorName = widget.codeData['visitor_name'] ?? 'Visitor';
    final String accessCode = widget.codeData['access_code'] ?? widget.codeData['code'] ?? 'N/A';
    
    // Placeholder for the actual shareable link/QR code URL
    final String shareUrl = 'https://estateguard.app/pass/$accessCode';
    
    final String messageBody = 'Hello $visitorName, your EstateGuard Visitor Pass is attached. Access code: $accessCode. Use this link for details: $shareUrl';
    
    Uri uri;

    // --- 1. Functional Copy Link Logic ---
    if (platform == 'Copy Link') {
      Clipboard.setData(ClipboardData(text: shareUrl)).then((_) {
        // FIX: Guard use of context/ScaffoldMessenger AFTER Clipboard.setData() completes
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Access link copied to clipboard!'),
            duration: Duration(seconds: 2),
          ),
        );
      });
      return; 
    }
    
    // --- 2. WhatsApp Sharing Logic (Deep Link) ---
    else if (platform == 'WhatsApp') {
      final whatsappMessage = Uri.encodeComponent(messageBody);
      uri = Uri.parse('whatsapp://send?text=$whatsappMessage');
    }

    // --- 3. Email Sharing Logic (Deep Link) ---
    else if (platform == 'Email') {
      const emailSubject = 'Your EstateGuard Visitor Pass';
      final emailSubjectEncoded = Uri.encodeComponent(emailSubject);
      final emailBodyEncoded = Uri.encodeComponent(messageBody);
      uri = Uri.parse('mailto:?subject=$emailSubjectEncoded&body=$emailBodyEncoded');
    }

    // --- 4. SMS Sharing Logic (Deep Link) ---
    else if (platform == 'SMS') {
      final smsBodyEncoded = Uri.encodeComponent(messageBody);
      uri = Uri.parse('sms:?body=$smsBodyEncoded'); 
    } else {
      return; 
    }
    
    // --- Universal URL Launch (The main async gap) ---
    if (await canLaunchUrl(uri)) {
      if (!mounted) return; // Guard before the second await/UI change
      
      if (await launchUrl(uri, mode: LaunchMode.platformDefault)) {
        if (!mounted) return; // Guard before using context for SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // FIX: Removed unnecessary braces
            content: Text('Launched $platform successfully!'), 
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        if (!mounted) return; // Guard before using context for SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // FIX: Removed unnecessary braces
            content: Text('Could not launch $platform. Please check the app is installed.'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } else {
      if (!mounted) return; // Guard before using context for SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // FIX: Removed unnecessary braces
          content: Text('$platform is not available on this device.'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Helper widget to build a circular share icon button
  Widget _buildShareButton(
      BuildContext context, IconData icon, String platform, Color color) {
    return Column(
      children: [
        InkWell(
          // FIX: Call the updated function without passing context
          onTap: () => _sharePass(platform), 
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access codeData via widget.codeData
    final String visitorName = widget.codeData['visitor_name'] ?? 'Unknown Visitor';
    final String visitDate = widget.codeData['visit_date'] ?? '';
    final String startTime = widget.codeData['start_time'] ?? '';
    final String endTime = widget.codeData['end_time'] ?? '';
    final String accessCode = widget.codeData['access_code'] ?? widget.codeData['code'] ?? 'N/A';
    final String passDataForQr = 'EG|$accessCode'; 

    String formattedDate = '';
    try {
      formattedDate = DateFormat('EEEE, MMM d, yyyy').format(DateTime.parse(visitDate));
    } catch (e) {
      formattedDate = visitDate;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitor Pass'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              const Text(
                'Maple Grove Estate',
                style: TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              QrImageView(
                data: passDataForQr, 
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
              ),

              const SizedBox(height: 15),
              
              Text(
                accessCode,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                'Valid: $formattedDate, $startTime - $endTime',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 15),

              const Divider(thickness: 1.2),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Visitor: $visitorName', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 5),
                      const Text('Resident: David Johnson', style: TextStyle(fontSize: 16, color: Colors.grey)), 
                      const Text('Home: Plot 12, Maple Street', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              
              // Share Pass Section
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Share Pass',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                ),
              ),
              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildShareButton(context, Icons.chat, 'WhatsApp', Colors.green),
                  _buildShareButton(context, Icons.email_outlined, 'Email', Colors.blue),
                  _buildShareButton(context, Icons.sms_outlined, 'SMS', Colors.grey),
                  _buildShareButton(context, Icons.link, 'Copy Link', Colors.blueGrey), 
                ],
              ),
              const SizedBox(height: 25),

              // Cancel Pass Button 
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cancel Pass functionality not yet implemented.')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.red, width: 1.5)),
                  ),
                  child: const Text('Cancel Pass',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              
              const SizedBox(height: 20), 

              // Done Button (to pop the screen)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                  label: const Text('Done', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 20), 
            ],
          ),
        ),
      ),
    );
  }
}