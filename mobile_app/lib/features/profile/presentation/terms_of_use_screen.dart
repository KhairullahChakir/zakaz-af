import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/localization/language_provider.dart';
import '../../../core/theme/theme_context.dart';

const Color kPrimaryOrange = Color(0xFFFF6B00);

class TermsOfUseScreen extends ConsumerWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(ref.tr('terms_of_use'), style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: context.appBarColor,
        foregroundColor: context.appBarTextColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Last Updated
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: kPrimaryOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                ref.tr('last_updated'),
                style: const TextStyle(
                  color: kPrimaryOrange,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            _buildSection(
              context,
              ref.tr('terms_intro_title'),
              ref.tr('terms_intro_content'),
            ),
            
            _buildSection(
              context,
              ref.tr('terms_account_title'),
              ref.tr('terms_account_content'),
            ),
            
            _buildSection(
              context,
              ref.tr('terms_property_title'),
              ref.tr('terms_property_content'),
            ),
            
            _buildSection(
              context,
              ref.tr('terms_conduct_title'),
              ref.tr('terms_conduct_content'),
            ),
            
            _buildSection(
              context,
              ref.tr('terms_liability_title'),
              ref.tr('terms_liability_content'),
            ),
            
            _buildSection(
              context,
              ref.tr('terms_changes_title'),
              ref.tr('terms_changes_content'),
            ),
            
            const SizedBox(height: 32),
            
            // Accept Button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: kPrimaryOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  ref.tr('i_understand'),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: context.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
