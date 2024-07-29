import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:post_repository/post_repository.dart';

part 'get_post_event.dart';
part 'get_post_state.dart';

class GetPostBloc extends Bloc<GetPostEvent, GetPostState> {
  final PostRepository _postRepository;
  DocumentSnapshot? lastDocument;

  GetPostBloc({required PostRepository postRepository})
      : _postRepository = postRepository,
        super(GetPostState.unknown()) {
    on<GetPosts>(_onGetPosts);
    on<LoadMorePosts>(_onLoadMorePosts);
    on<GetPostsByCategory>(_onGetPostsByCategory);
    on<SearchPosts>(_onSearchPosts);
     on<ClearSearch>(_onClearSearch);
  }

  void _onGetPosts(GetPosts event, Emitter<GetPostState> emit) async {
    try {
      lastDocument = null;
      List<Post> posts = await _postRepository.getPost();

      if (posts.isNotEmpty) {
        lastDocument = await FirebaseFirestore.instance
            .collection('artcollection')
            .doc(posts.last.id)
            .get();
      }
      emit(GetPostState.success(posts, pageKey: event.pageKey));
    } catch (_) {
      emit(GetPostState.failure());
    }
  }

  void _onLoadMorePosts(LoadMorePosts event, Emitter<GetPostState> emit) async {
    try {
      List<Post> morePosts =
          await _postRepository.getPost(startAfter: lastDocument);
      if (morePosts.isNotEmpty) {
        lastDocument = await FirebaseFirestore.instance
            .collection('artcollection')
            .doc(morePosts.last.id)
            .get();
        emit(GetPostState.success(state.posts! + morePosts,
            pageKey: event.pageKey));
      }
    } catch (_) {
      emit(GetPostState.failure());
    }
  }

  void _onGetPostsByCategory(
      GetPostsByCategory event, Emitter<GetPostState> emit) async {
    try {
      lastDocument = null;
      List<Post> posts =
          await _postRepository.getPostsByCategory(event.category);
      if (posts.isNotEmpty) {
        lastDocument = await FirebaseFirestore.instance
            .collection('artcollection')
            .doc(posts.last.id)
            .get();
      }
      emit(GetPostState.success(posts, pageKey: event.pageKey));
    } catch (_) {
      emit(GetPostState.failure());
    }
  }

  void _onSearchPosts(SearchPosts event, Emitter<GetPostState> emit) async {
    print('Searching for posts with query: ${event.query}');
    try {
      lastDocument = null;
      List<Post> searchResults = await _postRepository.searchPosts(event.query);
      print('Found ${searchResults.length} posts');
      emit(GetPostState(
        status: GetPostStatus.success,
        posts: state.posts,
        searchResults: searchResults,
        pageKey: state.pageKey,
      ));
    } catch (_) {
      emit(GetPostState.failure());
    }
  }

   void _onClearSearch(ClearSearch event, Emitter<GetPostState> emit) async {
    emit(GetPostState.unknown());
    add(const GetPosts());  // Re-fetch all posts
  }


}
