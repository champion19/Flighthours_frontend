import 'package:flutter/material.dart';

/// Informational page shown after successful registration
/// Tells the user to verify their email and provides a button to go to Login
class VerificationPage extends StatelessWidget {
  final String email;
  const VerificationPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final isMobile = screenSize.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Registration Complete',
          style: TextStyle(
            fontSize: isMobile ? 18 : 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Hide back button
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isTablet ? 600 : double.infinity,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 16.0 : 24.0,
                          vertical: isMobile ? 16.0 : 24.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Spacer(),

                            // Success icon
                            Container(
                              height: isMobile ? 100 : 120,
                              width: isMobile ? 100 : 120,
                              decoration: BoxDecoration(
                                color: Colors.green.withAlpha(25),
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Icon(
                                Icons.check_circle_outline,
                                color: Colors.green[600],
                                size: isMobile ? 50 : 60,
                              ),
                            ),

                            SizedBox(height: isMobile ? 24 : 32),

                            // Title
                            Text(
                              'Account Created!',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: isMobile ? 24 : 28,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: isMobile ? 16 : 20),

                            // Email icon
                            Container(
                              height: isMobile ? 60 : 70,
                              width: isMobile ? 60 : 70,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withAlpha(25),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: Icon(
                                Icons.mark_email_unread_outlined,
                                color: Theme.of(context).primaryColor,
                                size: isMobile ? 30 : 35,
                              ),
                            ),

                            SizedBox(height: isMobile ? 16 : 20),

                            // Info message
                            Text(
                              'A verification email has been sent to:',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                fontSize: isMobile ? 16 : 18,
                                color: Colors.grey[700],
                              ),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: isMobile ? 8 : 12),

                            // Email address box
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(
                                horizontal: isMobile ? 0 : 16,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 16 : 20,
                                vertical: isMobile ? 12 : 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Text(
                                email,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: isMobile ? 16 : 18,
                                  color: Theme.of(context).primaryColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            SizedBox(height: isMobile ? 24 : 28),

                            // Instructions
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 8 : 16,
                              ),
                              child: Text(
                                'Please check your inbox and click on the verification link to activate your account.',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  fontSize: isMobile ? 14 : 16,
                                  color: Colors.grey[600],
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            SizedBox(height: isMobile ? 12 : 16),

                            // Additional info
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 8 : 16,
                              ),
                              child: Text(
                                'After verifying your email, you can log in with your credentials.',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  fontSize: isMobile ? 14 : 16,
                                  color: Colors.grey[600],
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            SizedBox(height: isMobile ? 40 : 48),

                            // Go to Login button
                            SizedBox(
                              width: double.infinity,
                              height: isMobile ? 50 : 56,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigate to login and remove all previous routes
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/',
                                    (route) => false,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                child: Text(
                                  'Go to Login',
                                  style: TextStyle(
                                    fontSize: isMobile ? 16 : 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            const Spacer(),

                            // Footer note
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 8 : 16,
                              ),
                              child: Text(
                                "Didn't receive the email? Check your spam or junk folder.",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  fontSize: isMobile ? 12 : 13,
                                  color: Colors.grey[500],
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            SizedBox(height: isMobile ? 16 : 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
