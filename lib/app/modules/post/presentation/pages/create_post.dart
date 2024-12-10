import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:find_it/app/di/locator.dart';
import 'package:find_it/app/modules/building/domain/entities/building_entity.dart';
import 'package:find_it/app/modules/building/presentation/bloc/building_list_bloc.dart';
import 'package:find_it/app/modules/post/domain/entities/post_creation_entity.dart';
import 'package:find_it/app/modules/post/domain/entities/post_entity.dart';
import 'package:find_it/app/modules/post/domain/entities/post_modification_entity.dart';
import 'package:find_it/app/modules/post/domain/enums/item_category.dart';
import 'package:find_it/app/modules/post/domain/enums/post_status.dart';
import 'package:find_it/app/modules/post/domain/enums/post_type.dart';
import 'package:find_it/app/modules/post/presentation/bloc/create_post_bloc.dart';
import 'package:find_it/app/router.gr.dart';
import 'package:find_it/gen/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

@RoutePage()
class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key, this.post});

  final PostEntity? post;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<CreatePostBloc>()),
        BlocProvider(
            create: (_) =>
                sl<BuildingListBloc>()..add(const BuildingListEvent.fetch())),
      ],
      child: _CreatePostPage(post),
    );
  }
}

class _CreatePostPage extends StatefulWidget {
  final PostEntity? post;

  const _CreatePostPage(this.post);

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<_CreatePostPage> {
  PostType? selectedType;
  ItemCategory? selectedCategory;
  PostStatus? selectedStatus;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationDetailController = TextEditingController();
  List<XFile> uploadedImages = [];

  final List<ItemCategory> categories = ItemCategory.values;
  final List<PostType> postTypes = PostType.values;
  BuildingEntity? selectedBuilding;

  @override
  void initState() {
    super.initState();

    if (widget.post != null) {
      final post = widget.post!;
      selectedType = post.type;
      selectedCategory = post.category;
      titleController.text = post.title;
      descriptionController.text = post.description;
      selectedBuilding = post.building;
      locationDetailController.text = post.locationDetail;
      selectedStatus = post.status;
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        uploadedImages.add(image);
      });
    }
  }

  Future<void> _create() async {
    if (selectedType == null) return;
    if (selectedCategory == null) return;
    if (titleController.text.isEmpty) return;
    if (descriptionController.text.isEmpty) return;
    if (selectedBuilding == null) return;
    if (locationDetailController.text.isEmpty) return;

    final bloc = context.read<CreatePostBloc>();
    final blocker = bloc.stream.firstWhere((s) => s.isLoaded);
    bloc.add(CreatePostEvent.create(PostCreationEntity(
      title: titleController.text,
      type: selectedType!,
      building: selectedBuilding!,
      locationDetail: locationDetailController.text,
      itemType: selectedCategory!,
      description: descriptionController.text,
      image: uploadedImages.map((img) => File(img.path)).toList(),
    )));
    await blocker;
    if (!mounted) return;
    context.maybePop();
    DetailRoute(post: bloc.state.post).push(context);
  }

  Future<void> _modify() async {
    if (selectedType == null) return;
    if (selectedCategory == null) return;
    if (titleController.text.isEmpty) return;
    if (descriptionController.text.isEmpty) return;
    if (selectedBuilding == null) return;
    if (locationDetailController.text.isEmpty) return;
    if (selectedStatus == null) return;

    final bloc = context.read<CreatePostBloc>();
    final blocker = bloc.stream.firstWhere((s) => s.isLoaded);
    bloc.add(CreatePostEvent.modify(
        widget.post!.id,
        PostModificationEntity(
          title: titleController.text,
          type: selectedType!,
          building: selectedBuilding!,
          locationDetail: locationDetailController.text,
          itemType: selectedCategory!,
          description: descriptionController.text,
          status: selectedStatus!,
        )));
    await blocker;
    if (!mounted) return;
    context.router.popUntilRoot();
    DetailRoute(post: bloc.state.post).push(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: widget.post == null
            ? Text(context.t.create.page_title)
            : Text(context.t.create.page_title_modify),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: context.t.create.title,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<PostType>(
                value: selectedType,
                items: PostType.values
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(context.t
                              .post_type(context: PostType.values[type.index])),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: context.t.create.post_type,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              selectedType == null
                  ? const SizedBox()
                  : Column(
                      children: [
                        BlocBuilder<BuildingListBloc, BuildingListState>(
                            builder: (context, state) {
                          return DropdownButtonFormField<BuildingEntity>(
                            value: selectedBuilding,
                            items: state.list
                                .map((building) => DropdownMenuItem(
                                      value: building,
                                      child: Text(building.displayName),
                                    ))
                                .toList(),
                            onChanged: (value) =>
                                setState(() => selectedBuilding = value),
                            decoration: InputDecoration(
                              labelText: selectedType == PostType.lost
                                  ? context.t.create.location_lost
                                  : context.t.create.location_found,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          );
                        }),
                        const SizedBox(height: 16),
                        TextField(
                          controller: locationDetailController,
                          decoration: InputDecoration(
                            labelText: selectedType == PostType.lost
                                ? context.t.create.location_lost
                                : context.t.create.location_found,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
              DropdownButtonFormField<ItemCategory>(
                value: selectedCategory,
                items: categories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(context.t.category(context: category)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: context.t.create.item_type,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: context.t.create.description,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              if (widget.post != null) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<PostStatus>(
                  value: widget.post!.status,
                  items: PostStatus.values
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(
                              widget.post!.type == PostType.lost
                                  ? context.t.lost_status(context: status)
                                  : context.t.found_status(context: status),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: context.t.create.status,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              if (widget.post != null) ...[
                for (final image in widget.post!.images)
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(child: Image.network(image)),
                  ),
              ] else ...[
                ElevatedButton(
                  onPressed: pickImage,
                  child: Text(context.t.create.image),
                ),
                const SizedBox(height: 16),
                uploadedImages.isNotEmpty
                    ? Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: uploadedImages
                            .map((image) => Image.file(
                                  File(image.path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ))
                            .toList(),
                      )
                    : Text(context.t.create.image_empty),
              ],
              const SizedBox(height: 32),
              BlocBuilder<CreatePostBloc, CreatePostState>(
                builder: (context, state) => Stack(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                      ),
                      onPressed: state.isLoading
                          ? null
                          : widget.post == null
                              ? _create
                              : _modify,
                      child: widget.post == null
                          ? Text(context.t.create.submit)
                          : Text(context.t.create.modify),
                    ),
                    if (state.isLoading)
                      const Positioned.fill(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
