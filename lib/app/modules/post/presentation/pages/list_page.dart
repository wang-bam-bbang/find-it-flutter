import 'package:auto_route/auto_route.dart';
import 'package:find_it/app/di/locator.dart';
import 'package:find_it/app/modules/post/domain/enums/item_category.dart';
import 'package:find_it/app/modules/post/domain/enums/post_type.dart' as domain;
import 'package:find_it/app/modules/post/presentation/bloc/post_list_bloc.dart';
import 'package:find_it/app/modules/post/presentation/widgets/post_item.dart';
import 'package:find_it/app/modules/user/presentation/bloc/user_bloc.dart';
import 'package:find_it/app/modules/user/presentation/pages/profile_page.dart';
import 'package:find_it/app/router.gr.dart';
import 'package:find_it/gen/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PostListBloc>(),
      child: const _Layout(),
    );
  }
}

class _Layout extends StatefulWidget {
  const _Layout();

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> {
  domain.PostType _currentContent = domain.PostType.found;
  ItemCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    context
        .read<PostListBloc>()
        .add(PostListEvent.fetch(_currentContent, category: _selectedCategory));
  }

  void _showFilterModal() {
    ItemCategory? tempCategory = _selectedCategory;

    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        const categories = ItemCategory.values;

        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    '분실물 종류 필터',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return RadioListTile<ItemCategory>(
                          title: Text(context.t.category(context: category)),
                          value: category,
                          groupValue: tempCategory,
                          onChanged: (value) {
                            setModalState(() {
                              tempCategory = value;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            tempCategory = null;
                          });
                        },
                        child: const Text('필터 해제'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedCategory = tempCategory;
                          });
                          Navigator.pop(sheetContext);
                          context.read<PostListBloc>().add(PostListEvent.fetch(
                                domain.PostType.found,
                                category: tempCategory,
                              ));
                        },
                        child: const Text('확인'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentContent = domain.PostType.found;
                      context.read<PostListBloc>().add(
                            PostListEvent.fetch(_currentContent,
                                category: _selectedCategory),
                          );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentContent == domain.PostType.found
                        ? Colors.blue
                        : Colors.grey[200],
                    foregroundColor: _currentContent == domain.PostType.found
                        ? Colors.white
                        : Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(context.t.list.found.label),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentContent = domain.PostType.lost;
                      context.read<PostListBloc>().add(
                            PostListEvent.fetch(_currentContent,
                                category: _selectedCategory),
                          );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentContent == domain.PostType.lost
                        ? Colors.blue
                        : Colors.grey[200],
                    foregroundColor: _currentContent == domain.PostType.lost
                        ? Colors.white
                        : Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(context.t.list.lost.label),
                ),
              ),
            ],
          ),
        ),
        _ListView(
          type: _currentContent,
          category: _selectedCategory,
          key: Key(_currentContent.name),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      buildWhen: (_, c) => c.mapOrNull(done: (v) => true) ?? false,
      builder: (context, state) {
        final authenticated = state.user != null;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.white,
            title: const Text('Find-it'),
            actions: [
              IconButton(
                icon: const Icon(Icons.create),
                onPressed: () {
                  if (!authenticated) {
                    const ProfileRoute().push(context);
                  } else {
                    CreatePostRoute().push(context);
                  }
                },
              ),
              IconButton(
                icon: Badge(
                  isLabelVisible: _selectedCategory != null,
                  child: const Icon(Icons.filter_list),
                ),
                onPressed: _showFilterModal,
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()),
                  );
                },
              ),
            ],
          ),
          body: _buildBody(),
        );
      },
    );
  }
}

class _ListView extends StatelessWidget {
  const _ListView({
    super.key,
    required domain.PostType type,
    this.category,
  }) : _type = type;

  final domain.PostType _type;
  final ItemCategory? category;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SectionTitle(
              title: _type == domain.PostType.found
                  ? context.t.list.found.title
                  : context.t.list.lost.title,
            ),
          ),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildList() {
    return BlocBuilder<PostListBloc, PostListState>(
      builder: (context, state) => ListView.builder(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: state.list.length,
        itemBuilder: (context, index) => PostItem(item: state.list[index]),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
