import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Đăng ký nhận thông tin thời tiết
  Future<String?> subscribeToWeatherUpdates(String email) async {
    try {
      // Tạo user với email
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: generateRandomPassword(), // Tạo mật khẩu ngẫu nhiên
      );

      // Gửi email xác nhận
      await userCredential.user?.sendEmailVerification();

      // Lưu thông tin đăng ký vào Firestore
      await _firestore
          .collection('weather_subscribers')
          .doc(userCredential.user?.uid)
          .set({
        'email': email,
        'subscribed_at': DateTime.now(),
        'is_verified': false,
      });

      return null; // Thành công
    } on FirebaseAuthException catch (e) {
      return e.message; // Trả về thông báo lỗi
    }
  }

  // Hủy đăng ký nhận thông tin thời tiết
  Future<String?> unsubscribeFromWeatherUpdates(String email) async {
    try {
      // Tìm user trong Firestore
      QuerySnapshot querySnapshot = await _firestore
          .collection('weather_subscribers')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return 'Email không tồn tại trong danh sách đăng ký';
      }

      // Xóa thông tin đăng ký khỏi Firestore
      await _firestore
          .collection('weather_subscribers')
          .doc(querySnapshot.docs.first.id)
          .delete();

      return null; // Thành công
    } catch (e) {
      return e.toString(); // Trả về thông báo lỗi
    }
  }

  // Hàm phụ trợ để tạo mật khẩu ngẫu nhiên
  String generateRandomPassword() {
    const length = 12;
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()';
    final random = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(
          length, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }
}
