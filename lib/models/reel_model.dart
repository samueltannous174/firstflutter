class ReelModel {
  final String id;
  final String trailerUrl;
  final String fullVideoUrl;
  final double targetAmount;
  double currentAmount;
  final String? title;
  final String? description;
  final String? creatorId;
  final DateTime? createdAt;
  
  ReelModel({
    required this.id,
    required this.trailerUrl,
    required this.fullVideoUrl,
    required this.targetAmount, 
    this.currentAmount = 0.0,
    this.title,
    this.description,
    this.creatorId,
    this.createdAt,
  });

  bool get isLocked => currentAmount < targetAmount;

  // Convert ReelModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trailerUrl': trailerUrl,
      'fullVideoUrl': fullVideoUrl,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'title': title,
      'description': description,
      'creatorId': creatorId,
      'createdAt': createdAt,
    };
  }

  // Create ReelModel from Firestore document
  factory ReelModel.fromJson(Map<String, dynamic> json, String docId) {
    return ReelModel(
      id: docId,
      trailerUrl: json['trailerUrl'] ?? '',
      fullVideoUrl: json['fullVideoUrl'] ?? '',
      targetAmount: (json['targetAmount'] ?? 0.0).toDouble(),
      currentAmount: (json['currentAmount'] ?? 0.0).toDouble(),
      title: json['title'],
      description: json['description'],
      creatorId: json['creatorId'],
      createdAt: json['createdAt'] != null 
        ? (json['createdAt']).toDate() 
        : null,
    );
  }
}
