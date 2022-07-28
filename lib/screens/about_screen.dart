import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class about_screen extends StatefulWidget {
  about_screen({Key? key}) : super(key: key);

  @override
  State<about_screen> createState() => _about_screenState();
}

class _about_screenState extends State<about_screen> {
  bool isDarkMode(BuildContext context) {
    return Theme.of(context).colorScheme.brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: const Text("關於")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
              child: ClipOval(
                  child: Image.asset(
                "images/about.png",
                width: 150,
                height: 150,
                fit: BoxFit.scaleDown,
              )),
            ),
            const Text(
              "Meet Together",
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 2.5),
              child: Text(
                "KApp",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showAboutDialog(
                    context: context,
                    applicationName: "Meet Together",
                    applicationLegalese: """Introduction
Our privacy policy will help you understand what information we collect at KApp, how KApp uses it, and what choices you have. KApp built the Meet Together app as a free app. This SERVICE is provided by KApp at no cost and is intended for use as is. If you choose to use our Service, then you agree to the collection and use of information in relation with this policy. The Personal Information that we collect are used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.
The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible in our website, unless otherwise defined in this Privacy Policy.
Information Collection and Use
For a better experience while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to users name, email address, gender, location, pictures. The information that we request will be retained by us and used as described in this privacy policy.
The app does use third party services that may collect information used to identify you.
Cookies
Cookies are files with small amount of data that is commonly used an anonymous unique identifier. These are sent to your browser from the website that you visit and are stored on your devices’s internal memory.
This Services does not uses these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collection information and to improve their services. You have the option to either accept or refuse these cookies, and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.
Location Information
Some of the services may use location information transmitted from users' mobile phones. We only use this information within the scope necessary for the designated service.
Device Information
We collect information from your device in some cases. The information will be utilized for the provision of better service and to prevent fraudulent acts. Additionally, such information will not include that which will identify the individual user.
Service Providers
We may employ third-party companies and individuals due to the following reasons:
To facilitate our Service;
To provide the Service on our behalf;
To perform Service-related services; or
To assist us in analyzing how our Service is used.
We want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.
Security
We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.
Children’s Privacy
This Services do not address anyone under the age of 13. We do not knowingly collect personal identifiable information from children under 13. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do necessary actions.
Changes to This Privacy Policy
We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page. These changes are effective immediately, after they are posted on this page.
Contact Us
If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us.
Contact Information:
Email: contact@kapp.ml
""",
                    applicationVersion: "From Kapp",
                    children: [
                      GestureDetector(
                        onTap: () {
                          launchUrl(Uri.parse(
                              "https://sites.google.com/view/kapppp"));
                        },
                        child: const Text(
                          "App隱私權條款(網頁版)",
                          style: TextStyle(
                              fontSize: 15.0,
                              decoration: TextDecoration.underline,
                              color: Colors.blue),
                        ),
                      ),
                    ]);
              },
              child: const Text(
                "隱私權條款",
                style: TextStyle(
                    fontSize: 15.0,
                    decoration: TextDecoration.underline,
                    color: Colors.blue),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Powered by Flutter",
                style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
