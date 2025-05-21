import 'package:flutter/material.dart';
import 'package:snapdish/utils/app_theme.dart';

class CameraButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CameraButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '拍攝或上傳食材照片',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: onPressed,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.camera_alt_rounded,
              color: Colors.white,
              size: 48,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '點擊拍攝照片',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
} 