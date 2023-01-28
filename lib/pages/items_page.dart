import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_sqlite/db/items_database.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../model/item.dart';

class ItemsPage extends StatefulWidget {
  // const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  late List<Item> items;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshItems();
  }

  @override
  void dispose() {
    ItemsDatabase.instace.close();
    super.dispose();
  }

  Future refreshItems() async {
    setState(() => isLoading = true);
    this.items = await ItemsDatabase.instace.readAllNote();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "List of items",
          style: TextStyle(fontSize: 24),
        ),
        actions: const [
          Icon(Icons.search),
          SizedBox(
            width: 27,
          )
        ],
      ),
      body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : items.isEmpty
                  ? const Text("No items",
                      style: TextStyle(color: Colors.white))
                  : Text("need update app")
          // buildItems(items)
          ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () async {
          // await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddEdje));
          refreshItems();
        },
      ),
    );
  }

  // Widget buildItems(List<Item> items) {
  //   return items.map((e) => e.name);
  // );

  //   return GridView.custom(
  //     padding: EdgeInsets.all(8),
  //       gridDelegate: SliverQuiltedGridDelegate(
  //         crossAxisCount: 4,
  //         mainAxisSpacing: 4,
  //         crossAxisSpacing: 4,
  //         repeatPattern: QuiltedGridRepeatPattern.inverted,
  //         pattern: [
  //           const
  //         ],
  //       ),
  //       childrenDelegate: null);;
  // }
}
