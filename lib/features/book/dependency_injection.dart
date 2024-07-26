import 'package:bookapp/features/book/data/datasouces/remote/chat_api_service.dart';
import 'package:bookapp/features/book/data/repositories/chat_repository_impl.dart';
import 'package:bookapp/features/book/domain/usecases/chat_usecase.dart';
import 'package:bookapp/features/book/presentation/controllers/chat_tab_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:bookapp/features/book/data/datasouces/remote/auth_api_service.dart';
import 'package:bookapp/features/book/data/datasouces/remote/book_api_service.dart';
import 'package:bookapp/features/book/data/datasouces/remote/profile_api_service.dart';
import 'package:bookapp/features/book/data/repositories/auth_repository_impl.dart';
import 'package:bookapp/features/book/data/repositories/book_repository_impl.dart';
import 'package:bookapp/features/book/data/repositories/bookmark_repository_impl.dart';
import 'package:bookapp/features/book/data/repositories/userprofile_repository_impl.dart';
import 'package:bookapp/features/book/domain/repositories/auth_repository.dart';
import 'package:bookapp/features/book/domain/repositories/book_repository.dart';
import 'package:bookapp/features/book/domain/repositories/bookmark_repository.dart';
import 'package:bookapp/features/book/domain/repositories/userprofile_repository.dart';
import 'package:bookapp/features/book/domain/usecases/auth_usecase.dart';
import 'package:bookapp/features/book/domain/usecases/fetch_bookmarks.dart';
import 'package:bookapp/features/book/domain/usecases/fetch_books_usecase.dart';
import 'package:bookapp/features/book/domain/usecases/user_profile_usecase.dart';
import 'package:bookapp/features/book/presentation/controllers/auth_controller.dart';
import 'package:bookapp/features/book/presentation/controllers/book_controller.dart';
import 'package:bookapp/features/book/presentation/controllers/bookmark_controller.dart';
import 'package:bookapp/features/book/presentation/controllers/menu_controllers/userprofile_controller.dart';
import 'package:bookapp/features/book/presentation/controllers/tab_controller.dart';

import 'data/datasouces/remote/bookmarks_api_service.dart';
import 'domain/repositories/chat_repository.dart';

class DependencyBinding extends Bindings {
  @override
  void dependencies() {
    // Data sources
    Get.lazyPut<RemoteAuthDataSource>(() => RemoteAuthDataSource(client: http.Client()));
    Get.lazyPut<RemoteBookDataSource>(() => RemoteBookDataSource(client: http.Client()));
    Get.lazyPut<RemoteBookmarkDataSource>(() => RemoteBookmarkDataSource(client: http.Client()));
    Get.lazyPut< RemoteChatApiDataSource>(() => RemoteChatApiDataSource(client: http.Client()));
    Get.lazyPut<RemoteProfileDataSource>(() => RemoteProfileDataSource(client: http.Client()));

    // Repositories
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find()));
    Get.lazyPut<BookRepository>(() => BookRepositoryImpl(Get.find()));
    Get.lazyPut<BookmarkRepository>(() => BookmarkRepositoryImpl(Get.find<RemoteBookmarkDataSource>()));
    Get.lazyPut<ChatRepository>(() => ChatRepositoryImpl(Get.find<RemoteChatApiDataSource>()));
    Get.lazyPut<UserprofileRepository>(() => ProfileRepositoryImpl(Get.find()));

    // Use cases
    Get.lazyPut(() => LoginUseCase(Get.find()));
    Get.lazyPut(() => SignUpUseCase(Get.find()));
    Get.lazyPut(() => AuthStatusUseCase(Get.find()));
    Get.lazyPut(() => UserProfileUseCase(Get.find()));
    Get.lazyPut(() => FetchBookInPopularUseCase(Get.find()));
    Get.lazyPut(() => FetchBookbookShelfUseCase(Get.find()));
    Get.lazyPut(() => FetchBookPDFUseCase(Get.find()));
    Get.lazyPut(() => FetchBookmarksUseCase(Get.find()));
    Get.lazyPut(() => FetchListBookmarksUseCase(Get.find()));
    Get.lazyPut(() => SetBookmarksUseCase(Get.find()));
    Get.lazyPut(() => DeleteBookmarksUseCase(Get.find()));
    Get.lazyPut(() => UploadPdfForChatUseCase(Get.find()));
    Get.lazyPut(() => DeleteChatBookUseCase(Get.find()));
    Get.lazyPut(() => ChatMessageUseCase(Get.find()));


    // Controllers
    Get.lazyPut(() => AuthController(
      loginUseCase: Get.find(),
      signUpUseCase: Get.find(),
      authStatusUseCase: Get.find(),
    ));
    Get.lazyPut(() => BookController(
      fetchBookInPopularUseCase: Get.find(),
      fetchBookbookShelfUseCase: Get.find(),
    ));
    Get.lazyPut(() => UserprofileController(
      userProfileUseCase: Get.find(),
    ));
    Get.lazyPut(() => TabSController(
      fetchBookPDFUseCase: Get.find(),
    ));
    Get.lazyPut(() => BookmarkController(
      fetchBookmarksUseCase: Get.find<FetchBookmarksUseCase>(),
      setBookmarksUseCase: Get.find<SetBookmarksUseCase>(),
      deleteBookmarksUseCase: Get.find<DeleteBookmarksUseCase>(),
      fetchListBookmarksUseCase: Get.find<FetchListBookmarksUseCase>(),
    ));
    Get.lazyPut(() => ChatTabController(
        chatMessageUseCase: Get.find(),
        uploadPdfForChatUseCase: Get.find(),
        deleteChatBookUseCase: Get.find()

    ));
  }
}
