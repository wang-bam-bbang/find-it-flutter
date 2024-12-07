import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:find_it/app/modules/post/domain/enums/item_category.dart';
import 'package:find_it/app/modules/post/domain/enums/post_type.dart' as domain;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:find_it/gen/strings.g.dart' as strings;

@RoutePage()
class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  CreatePostPageState createState() => CreatePostPageState();
}

class CreatePostPageState extends State<CreatePostPage> {
  domain.PostType? selectedType;
  ItemCategory? selectedCategory;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  List<XFile> uploadedImages = [];

  final List<ItemCategory> categories = ItemCategory.values;
  final List<domain.PostType> postTypes = domain.PostType.values;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        uploadedImages.add(image);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.create.page_title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: context.t.create.title,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<domain.PostType>(
                value: selectedType,
                items: domain.PostType.values
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(context.t.post_type(
                              context: strings.PostType.values[type.index])),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: context.t.create.post_type,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              selectedType == null
                  ? const SizedBox()
                  : Column(
                      children: [
                        TextField(
                          controller: locationController,
                          decoration: InputDecoration(
                            labelText: selectedType == domain.PostType.lost
                                ? context.t.create.location_found
                                : context.t.create.location_lost,
                            border: const OutlineInputBorder(),
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
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: context.t.create.description,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  final postData = {
                    "type": selectedType,
                    "title": titleController.text,
                    "description": descriptionController.text,
                    "images": uploadedImages.map((img) => img.path).toList(),
                    "location": locationController.text,
                    "category": selectedCategory?.name,
                  };
                  if (postData["type"] == null ||
                      postData["title"] == null ||
                      postData["location"] == null ||
                      postData["category"] == null) {
                    print("Please fill all required fields");
                  } else {
                    print(postData);
                  }
                },
                child: Text(context.t.create.submit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
