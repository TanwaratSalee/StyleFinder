import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/Views/news_screen/component/search_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';
import '../../controllers/search_controller.dart';

class SearchScreenPage extends StatelessWidget {
  final String? title;

  const SearchScreenPage({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    final SearchPageController controller = Get.put(SearchPageController());

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(title ?? 'Search'),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(15),
            height: 60,
            child: TextFormField(
              controller: controller.searchController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: whiteColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: fontGrey),
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: const Icon(Icons.search).onTap(() {
                  final searchQuery = controller.searchController.text;
                  if (searchQuery.isNotEmpty) {
                    controller.addToSearchHistory(searchQuery);
                    Get.to(() => SearchScreen(title: searchQuery));
                  }
                }),
                filled: true,
                fillColor: whiteColor,
                hintText: searchanything,
                hintStyle: const TextStyle(color: fontGrey),
              ),
            ),
          ),
          Obx(() {
            if (controller.searchInProgress.isTrue) {
              return const Center(child: CircularProgressIndicator());
            } else if (controller.searchHistory.isEmpty) {
              return controller.searchPerformed.isTrue
                  ? const Center(child: Text('No results found'))
                  : const SizedBox.shrink();
            } else {
              return Expanded(
                child: ListView.builder(
                  itemCount: controller.searchHistory.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(controller.searchHistory[index]),
                      leading: const Icon(Icons.history),
                      onTap: () {
                        Get.to(() => ItemDetails(
                              title: controller.searchHistory[index],
                            ));
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          controller.searchHistory.removeAt(index);
                        },
                      ),
                    );
                  },
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
