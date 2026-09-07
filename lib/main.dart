import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    // الرابط بتاعك شغال تمام - متغيروش
    url: 'https://flszwmgtkiysvxpvzgtb.supabase.co',
    // انسخ الـ anon key من Supabase > Settings > API Keys > anon key
    // دوس Copy والصقه هنا مكان كلمة PASTE_YOUR_ANON_KEY_HERE
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZsc3p3bWd0a2l5c3Z4cHZ6Z3RiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODg3MjMyNzAsImV4cCI6MjEwNDI5OTI3MH0.DeaueODyJZI75uO0pUpRk23UGY3c8IRFaSAcWJrxCTg',
  );
  runApp(DeliveryApp());
}

class DeliveryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomerPage(),
    );
  }
}

class CustomerPage extends StatefulWidget {
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final _fromController = TextEditingController(text: '6 اكتوبر');
  final _toController = TextEditingController(text: 'الشيخ زايد');
  final _nameController = TextEditingController(text: 'سعيد - اكتوبر');
  bool _loading = false;
  String _message = '';

  Future<void> _addShipment() async {
    setState(() {
      _loading = true;
      _message = '';
    });
    try {
      await Supabase.instance.client.from('shipments').insert({
        'customer_name': _nameController.text,
        'pickup_address': _fromController.text,
        'delivery_address': _toController.text,
        'price': 75,
        'status': 'pending',
      });
      setState(() {
        _message = 'تم حفظ ${_nameController.text} بنجاح ✅';
      });
      // امسح الحقول بعد الحفظ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_message), backgroundColor: Colors.green),
      );
    } catch (e) {
      setState(() {
        _message = 'خطأ: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_message), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('اكتوبر - الشيخ زايد', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // كارت المندوب
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.delivery_dining, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('المندوب على بعد 2.3 كم'),
                ],
              ),
            ),
            SizedBox(height: 20),
            // حقول الإدخال بنفس تصميم الصورة
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _fromController,
                    decoration: InputDecoration(
                      labelText: 'من فين',
                      prefixIcon: Icon(Icons.location_on_outlined),
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _toController,
                    decoration: InputDecoration(
                      labelText: 'إلى فين',
                      prefixIcon: Icon(Icons.flag_outlined),
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'اسم العميل',
                      prefixIcon: Icon(Icons.person_outline),
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF5A00),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _loading ? null : _addShipment,
                      child: _loading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'تأكيد الشحنة - 75 جنيه',
                              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (_message.isNotEmpty)
              Container(
                padding: EdgeInsets.all(12),
                color: _message.contains('خطأ') ? Colors.red : Colors.green,
                child: Text(_message, style: TextStyle(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }
}
