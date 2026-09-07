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

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;
  final pages = [const CustomerPage(), const DelegatePage()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: pages[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (i) => setState(() => currentIndex = i),
            selectedItemColor: const Color(0xFFFF3B30),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'عميل'),
              BottomNavigationBarItem(icon: Icon(Icons.delivery_dining), label: 'مندوب'),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= صفحة العميل - زي الصورة بالظبط =================
class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});
  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final fromCtrl = TextEditingController(text: '6 اكتوبر');
  final toCtrl = TextEditingController(text: 'الشيخ زايد');
  final nameCtrl = TextEditingController(text: 'سعيد - اكتوبر');
  bool loading = false;

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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF2ECC71),
          content: Text('تم حفظ ${nameCtrl.text} بنجاح ✅', style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text('اكتوبر - الشيخ زايد', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: const Row(children: [Text('🛵'), SizedBox(width: 8), Text('المندوب على بعد 2.3 كم')]),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    _field(icon: Icons.location_on_outlined, label: 'من فين', ctrl: fromCtrl),
                    const Divider(),
                    _field(icon: Icons.flag_outlined, label: 'إلى فين', ctrl: toCtrl),
                    const Divider(),
                    _field(icon: Icons.person_outline, label: 'اسم العميل', ctrl: nameCtrl),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: loading ? null : save,
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF3B30), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                        child: loading ? const CircularProgressIndicator(color: Colors.white) : const Text('تأكيد الشحنة - 75 جنيه', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({required IconData icon, required String label, required TextEditingController ctrl}) {
    return Row(children: [
      Icon(icon, size: 28),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        TextField(controller: ctrl, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500), decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero))
      ]))
    ]);
  }
}

// ================= صفحة المندوب =================
class DelegatePage extends StatefulWidget {
  const DelegatePage({super.key});
  @override
  State<DelegatePage> createState() => _DelegatePageState();
}

class _DelegatePageState extends State<DelegatePage> {
  List<dynamic> shipments = [];
  bool loading = true;
  int totalEarnings = 0;

  @override
  void initState() {
    super.initState();
    loadShipments();
  }

  Future<void> loadShipments() async {
    setState(() => loading = true);
    try {
      final data = await Supabase.instance.client.from('shipments').select().order('created_at', ascending: false);
      setState(() {
        shipments = data;
        totalEarnings = data.fold(0, (sum, item) => sum + (item['price'] as int? ?? 0));
      });
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> updateStatus(String id, String status) async {
    await Supabase.instance.client.from('shipments').update({'status': status}).eq('id', id);
    loadShipments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: const Text('لوحة المندوب'), backgroundColor: Colors.white, elevation: 0),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadShipments,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('إجمالي الشحنات', style: TextStyle(color: Colors.grey)),
                        Text('${shipments.length} شحنة', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ]),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        const Text('الأرباح', style: TextStyle(color: Colors.grey)),
                        Text('$totalEarnings جنيه', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFF3B30))),
                      ]),
                    ]),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: shipments.length,
                      itemBuilder: (context, i) {
                        final s = shipments[i];
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            title: Text(s['customer_name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${s['pickup_address']} → ${s['delivery_address']}\n${s['price']} جنيه - ${s['status']}'),
                            trailing: s['status'] == 'pending'
                                ? ElevatedButton(
                                    onPressed: () => updateStatus(s['id'], 'delivered'),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                    child: const Text('تم التوصيل', style: TextStyle(color: Colors.white)),
                                  )
                                : const Icon(Icons.check_circle, color: Colors.green),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
