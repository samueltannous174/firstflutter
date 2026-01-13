import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reel_model.dart';

class ReelService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'reels';
  static const String _initKey = 'reels_initialized';

  // Initialize sample reels only once
  Future<void> initializeSampleReels() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isInitialized = prefs.getBool(_initKey) ?? false;

      if (!isInitialized) {
        await addSampleReels();
        await prefs.setBool(_initKey, true);
      }
    } catch (e) {
      throw Exception('Failed to initialize sample reels: $e');
    }
  }

  // CREATE: Add a new reel
  Future<String> addReel(ReelModel reel) async {
    try {
      final docRef = await _db.collection(_collection).add(reel.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add reel: $e');
    }
  }

  // READ: Get all reels as a stream (without orderBy to avoid index requirement)
  Stream<List<ReelModel>> getAllReels() {
    return _db
        .collection(_collection)
        .snapshots()
        .map((snapshot) {
      List<ReelModel> reels = snapshot.docs
          .map((doc) => ReelModel.fromJson(doc.data(), doc.id))
          .toList();
      // Sort locally by creation date
      reels.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.now();
        final bDate = b.createdAt ?? DateTime.now();
        return bDate.compareTo(aDate);
      });
      return reels;
    }).handleError((e) {
      throw Exception('Failed to fetch reels: $e');
    });
  }

  // READ: Get a single reel by ID
  Future<ReelModel?> getReelById(String reelId) async {
    try {
      final doc = await _db.collection(_collection).doc(reelId).get();
      if (doc.exists) {
        return ReelModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch reel: $e');
    }
  }

  // READ: Get reels by creator ID
  Stream<List<ReelModel>> getReelsByCreator(String creatorId) {
    return _db
        .collection(_collection)
        .where('creatorId', isEqualTo: creatorId)
        .snapshots()
        .map((snapshot) {
      List<ReelModel> reels = snapshot.docs
          .map((doc) => ReelModel.fromJson(doc.data(), doc.id))
          .toList();
      // Sort locally by creation date
      reels.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.now();
        final bDate = b.createdAt ?? DateTime.now();
        return bDate.compareTo(aDate);
      });
      return reels;
    }).handleError((e) {
      throw Exception('Failed to fetch reels: $e');
    });
  }

  // UPDATE: Update a reel
  Future<void> updateReel(String reelId, Map<String, dynamic> updates) async {
    try {
      await _db.collection(_collection).doc(reelId).update(updates);
    } catch (e) {
      throw Exception('Failed to update reel: $e');
    }
  }

  // UPDATE: Update current amount (funding)
  Future<void> updateFunding(String reelId, double amount) async {
    try {
      await _db.collection(_collection).doc(reelId).update({
        'currentAmount': FieldValue.increment(amount),
      });
    } catch (e) {
      throw Exception('Failed to update funding: $e');
    }
  }

  // DELETE: Delete a reel
  Future<void> deleteReel(String reelId) async {
    try {
      await _db.collection(_collection).doc(reelId).delete();
    } catch (e) {
      throw Exception('Failed to delete reel: $e');
    }
  }

  // SEARCH: Search reels by title
  Stream<List<ReelModel>> searchReels(String query) {
    return _db
        .collection(_collection)
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThan: query + 'z')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ReelModel.fromJson(doc.data(), doc.id))
          .toList();
    }).handleError((e) {
      throw Exception('Failed to search reels: $e');
    });
  }

  // BULK: Add sample reels to database
  Future<void> addSampleReels() async {
    try {
      final sampleReels = [
        ReelModel(
          id: '',
          trailerUrl:
              'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
          fullVideoUrl:
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          targetAmount: 50.0,
          currentAmount: 10.0,
          title: 'Project Alpha',
          description: 'An exciting new project that needs funding',
          creatorId: 'creator1',
          createdAt: DateTime.now(),
        ),
        ReelModel(
          id: '',
          trailerUrl:
              'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
          fullVideoUrl:
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
          targetAmount: 100.0,
          currentAmount: 100.0,
          title: 'Project Beta',
          description: 'A fully funded amazing project',
          creatorId: 'creator2',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        ReelModel(
          id: '',
          trailerUrl:
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          fullVideoUrl:
              'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
          targetAmount: 200.0,
          currentAmount: 50.0,
          title: 'Project Gamma',
          description: 'An innovative project with great potential',
          creatorId: 'creator3',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];

      for (final reel in sampleReels) {
        await addReel(reel);
      }
    } catch (e) {
      throw Exception('Failed to add sample reels: $e');
    }
  }
}
