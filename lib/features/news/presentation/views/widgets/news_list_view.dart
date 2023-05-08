import 'package:colon_app/core/widgets/custom_alert.dart';
import 'package:colon_app/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utlis/functions/launch_url.dart';
import '../../../../../core/widgets/custom_error_widget.dart';
import '../../../../../core/widgets/custom_loading_indicator.dart';
import '../../manager/news_cubit/news_cubit.dart';
import 'news_list_view_item.dart';

class NewsListView extends StatelessWidget {
  const NewsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsCubit, NewsState>(
      builder: (context, state) {
        if (state is NewsSuccess) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Responsive.isDesktop(context) ? 4 : 1,
              childAspectRatio: Responsive.isDesktop(context) ? 1.5 : 2.5,
            ),
            itemCount: state.news.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return SizedBox(
                height: 20.0,
                child: NewsListViewItem(
                  title: state.news[index].title!,
                  date: state.news[index].publishedAt!,
                  src: state.news[index].urlToImage ??
                      'https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png',
                  onTap: () {
                    if (state.news[index].url == null) {
                      const CustomAlert(
                        title: 'News',
                        content: 'Cannot Launch this link',
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => WebViewScreen(state.news[index]
                              .url!), // Todo make screen to show news
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        } else if (state is NewsFailure) {
          return CustomErrorWidget(errMessage: state.errMessage);
        } else {
          return const CustomLoadingIndicator();
        }
      },
    );
  }
}
