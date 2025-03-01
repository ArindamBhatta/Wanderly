class PublisherModel {
  String? id;
  int? viewCount;
  int? wishCount;
  String? continent;
  String? country;
  String? imageUrl;
  String? knownFor;
  String? name;
  String? ref;
  List<String>? tags;

  PublisherModel({
    this.id,
    this.viewCount,
    this.wishCount,
    this.continent,
    this.country,
    this.imageUrl,
    this.knownFor,
    this.name,
    this.ref,
    this.tags,
  });

  factory PublisherModel.fromJson(Map<String, dynamic> json) {
    return PublisherModel(
      id: json['id'],
      viewCount: json['viewCount'],
      wishCount: json['wishCount'],
      continent: json['continent'],
      country: json['country'],
      knownFor: json['knownFor'],
      imageUrl: json['imageUrl'],
      name: json['name'],
      ref: json['ref'],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  @override
  String toString() {
    return 'PublisherModel(name: $name, country: $country)';
  }
}
