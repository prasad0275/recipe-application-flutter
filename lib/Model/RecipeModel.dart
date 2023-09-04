class RecipeModel {
  final int? id;
  final String? name;
  final String? instructions;
  final String? cookingTime;
  final String? description;
  final List<Category>? category;
  final List<Ingredient>? ingredient;
  final PostedBy? postedBy;
  final String? imageUrl;

  RecipeModel({
    this.id,
    this.name,
    this.instructions,
    this.cookingTime,
    this.description,
    this.category,
    this.ingredient,
    this.postedBy,
    this.imageUrl,
  });

  RecipeModel.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int?,
      name = json['name'] as String?,
      instructions = json['instructions'] as String?,
      cookingTime = json['cooking_time'] as String?,
      description = json['description'] as String?,
      category = (json['category'] as List?)?.map((dynamic e) => Category.fromJson(e as Map<String,dynamic>)).toList(),
      ingredient = (json['ingredient'] as List?)?.map((dynamic e) => Ingredient.fromJson(e as Map<String,dynamic>)).toList(),
      postedBy = (json['posted_by'] as Map<String,dynamic>?) != null ? PostedBy.fromJson(json['posted_by'] as Map<String,dynamic>) : null,
      imageUrl = json['image_url'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'instructions' : instructions,
    'cooking_time' : cookingTime,
    'description' : description,
    'category' : category?.map((e) => e.toJson()).toList(),
    'ingredient' : ingredient?.map((e) => e.toJson()).toList(),
    'posted_by' : postedBy?.toJson(),
    'image_url' : imageUrl
  };
}

class Category {
  final int? id;
  final String? name;

  Category({
    this.id,
    this.name,
  });

  Category.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int?,
      name = json['name'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name
  };
}

class Ingredient {
  final int? id;
  final String? name;

  Ingredient({
    this.id,
    this.name,
  });

  Ingredient.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int?,
      name = json['name'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name
  };
}

class PostedBy {
  final int? id;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? email;

  PostedBy({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
  });

  PostedBy.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int?,
      username = json['username'] as String?,
      firstName = json['first_name'] as String?,
      lastName = json['last_name'] as String?,
      email = json['email'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'username' : username,
    'first_name' : firstName,
    'last_name' : lastName,
    'email' : email
  };
}