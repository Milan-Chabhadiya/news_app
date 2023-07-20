import 'package:flutter/material.dart';
import 'package:news_app/models/model.dart';
import 'package:news_app/modules/home_page/components/na_network_image.dart';
import 'package:news_app/utils/extensions.dart';

class NewsTile extends StatelessWidget {
  const NewsTile({required this.article, super.key});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      shadowColor: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 130,
        width: context.screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          // color: Colors.grey.shade100,
        ),
        child: Row(
          children: [
            Container(
              height: 130,
              width: 130,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white.withAlpha(200),
              ),
              clipBehavior: Clip.hardEdge,
              child: NaNetworkImage(
                url: article.media!,
                fit: BoxFit.cover,
                width: 200,
                height: 200,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            article.topic!.upperCaseFirstLatter(),
                            style: Theme.of(context).textTheme.titleSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            article.publishedDate.dayAgo,
                            style: Theme.of(context).textTheme.titleSmall,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      article.title!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      article.author!,
                      style: Theme.of(context).textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
