import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/news_screen/component/search_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';
import '../../controllers/search_controller.dart'; // Assuming this is where your SearchPageController is

class SearchScreenPage extends StatelessWidget {
  final String? title; // Added to accept a title if needed

  const SearchScreenPage({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    final SearchPageController controller = Get.put(SearchPageController());

    return Scaffold(
      backgroundColor: bgGreylight,
      appBar: AppBar(
        title: Text(title ?? 'Search'), // Use title if provided
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            color: bgGreylight,
            child: TextFormField(
              controller: controller.searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                suffixIcon: Icon(Icons.search).onTap(() {
                  final searchQuery = controller.searchController.text;
                  if (searchQuery.isNotEmpty) {
                    controller.addToSearchHistory(searchQuery);
                    // ทำการเปลี่ยนหน้าไปยังหน้าแสดงผลลัพธ์การค้นหาทันที
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
              // Show a loading spinner or similar if you have a long-running search operation
              return CircularProgressIndicator();
            } else if (controller.searchHistory.isEmpty) {
              // Show "not found" message if there are no search results and search was performed
              return controller.searchPerformed.isTrue
                  ? Center(child: Text('Product not found'))
                  : SizedBox.shrink();
            } else {
              // Show search history or results
              return Expanded(
                child: ListView.builder(
                  itemCount: controller.searchHistory.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(controller.searchHistory[index]),
                      leading: Icon(Icons.history),
                      onTap: () {
                        // Use the search query again
                        Get.to(() => SearchScreen(
                              title: controller.searchHistory[index],
                            ));
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          // Remove a single entry from the history
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
