import 'package:flutter/material.dart';

class SearchHistory extends StatelessWidget {
  const SearchHistory({
    super.key,
    required this.history,
    required this.onTapHistory,
    required this.onClearHistory,
  });

  final List<String> history;
  final ValueChanged<String> onTapHistory;
  final Future<void> Function() onClearHistory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (history.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history_rounded, color: colorScheme.primary, size: 36),
            const SizedBox(height: 12),
            Text(
              'No recent searches yet',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your last 20 searches will appear here for one-tap access.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Recent searches',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: onClearHistory,
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Clear all'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == history.length - 1 ? 0 : 10,
                  ),
                  child: ActionChip(
                    avatar: Icon(
                      Icons.history_rounded,
                      color: colorScheme.primary,
                      size: 18,
                    ),
                    label: Text(item),
                    onPressed: () => onTapHistory(item),
                    side: BorderSide(
                      color: colorScheme.primary.withValues(alpha: 0.12),
                    ),
                    backgroundColor: Colors.white,
                    labelStyle: theme.textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
