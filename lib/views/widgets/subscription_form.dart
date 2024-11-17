import 'package:flutter/material.dart';
import '../../../services/firebase_service.dart';
import '../../utils/validators/email_validator.dart';

class SubscriptionForm extends StatefulWidget {
  final String city;

  const SubscriptionForm({
    super.key,
    required this.city,
  });

  @override
  State<SubscriptionForm> createState() => _SubscriptionFormState();

  static Future<void> show(BuildContext context, String city) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: SubscriptionForm(city: city),
        ),
      ),
    );
  }
}

class _SubscriptionFormState extends State<SubscriptionForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firebaseService = FirebaseService();
  bool _isSubscribing = false;
  bool _isUnsubscribing = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _subscribe() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubscribing = true);

    try {
      final result = await _firebaseService.subscribeToWeatherUpdates(
        _emailController.text,
      );

      if (result != null) {
        throw Exception(result);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng kiểm tra email để xác nhận đăng ký'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSubscribing = false);
    }
  }

  Future<void> _unsubscribe() async {
    setState(() => _isUnsubscribing = true);

    try {
      final result = await _firebaseService.unsubscribeFromWeatherUpdates(
        _emailController.text,
      );

      if (result != null) {
        throw Exception(result);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã hủy đăng ký thành công'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isUnsubscribing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Đăng ký nhận thông báo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Thành phố: ${widget.city}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: EmailValidator.validate,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSubscribing
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  await _subscribe();
                                  if (!mounted) return;
                                  if (!_isSubscribing) {
                                    Navigator.of(context).pop();
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.blue[300],
                        ),
                        child: _isSubscribing
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Đăng ký',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isUnsubscribing
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  await _unsubscribe();
                                  if (!mounted) return;
                                  if (!_isUnsubscribing) {
                                    Navigator.of(context).pop();
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.red[300],
                        ),
                        child: _isUnsubscribing
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Hủy đăng ký',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
