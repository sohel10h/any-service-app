class ProviderBidModel {
  final String name;
  final String title;
  final double price;
  final double rating;
  final int jobsCount;
  final String timeAgo;
  final String description;
  final String availability;
  final String duration;
  final bool isBest;
  final bool belowBudget;
  final bool shortlisted;
  final String imageUrl;

  ProviderBidModel({
    required this.name,
    required this.title,
    required this.price,
    required this.rating,
    required this.jobsCount,
    required this.timeAgo,
    required this.description,
    required this.availability,
    required this.duration,
    this.isBest = false,
    this.belowBudget = false,
    this.shortlisted = false,
    required this.imageUrl,
  });
}
