import 'package:flutter_finalproject/consts/consts.dart';

class PrivacyPolicySceen extends StatelessWidget {
  const PrivacyPolicySceen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy').text
            .size(28)
            .fontFamily(semiBold)
            .color(blackColor)
            .make(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '1. Information Collection',
                style: TextStyle(fontFamily: bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'We are committed to protecting your privacy and ensuring that your personal information is handled in a safe and responsible manner. The information we collect may include your name, email address, and other contact details. We collect this information to provide and improve our services, and to enhance your user experience. We also collect data on how you use our application to better understand user behavior and preferences.',
              ),
              SizedBox(height: 16),
              Text(
                '2. Use of Information',
                style: TextStyle(fontFamily: bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'The information we collect is used to improve our services and enhance your user experience. This may include analyzing usage data, conducting research, and implementing new features based on user feedback. We may also use your information to communicate with you about updates, changes, or other information relevant to your use of the application. We will not sell, trade, or otherwise transfer your personal information to outside parties without your consent, except as required by law.',
              ),
              SizedBox(height: 16),
              Text(
                '3. Data Security',
                style: TextStyle(fontFamily: bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'We implement a variety of security measures to maintain the safety of your personal information. Your personal data is stored in secure networks and is only accessible by a limited number of persons who have special access rights to such systems, and are required to keep the information confidential. We use industry-standard encryption technologies to protect your data during transmission.',
              ),
              SizedBox(height: 16),
              Text(
                '4. Third-Party Disclosure',
                style: TextStyle(fontFamily: bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'We do not sell, trade, or otherwise transfer your personal information to outside parties. This does not include trusted third parties who assist us in operating our application, conducting our business, or servicing you, so long as those parties agree to keep this information confidential. We may also release your information when we believe release is appropriate to comply with the law, enforce our application policies, or protect our rights, property, or safety.',
              ),
              SizedBox(height: 16),
              Text(
                '5. Cookies',
                style: TextStyle(fontFamily: bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Our application may use cookies to enhance your experience. Cookies are small files that a site or its service provider transfers to your device\'s hard drive through your web browser (if you allow) that enables the site\'s or service provider\'s systems to recognize your browser and capture and remember certain information. You can choose to disable cookies through your individual browser options. However, disabling cookies may affect your ability to use certain ',
              ),
              SizedBox(height: 16),
              Text(
                '6. Children\'s Privacy',
                style: TextStyle(fontFamily: bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Protecting the privacy of children is especially important. Our application is not intended for use by individuals under the age of 13. We do not knowingly collect personal information from children under 13. If we become aware that we have inadvertently received personal information from a user under the age of 13, we will delete such information from our records.',
              ),
              SizedBox(height: 16),
              Text(
                '7. Changes to This Privacy Policy',
                style: TextStyle(fontFamily: bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'We reserve the right to update or change our Privacy Policy at any time. Any changes will be posted on this page, and the date of the latest revision will be indicated at the top. We encourage you to review this Privacy Policy periodically to stay informed about how we are protecting your information. Your continued use of the application after any changes to this policy will constitute your acknowledgment and acceptance of the changes.',
              ),
              SizedBox(height: 16),
              Text(
                '8. Contact Us',
                style: TextStyle(fontFamily: bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'If you have any questions or concerns about this Privacy Policy, please contact us at [Mail : Nutkatenoeytung@gmail.com]. We are committed to addressing your inquiries and resolving any issues promptly. Your feedback is valuable to us, and we strive to improve our services based on your input. Please provide detailed information about your concern to help us assist you more effectively. We aim to respond to all inquiries within a reasonable timeframe. For privacy-related questions, please refer to this Privacy Policy for more details on how we handle your personal information.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
