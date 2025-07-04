import 'package:flutter/material.dart';
import '../objects/sync_service.dart';

class UpdatePopup extends StatelessWidget {
  const UpdatePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0D0D0D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            _PopupTitle(),
            SizedBox(height: 16),
            _PopupMessage(),
            SizedBox(height: 24),
            _PopupActions(),
          ],
        ),
      ),
    );
  }
}

class _PopupTitle extends StatelessWidget {
  const _PopupTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'New version is now available',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _PopupMessage extends StatelessWidget {
  const _PopupMessage();

  @override
  Widget build(BuildContext context) {
    return const Text(
      "We have checked that there's a newer version available. Do you want to update now?",
      style: TextStyle(
        fontSize: 16,
        color: Colors.white70,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _PopupActions extends StatelessWidget {
  const _PopupActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Maybe Later'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              // logic
              Navigator.of(context).pop();
              SyncService.instance.performFullPullSync();
            },
            child: const Text('Update'),
          ),
        ),
      ],
    );
  }
}
