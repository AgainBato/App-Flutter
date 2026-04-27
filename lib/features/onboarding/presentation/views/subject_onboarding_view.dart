import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fe_mobile/main.dart'; // Để chuyển sang MainLayoutScreen
import '../viewmodels/subject_onboarding_viewmodel.dart';

class SubjectOnboardingView extends StatelessWidget {
  const SubjectOnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SubjectOnboardingViewModel>();
    const primaryColor = Color(0xFF4A7DFF);

    return Scaffold(
      appBar: AppBar(title: const Text('Thiết lập môn học')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text('Chọn các môn học bạn quan tâm'),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: viewModel.popularSubjects.map((s) => ActionChip(
                label: Text('${s.iconPath} ${s.name}'),
                onPressed: () => viewModel.addSubject(s),
              )).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: viewModel.hasAddedSubjects && !viewModel.isProcessing 
                  ? () async {
                      await viewModel.completeOnboarding();
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const MainLayoutScreen()),
                        );
                      }
                    } 
                  : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: viewModel.isProcessing 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text('Hoàn tất', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}