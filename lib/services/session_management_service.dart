import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Session Management Service for client authentication and session handling
class SessionManagementService {
  static final SessionManagementService _instance =
      SessionManagementService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory SessionManagementService() {
    return _instance;
  }

  SessionManagementService._internal();

  // ✅ Get current authenticated user
  User? get currentUser => _auth.currentUser;

  // ✅ Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  // ✅ Get current user's UID
  String? get currentUserUID => _auth.currentUser?.uid;

  // ✅ Initialize session on app start
  /// This checks if user is logged in and caches their role locally for faster access
  Future<bool> initializeSession() async {
    try {
      if (_auth.currentUser != null) {
        // User is logged in, cache the role locally
        await _cacheUserRole(_auth.currentUser!.uid);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Session initialization error: $e');
      return false;
    }
  }

  // ✅ Cache user role locally for quick access
  Future<void> _cacheUserRole(String uid) async {
    try {
      // Check if user is a client
      final clientDoc = await _firestore.collection('clients').doc(uid).get();
      if (clientDoc.exists) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userRole', 'client');
        await prefs.setString('userUID', uid);
        return;
      }

      // Check if user is a lawyer
      final lawyerDoc = await _firestore.collection('lawyers').doc(uid).get();
      if (lawyerDoc.exists) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userRole', 'lawyer');
        await prefs.setString('userUID', uid);
        return;
      }

      // Role not found, clear local cache
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userRole');
      await prefs.remove('userUID');
    } catch (e) {
      debugPrint('Error caching user role: $e');
    }
  }

  // ✅ Get cached user role (fast access without Firebase call)
  Future<String?> getCachedUserRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('userRole');
    } catch (e) {
      debugPrint('Error getting cached role: $e');
      return null;
    }
  }

  // ✅ Get user role from Firebase (slower, but always up-to-date)
  Future<String?> getUserRole(String uid) async {
    try {
      final clientDoc = await _firestore.collection('clients').doc(uid).get();
      if (clientDoc.exists) {
        return 'client';
      }

      final lawyerDoc = await _firestore.collection('lawyers').doc(uid).get();
      if (lawyerDoc.exists) {
        return 'lawyer';
      }

      return null;
    } catch (e) {
      debugPrint('Error getting user role: $e');
      return null;
    }
  }

  // ✅ Get client profile data
  Future<Map<String, dynamic>?> getClientProfile(String uid) async {
    try {
      final doc = await _firestore.collection('clients').doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting client profile: $e');
      return null;
    }
  }

  // ✅ Update client profile data
  Future<bool> updateClientProfile(
      String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('clients').doc(uid).update(data);
      return true;
    } catch (e) {
      debugPrint('Error updating client profile: $e');
      return false;
    }
  }

  // ✅ Logout user and clear session
  Future<bool> logout() async {
    try {
      // Sign out from Firebase
      await _auth.signOut();

      // Clear local cached data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userRole');
      await prefs.remove('userUID');
      await prefs.remove('hasSeenIntro');

      return true;
    } catch (e) {
      debugPrint('Error during logout: $e');
      return false;
    }
  }

  // ✅ Verify session is still valid
  /// Useful to verify that the user's session hasn't been invalidated
  Future<bool> verifySession() async {
    try {
      if (_auth.currentUser == null) {
        return false;
      }

      // Verify user still exists in Firestore
      final uid = _auth.currentUser!.uid;
      final role = await getUserRole(uid);
      return role != null;
    } catch (e) {
      debugPrint('Error verifying session: $e');
      return false;
    }
  }

  // ✅ Refresh user token (for security)
  Future<void> refreshUserToken() async {
    try {
      await _auth.currentUser?.reload();
    } catch (e) {
      debugPrint('Error refreshing token: $e');
    }
  }

  // ✅ Stream to listen for authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
