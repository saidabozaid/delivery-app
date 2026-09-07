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
  final pages = [PremiumCustomerPage(), DelegatePage()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: pages[currentIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (i) => setState(() => currentIndex = i),
              selectedItemColor: const Color(0xFFFF5A00),
              unselectedItemColor: Colors.grey,
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'عميل'),
                BottomNavigationBarItem(icon: Icon(Icons.delivery_dining), label: 'مندوب'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================= صفحة العميل البرتقالي الفخمة + زر شحنة جديدة =================
class PremiumCustomerPage extends StatefulWidget {
  @override
  State<PremiumCustomerPage> createState() => _PremiumCustomerPageState();
}

class _PremiumCustomerPageState extends State<PremiumCustomerPage> {
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Color(0xFF2ECC71), content: Text('تم حفظ الشحنة ✅ - تقدر تضيف شحنة جديدة')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text('خطأ: $e')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void addNew() {
    setState(() {
      toCtrl.clear();
      nameCtrl.clear();
      showNewButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFFF8A00), Color(0xFFFF5A00)]),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
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
                      child: const Row(children: [Text('🛵'), SizedBox(width: 6), Text('المندوب على بعد 2.3 كم', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFFF5A00)))]),
                    ),
                    if (showNewButton)
                      GestureDetector(
                        onTap: addNew,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
                          child: const Text('شحنة جديدة +', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text('اكتوبر - الشيخ زايد', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
                const Text('توصيل سريع خلال 45 دقيقة', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 15)]),
                    child: Column(
                      children: [
                        _field(icon: Icons.location_on, label: 'من فين', ctrl: fromCtrl),
                        const SizedBox(height: 12),
                        _field(icon: Icons.flag, label: 'إلى فين', ctrl: toCtrl),
                        const SizedBox(height: 12),
                        _field(icon: Icons.person, label: 'اسم العميل', ctrl: nameCtrl),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: const Column(children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('سعر التوصيل', style: TextStyle(fontSize: 13)), Text('60 جنيه', style: TextStyle(fontSize: 13))]),
                      SizedBox(height: 6),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('خدمة التطبيق', style: TextStyle(fontSize: 13)), Text('15 جنيه', style: TextStyle(fontSize: 13))]),
                      Divider(height: 16),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('الإجمالي', style: TextStyle(fontWeight: FontWeight.bold)), Text('75 جنيه', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF5A00)))]),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: loading ? null : save,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5A00), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      child: loading ? const CircularProgressIndicator(color: Colors.white) : const Text('تأكيد الشحنة - 75 جنيه', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (showNewButton)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: addNew,
                        icon: const Icon(Icons.add, color: Color(0xFFFF5A00)),
                        label: const Text('إضافة شحنة جديدة +', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF5A00))),
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFFF5A00), width: 2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field({required IconData icon, required String label, required TextEditingController ctrl}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Color(0xFFFF5A00), shape: BoxShape.circle), child: Icon(icon, color: Colors.white, size: 16)),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)), TextField(controller: ctrl, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600), decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero))])),
      ]),
    );
  }
}

// ================= صفحة المندوب =================
class DelegatePage extends StatefulWidget {
  @override
  State<DelegatePage> createState() => _DelegatePageState();
}

class _DelegatePageState extends State<DelegatePage> {
  List<dynamic> shipments = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() => loading = true);
    try {
      final data = await Supabase.instance.client.from('shipments').select().order('created_at', ascending: false);
      setState(() => shipments = data);
    } catch (e) {
      debugPrint('$e');
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> updateStatus(String id, String status) async {
    await Supabase.instance.client.from('shipments').update({'status': status}).eq('id', id);
    load();
  }

  @override
  Widget build(BuildContext context) {
    final total = shipments.fold<int>(0, (s, e) => s + (e['price'] as int? ?? 0));
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(title: const Text('لوحة المندوب 🛵'), backgroundColor: Colors.white, elevation: 0, actions: [IconButton(onPressed: load, icon: const Icon(Icons.refresh))]),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF5A00)))
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('الشحنات', style: TextStyle(color: Colors.grey, fontSize: 12)), Text('${shipments.length} شحنة', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))]),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [const Text('الأرباح', style: TextStyle(color: Colors.grey, fontSize: 12)), Text('$total جنيه', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFF5A00)))]),
                    ],
                  ),
                ),
                Expanded(
                  child: shipments.isEmpty
                      ? const Center(child: Text('لا يوجد شحنات حاليا'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: shipments.length,
                          itemBuilder: (c, i) {
                            final s = shipments[i];
                            final isPending = s['status'] == 'pending';
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                              child: Row(
                                children: [
                                  Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: isPending ? Colors.orange.shade100 : Colors.green.shade100, shape: BoxShape.circle), child: Icon(isPending ? Icons.pending : Icons.check, color: isPending ? Colors.orange : Colors.green)),
                                  const SizedBox(width: 12),
                                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(s['customer_name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)), Text('${s['pickup_address']} → ${s['delivery_address']}', style: const TextStyle(fontSize: 12, color: Colors.grey)), Text('${s['price']} جنيه • ${s['status']}', style: const TextStyle(fontSize: 12))])),
                                  if (isPending)
                                    ElevatedButton(onPressed: () => updateStatus(s['id'], 'delivered'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2ECC71)), child: const Text('وصل', style: TextStyle(color: Colors.white, fontSize: 12)))
                                  else
                                    const Icon(Icons.check_circle, color: Colors.green),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
