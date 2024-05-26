import 'package:flutter/material.dart';
import 'package:flutter_finalproject/consts/styles.dart';

class TermAndConditions extends StatelessWidget {
  const TermAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '1. Acceptance of Terms',
                style: TextStyle(fontFamily: bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'By accessing and using our application, you agree to comply with and be bound by these terms and conditions. These terms apply to all users of the application. If you do not agree to these terms and conditions, please refrain from using our application. Continued use of the application signifies your acceptance of these terms. We encourage you to review these terms regularly to ensure you are aware of any changes. If you have any questions or concerns regarding these terms, please contact us before using the application. Your use of the application after any changes to the terms constitutes your agreement to the updated terms.',
              ),
              SizedBox(height: 16),
              Text(
                '2. Modifications to Terms',
                style: TextStyle(fontFamily: bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'We reserve the right to modify or update these terms and conditions at any time without prior notice. Such modifications will be effective immediately upon posting on the application. It is your responsibility to review the terms and conditions periodically. Continued use of the application following any changes constitutes your acceptance of the new terms and conditions. If you do not agree with any modifications, you must discontinue using the application immediately. We recommend that you bookmark this page and check back regularly to stay informed of any updates. Changes to the terms may include, but are not limited to, the addition of fees, new functionalities, or changes in the way we manage user data.',
              ),
              SizedBox(height: 16),
              Text(
                '3. Educational Use Only',
                style: TextStyle(fontFamily: bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'This application is intended solely for educational purposes and is developed as part of a graduation requirement to apply knowledge into a practical project. The application is not designed for commercial use, revenue generation, or imitation of any other works. Users are expected to utilize the application in a manner consistent with its educational purpose. Any commercial exploitation of the application is strictly prohibited. This includes, but is not limited to, selling, licensing, or distributing the application or its content for commercial gain. Users are also prohibited from modifying the application to serve commercial purposes. The application is provided "as is" for educational use, and we make no guarantees regarding its suitability for any other purpose.',
              ),
              SizedBox(height: 16),
              Text(
                '4. Limitation of Liability',
                style: TextStyle(fontFamily: bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'We shall not be liable for any damages or losses arising from the use or inability to use our application, including but not limited to direct, indirect, incidental, or consequential damages. As this application is intended for educational purposes only, any issues encountered will not result in liability on our part. Users assume full responsibility for any actions taken based on the information provided through the application. We do not warrant that the application will be error-free, uninterrupted, or free from viruses or other harmful components. Users are encouraged to use the application at their own risk. In no event shall our liability exceed the amount paid by the user, if any, for accessing the application. This limitation of liability applies to the fullest extent permitted by law.',
              ),
              SizedBox(height: 16),
              Text(
                '5. Intellectual Property Rights',
                style: TextStyle(fontFamily: bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'All content, including but not limited to text, graphics, logos, icons, images, and software, in this application is our property and is protected by law. Unauthorized use, copying, or distribution of this content without our written permission is strictly prohibited. Users are granted a limited, non-exclusive, and revocable license to access and use the content for personal, educational purposes only. Any modification, reproduction, or distribution of the content for commercial purposes is prohibited. We reserve the right to terminate the license and take legal action against any unauthorized use of our intellectual property. The application may also contain content that is the property of third parties, which is used with permission. Users must respect the intellectual property rights of these third parties as well.',
              ),
              SizedBox(height: 16),
              Text(
                '6. Termination of Use',
                style: TextStyle(fontFamily: bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'We reserve the right to terminate your use of the application at any time if you violate these terms and conditions or use the application for non-educational purposes. Termination may occur without prior notice and at our sole discretion. Upon termination, your right to use the application will immediately cease. We also reserve the right to remove or modify any content that violates these terms or is deemed inappropriate. Users are prohibited from attempting to circumvent any restrictions or reinstating access after termination. We are not liable for any damages resulting from the termination of your access to the application. If you wish to terminate your account, please contact us.',
              ),
              SizedBox(height: 16),
              Text(
                '7. Governing Law',
                style: TextStyle(fontFamily: bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'These terms and conditions shall be governed by and construed in accordance with the laws of our jurisdiction, without regard to its conflict of law principles. Any disputes arising out of or relating to these terms shall be subject to the exclusive jurisdiction of the courts in our jurisdiction. Users agree to submit to the personal jurisdiction of these courts for the resolution of any disputes. This agreement constitutes the entire understanding between the parties concerning its subject matter and supersedes all prior agreements and understandings. If any provision of these terms is found to be invalid or unenforceable, the remaining provisions shall continue in full force and effect.',
              ),
              SizedBox(height: 16),
              Text(
                '8. Contact Us',
                style: TextStyle(fontFamily: bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'If you have any questions or concerns about these terms and conditions, please contact us at [Mail : nutkatenoeytung@gmail.com ]. We are committed to addressing your inquiries and resolving any issues promptly. Your feedback is valuable to us, and we strive to improve our services based on your input. Please provide detailed information about your concern to help us assist you more effectively. We aim to respond to all inquiries within a reasonable timeframe.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
