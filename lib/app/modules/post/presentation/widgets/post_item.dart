import 'package:find_it/app/modules/building/domain/entities/building_entity.dart';
import 'package:find_it/app/modules/post/domain/entities/post_entity.dart';
import 'package:find_it/app/modules/post/domain/enums/post_type.dart';
import 'package:find_it/app/router.gr.dart';
import 'package:find_it/gen/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostItem extends StatelessWidget {
  const PostItem({super.key, required this.item});
  final PostEntity item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: const SizedBox(width: 50, height: 50),
      ),
      title: Text(
        item.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
          '${item.building.displayName}\n${DateFormat.yMd().format(item.createdAt)}'),
      isThreeLine: true,
      onTap: () {
        DetailRoute(post: item).push(context);
      },
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.type == PostType.found
                ? context.t.lost_status(context: item.status)
                : context.t.found_status(context: item.status),
          ),
        ],
      ),
    );
  }
}
