import 'package:cached_network_image/cached_network_image.dart';
import 'package:colon_app/core/widgets/custom_loading_indicator.dart';
import 'package:flutter/material.dart';

import 'news_item_date.dart';
import 'news_item_title.dart';

class NewsListViewItem extends StatelessWidget {
  const NewsListViewItem(
      {super.key,
      required this.title,
      required this.date,
      required this.onTap,
      required this.src});

  final String title;
  final String src;
  final String date;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: src,
                width: 140,
                fit: BoxFit.fitWidth,
                placeholder: (context, url) =>
                    const Center(child: CustomLoadingIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    NewsItemTitle(
                      title: title,
                    ),
                    NewsItemDate(date: date),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
