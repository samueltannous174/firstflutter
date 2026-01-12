class ReelModel {
  final String id;
  final String trailerUrl;
  final String fullVideoUrl;
  final double targetAmount;
  double currentAmount;
  
  ReelModel({
    required this.id,
    required this.trailerUrl,
    required this.fullVideoUrl,
    required this.targetAmount, 
    this.currentAmount = 0.0,
  });

  bool get isLocked => currentAmount < targetAmount;
}
