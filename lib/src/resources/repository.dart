import 'dart:async';
import 'package:news/src/models/item_model.dart';
import 'news_api_provider.dart';
import 'news_db_provider.dart';

class Repository {
  List<Source> sources = <Source>[
    NewsApiProvider(),
    dbProvider,
  ];

  List<Cache> caches = <Cache>[
    dbProvider,
  ];

  Future<List<int>> fetchTopIds() {
    return sources[0].fetchTopIds();
  }

  Future<ItemModel> fetchItem(int id) async {
    ItemModel itemModel;
    Source source;

    for (source in sources) {
      itemModel = await source.fetchItem(id);
      if (itemModel != null) {
        break;
      }
    }

    for (var cache in caches) {
      cache.addItem(itemModel);
    }

    return itemModel;
  }
}

abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
}
