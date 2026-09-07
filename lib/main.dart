import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://flszwmgtkiysvxpvzgtb.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZsc3p3bWd0a2l5c3Z4cHZ6Z3RiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODg3MjMyNzAsImV4cCI6MjEwNDI5OTI3MH0.DeaueODyJZI75uO0pUpRk23UGY3c8IRFaSAcWJrxCTg',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: PremiumOrangePage());
  }
}

class PremiumOrangePage extends StatefulWidget {
  @override
  State<PremiumOrangePage> createState() => _PremiumOrangePageState();
}

class _PremiumOrangePageState extends State<PremiumOrangePage> {
  final fromCtrl = TextEditingController(text: '6 اكتوبر');
  final toCtrl = TextEditingController(text: 'الشيخ زايد');
  final nameCtrl = TextEditingController(text: 'سعيد - اكتوبر');
  bool loading = false;
  bool showNewButton = false;

  Future<void> save() async {
    setState(() => loading = true);
    try {
      await Supabase.instance.client.from('shipments').insert({
        'customer_name': nameCtrl.text,
        'pickup_address': fromCtrl.text,
        'delivery_address': toCtrl.text,
        'price': 75,
        'status': 'pending',
      });
      setState(() => showNewButton = true);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF2ECC71),
          content: Text('تم حفظ الشحنة بنجاح ✅ - تقدر تضيف شحنة جديدة دلوقتي'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text('خطأ: $e')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void addNewShipment() {
    setState(() {
      fromCtrl.text = '6 اكتوبر';
      toCtrl.text = '';
      nameCtrl.text = '';
      showNewButton = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(backgroundColor: Colors.orange, content: Text('جاهز لإضافة شحنة جديدة 📦')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        body: Column(
          children: [
            // هيدر برتقالي متدرج
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Color(0xFFFF8A00), Color(0xFFFF5A00)]),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: const Row(mainAxisSize: MainAxisSize.min, children: [
                          Text('🛵', style: TextStyle(fontSize: 14)),
                          SizedBox(width: 6),
                          Text('المندوب على بعد 2.3 كم', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFFF5A00))),
                        ]),
                      ),
                      // زر شحنة جديدة في الهيدر
                      if (showNewButton)
                        GestureDetector(
                          onTap: addNewShipment,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
                            child: const Row(children: [Icon(Icons.add, color: Colors.white, size: 16), SizedBox(width: 4), Text('شحنة جديدة', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))]),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('اكتوبر - الشيخ زايد', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                  const Text('توصيل سريع خلال 45 دقيقة', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8))]),
                      child: Column(
                        children: [
                          _orangeField(icon: Icons.location_on, label: 'من فين', ctrl: fromCtrl),
                          const SizedBox(height: 16),
                          _orangeField(icon: Icons.flag, label: 'إلى فين', ctrl: toCtrl),
                          const SizedBox(height: 16),
                          _orangeField(icon: Icons.person, label: 'اسم العميل', ctrl: nameCtrl),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // تفاصيل السعر
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: const Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('سعر التوصيل'), Text('60 جنيه')]),
                          SizedBox(height: 8),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('خدمة التطبيق'), Text('15 جنيه')]),
                          Divider(height: 20),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('الإجمالي', style: TextStyle(fontWeight: FontWeight.bold)), Text('75 جنيه', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFFFF5A00)))]),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // زرار التأكيد
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: loading ? null : save,
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5A00), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                        child: loading ? const CircularProgressIndicator(color: Colors.white) : const Text('تأكيد الشحنة - 75 جنيه', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // زرار اضافة شحنة جديدة - يظهر بعد اول حفظ
                    if (showNewButton)
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: OutlinedButton.icon(
                          onPressed: addNewShipment,
                          icon: const Icon(Icons.add_circle_outline, color: Color(0xFFFF5A00)),
                          label: const Text('إضافة شحنة جديدة +', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFF5A00))),
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFFF5A00), width: 2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                        ),
                      ),
                    if (!showNewButton)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text('بعد التأكيد، سيظهر زر إضافة شحنة جديدة هنا', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orangeField({required IconData icon, required String label, required TextEditingController ctrl}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(9), decoration: const BoxDecoration(color: Color(0xFFFF5A00), shape: BoxShape.circle), child: Icon(icon, color: Colors.white, size: 18)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)), TextField(controller: ctrl, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600), decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero))])),
        ],
      ),
    );
  }
}
