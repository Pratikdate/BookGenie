
import 'package:bookapp/core/ColorHandler.dart';
import 'package:bookapp/core/FontHandler.dart';
import 'package:bookapp/features/book/domain/%20entities/bookmark.dart';
import 'package:bookapp/features/book/presentation/controllers/bookmark_controller.dart';
import 'package:bookapp/features/book/presentation/pages/chat_tab_view_screen.dart';
import 'package:flutter/material.dart';
import '../../../../core/IconsHandler.dart';
import '../../data/datasouces/remote/bookmarks_api_service.dart';
import '../../data/repositories/bookmark_repository_impl.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../../domain/usecases/fetch_bookmarks.dart';
import '../controllers/tab_controller.dart';
import 'package:get/get.dart';
import 'book_tab_view_screen.dart';

import 'package:http/http.dart' as http;




class BookTabScreen extends StatefulWidget {
  const BookTabScreen({super.key});

  @override
  State<BookTabScreen> createState() => _BookTabScreenState();
}

class _BookTabScreenState extends State<BookTabScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TabSController controller;
  late final bookmarkCntroller;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);

    if (Get.arguments != null && Get.arguments.length >= 2) {
      controller = Get.find<TabSController>();
      controller.fileUrl.value = Get.arguments[0];
      controller.fileUID.value = Get.arguments[1];

      bookmarkCntroller= Get.put(BookmarkController(
        fetchBookmarksUseCase: Get.find<FetchBookmarksUseCase>(),
        setBookmarksUseCase: Get.find<SetBookmarksUseCase>(),
        deleteBookmarksUseCase: Get.find<DeleteBookmarksUseCase>(),
        fetchListBookmarksUseCase: Get.find<FetchListBookmarksUseCase>(),
      ));

      bookmarkCntroller.FetchBookmarks();
      controller.fetchBookPDF();

    } else {
      print('Arguments are not provided');
      Get.back();
    }
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      // Handle tab change
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          leading: const Align(
            alignment: Alignment.topRight,
            child: ThreeDotMenuButton(),
          ),
          bottom: TabBar(
            dividerColor: Colors.transparent,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            controller: _tabController,
            tabs: const [
              Tab(text: "Read Book"),
              Tab(text: "Mr.Chat"),
            ],
          ),
          toolbarHeight: 30,
          leadingWidth: MediaQuery.of(context).size.width,
          backgroundColor: const Color.fromRGBO(51, 51, 51, 1),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            BookTabViewScreen(),
            ChatTabViewScreen()
          ],
        ),
      ),
    );
  }
}



class ThreeDotMenuButton extends StatefulWidget {
  const ThreeDotMenuButton({super.key});

  @override
  State<ThreeDotMenuButton> createState() => _ThreeDotMenuButtonState();
}

class _ThreeDotMenuButtonState extends State<ThreeDotMenuButton> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  late BookmarkController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.put(BookmarkController(
      fetchBookmarksUseCase: Get.find<FetchBookmarksUseCase>(),
      setBookmarksUseCase: Get.find<SetBookmarksUseCase>(),
      deleteBookmarksUseCase: Get.find<DeleteBookmarksUseCase>(),
      fetchListBookmarksUseCase: Get.find<FetchListBookmarksUseCase>(),
    ));
  }

  Future<void> _handleMenuOption(String option, BuildContext context) async {
    switch (option) {
      case "Add Bookmark":
        _openDialog(context);
        break;
      case "Show Bookmarks":
        controller.ShowBookmarks.clear();
        await controller.FetchBookmarks();
        break;
      case "Exit":
        Get.back();
        break;
    }
  }

  Future<void> _openDialog(BuildContext context) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: FontHandler(
        "Add Bookmark",
        color: ColorHandler.normalFont,
        textAlign: TextAlign.left,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(label: Text('Name')),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
                label: Text('Description'), hintText: "Optional"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            String bookmarkName = nameController.text;
            String bookmarkDescription = descriptionController.text;
            controller.SetBookmarks(name: bookmarkName, description: bookmarkDescription);
            nameController.clear();
            descriptionController.clear();

            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onOpened: () {
        controller.ShowBookmarks.clear();
        controller.FetchBookmarks();
      },
      onSelected: (option) => _handleMenuOption(option, context),
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: "Add Bookmark",
            child: FontHandler(
              'Add Bookmark',
              color: ColorHandler.normalFont,
              textAlign: TextAlign.left,
            ),
          ),
          PopupMenuItem<String>(
            value: "Show Bookmarks",
            child: ShowBookmarksButton(),
          ),
          PopupMenuItem<String>(
            value: "Exit",
            child: FontHandler(
              'Exit',
              color: ColorHandler.normalFont,
              textAlign: TextAlign.left,
            ),
          ),
        ];
      },
      icon: Icon(
        IconHandler.three_dot_menue,
        color: Colors.white,
      ),
    );
  }
}

class ShowBookmarksButton extends StatefulWidget {
  const ShowBookmarksButton({super.key});

  @override
  State<ShowBookmarksButton> createState() => _ShowBookmarksButtonState();
}

class _ShowBookmarksButtonState extends State<ShowBookmarksButton> {
  late BookmarkController controller;
  late TabSController tabController;

  @override
  void initState() {
    super.initState();

    controller = Get.put(BookmarkController(
      fetchBookmarksUseCase: Get.find<FetchBookmarksUseCase>(),
      setBookmarksUseCase: Get.find<SetBookmarksUseCase>(),
      deleteBookmarksUseCase: Get.find<DeleteBookmarksUseCase>(),
      fetchListBookmarksUseCase: Get.find<FetchListBookmarksUseCase>(),
    ));
    tabController = Get.find<TabSController>();
  }

  Future<void> _handleMenuOption(String option, BuildContext context) async {
    Navigator.pop(context);
  }

  Widget bookmarkCard(Bookmark choice, BuildContext context) {
    return ListTile(
      onTap: () {
        tabController.pdfViewerController.jumpToPage(choice.page?? tabController.pdfViewerController.pageNumber);
        Navigator.pop(context);
      },
      dense: true,
      visualDensity: const VisualDensity(vertical: -3,horizontal: 4),
      title: FontHandler(
        choice.title,
        color: ColorHandler.normalFont,
        textAlign: TextAlign.left,
        fontsize: 14,
        fontweight: FontWeight.bold,
      ),
      subtitle: FontHandler(
        choice.description,
        color: ColorHandler.normalFont,
        textAlign: TextAlign.left,
        fontsize: 8,
      ),
      trailing: IconButton(
        icon: const Icon(
          IconHandler.delete,
          size: 20,
        ),
        onPressed: () {
          controller.DeleteBookmark(choice.uid??"");
          controller.ShowBookmarks.remove(choice);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (option) => _handleMenuOption(option, context),
      itemBuilder: (BuildContext context) {
        if (controller.ShowBookmarks.isEmpty) {
          return [""].map((dynamic choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text("Bookmark not found"),
            );
          }).toList();
        } else {
          return controller.ShowBookmarks.map((Bookmark choice) {
            return PopupMenuItem<String>(
              value: choice.title,
              child: bookmarkCard(choice, context),
            );
          }).toList();
        }
      },
      child: const FontHandler(
        "Show Bookmarks",
        color: ColorHandler.normalFont,
        textAlign: TextAlign.left,
      ),
    );
  }
}
