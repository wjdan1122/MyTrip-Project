import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PlaceTimelineCard extends StatelessWidget {
  final String time;
  final String name;
  final String description;
  final Color dotColor;
  final Color cardColor;
  final bool isLast;
  final VoidCallback? onDelete;
  final VoidCallback? onEditTime;
  final VoidCallback? onRegenerate;
  final bool isReordering;
  final int index;
  final VoidCallback? onTap;

  const PlaceTimelineCard({
    super.key,
    required this.time,
    required this.name,
    required this.description,
    required this.dotColor,
    required this.cardColor,
    this.isLast = false,
    this.onDelete,
    this.onEditTime,
    this.onRegenerate,
    this.isReordering = false,
    this.index = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline column
          SizedBox(
            width: 72,
            child: Column(
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: dotColor.withValues(alpha: 0.3),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            dotColor.withValues(alpha: 0.5),
                            dotColor.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Card
          Expanded(
            child: GestureDetector(
              onTap: isReordering ? null : onTap,
              child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (isReordering)
                    ReorderableDragStartListener(
                      index: index,
                      child: const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.drag_indicator, color: AppColors.primaryMedium, size: 20),
                      ),
                    ),
                  // Color placeholder (image substitute)
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Popup menu
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: AppColors.textSecondary, size: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 8,
                    onSelected: (value) {
                      switch (value) {
                        case 'edit_time':
                          onEditTime?.call();
                          break;
                        case 'regenerate':
                          onRegenerate?.call();
                          break;
                        case 'delete':
                          onDelete?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit_time',
                        child: Row(
                          children: [
                            Icon(Icons.access_time, color: AppColors.textPrimary, size: 20),
                            const SizedBox(width: 12),
                            const Text('Edit Time'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'regenerate',
                        child: Row(
                          children: [
                            Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
                            const SizedBox(width: 12),
                            const Text('Regenerate Place'),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                            const SizedBox(width: 12),
                            Text('Delete', style: TextStyle(color: AppColors.error)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }
}
