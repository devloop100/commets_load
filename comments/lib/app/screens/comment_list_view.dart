import 'package:comments/app/models/comment_model.dart';
import 'package:comments/app/widgets/Comments_list_item.dart';
import 'package:comments/common/api/remote_api.dart';
import 'package:comments/common/widgets/waving_background.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

// list of comments to be displayed with pagination loading
class CommentsListView extends StatefulWidget {
  const CommentsListView({Key? key}) : super(key: key);

  @override
  State<CommentsListView> createState() => _CommentsListViewState();
}

class _CommentsListViewState extends State<CommentsListView> {
  // limit of comments to be fetched in one page
  static const _pageSize = 20;

  final PagingController<int, CommentModel> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  // calling the api to fetch the comments
  // accepts the page key as input
  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await RemoteApi.getCommentsList(pageKey, _pageSize);

      // if last page is reached, end pagination
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        // if not last page, add the new items to the list
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: WavingBackground(
          child: PagedListView<int, CommentModel>.separated(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<CommentModel>(
              animateTransitions: true,
              itemBuilder: (context, item, index) => CommentsListItem(
                model: item,
              ),
            ),
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
      );
}
