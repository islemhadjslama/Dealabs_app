import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String>? onSubmitted; // Callback for search

  const CustomSearchBar({super.key, this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Removed horizontal margin
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity, // takes full available width
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Type here...",
                border: InputBorder.none,
                isDense: true,
              ),
              style: const TextStyle(fontSize: 16),
              onSubmitted: onSubmitted,
            ),
          ),
        ],
      ),
    );
  }
}
