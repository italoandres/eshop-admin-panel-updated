class ReviewModel {
  final String userName;
  final String date;
  final double rating;
  final String comment;
  final bool isPositive;

  ReviewModel({
    required this.userName,
    required this.date,
    required this.rating,
    required this.comment,
    required this.isPositive,
  });
}

class ReviewAttribute {
  final String name;
  final double value; // 1 a 5
  final List<String> labels; // Labels para cada nível

  ReviewAttribute({
    required this.name,
    required this.value,
    required this.labels,
  });
}

class ProductReviews {
  final double averageRating;
  final int totalReviews;
  final double recommendationPercent;
  final List<ReviewAttribute> attributes;
  final List<ReviewModel> reviews;

  ProductReviews({
    required this.averageRating,
    required this.totalReviews,
    required this.recommendationPercent,
    required this.attributes,
    required this.reviews,
  });
}
