import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://flszwmgtkiysvxpvzgtb.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZsc3p3bWd0a2l5c3Z4cHZ6Z3RiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODg3MjMyNzAsImV4cCI6MjEwNDI5OTI3MH0.DeaueODyJZI75uO0pUpRk23UGY3c8IRFaSAcWJrxCTg',
  );
  runApp(DeliveryShopApp());
}

class DeliveryShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF7F7F8),
        textTheme: GoogleFonts.cairoTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFF6B00)),
      ),
      home: MainShell(),
    );
  }
}

class MainShell extends StatefulWidget { @override _MainShellState createState() => _MainShellState(); }
class _MainShellState extends State<MainShell> {
  bool isDriver = false;
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)]),
                child: Row(children: [
                  Expanded(child: _toggleBtn("عميل", !isDriver, () => setState(()=>isDriver=false))),
                  Expanded(child: _toggleBtn("مندوب", isDriver, () => setState(()=>isDriver=true))),
                ]),
              ),
            ),
            Expanded(child: isDriver ? _buildDriver() : _buildCustomer())
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(0, "الرئيسية", Icons.home_rounded),
            _navItem(1, "التتبع", Icons.local_shipping_rounded),
            _navItem(2, "المحفظة", Icons.wallet_rounded),
            _navItem(3, "حسابي", Icons.person_rounded),
          ],
        ),
      ),
    );
  }
  Widget _toggleBtn(String t, bool active, VoidCallback onTap){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: active?Color(0xFFFF6B00):Colors.transparent, borderRadius: BorderRadius.circular(30)),
        child: Center(child: Text(t, style: TextStyle(color: active?Colors.white:Colors.black54, fontWeight: FontWeight.bold))),
      ),
    );
  }
  Widget _navItem(int i, String label, IconData icon){
    bool active = tab==i;
    return IconButton(onPressed: ()=>setState(()=>tab=i), icon: Icon(icon, color: active?Color(0xFFFF6B00):Colors.white54));
  }
  Widget _buildCustomer(){
    if(tab==0) return HomeCustomer(onNewShipment: ()=>setState(()=>tab=1));
    if(tab==1) return TrackingScreen();
    if(tab==2) return WalletScreen();
    return Center(child: Text("حسابي - سعيد - 6 اكتوبر", style: TextStyle(fontSize:18, fontWeight: FontWeight.bold)));
  }
  Widget _buildDriver(){
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Container(padding: EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("8 شحنات اليوم", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), Icon(Icons.route, color: Color(0xFFFF6B00)) ])),
        SizedBox(height: 12),
        for(int i=0;i<3;i++) _shipmentCardDriver(),
        SizedBox(height: 12),
        Container(padding: EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(24)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("تسوية اليوم", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), SizedBox(height:8), Text("كاش محصل: 850 جنيه - عمولة: 120 جنيه", style: TextStyle(color: Colors.white70))])),
      ],
    );
  }
  Widget _shipmentCardDriver(){
    return Container(margin: EdgeInsets.only(bottom:12), padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("سعيد - اكتوبر", style: TextStyle(fontWeight: FontWeight.bold)), Container(padding: EdgeInsets.symmetric(horizontal:10, vertical:4), decoration: BoxDecoration(color: Color(0xFFFF6B00).withOpacity(0.15), borderRadius: BorderRadius.circular(12)), child: Text("جديدة", style: TextStyle(color: Color(0xFFFF6B00), fontSize:12)))]),
      SizedBox(height:12),
      Row(children: [
        Expanded(child: ElevatedButton(onPressed: (){}, child: Text("استلمت"), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFF6B00), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
        SizedBox(width:8),
        Expanded(child: OutlinedButton(onPressed: (){}, child: Text("مردش"))),
        SizedBox(width:8),
        Expanded(child: OutlinedButton(onPressed: (){}, child: Text("سلمت"))),
      ])
    ]));
  }
}

class HomeCustomer extends StatelessWidget {
  final VoidCallback onNewShipment;
  HomeCustomer({required this.onNewShipment});
  @override
  Widget build(BuildContext context){
    return ListView(padding: EdgeInsets.all(16), children: [
      Text("أهلا سعيد 👋", style: TextStyle(fontSize:24, fontWeight: FontWeight.bold)),
      Text("6 أكتوبر - شحنتك في أمان", style: TextStyle(color: Colors.black54)),
      SizedBox(height:16),
      Row(children: [
        Expanded(child: _statCard("شحناتي", "12", Colors.black)),
        SizedBox(width:12),
        Expanded(child: _statCard("في الطريق", "2", Color(0xFFFF6B00))),
      ]),
      SizedBox(height:16),
      GestureDetector(onTap: onNewShipment, child: Container(height:60, decoration: BoxDecoration(color: Color(0xFFFF6B00), borderRadius: BorderRadius.circular(18)), child: Center(child: Text("شحنة جديدة +", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize:18))))),
      SizedBox(height:16),
      Text("آخر الشحنات", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height:8),
      _shipmentCardCust("أحمد - زايد", "في الطريق", Colors.blue),
      _shipmentCardCust("سعيد - اكتوبر", "تم التسليم", Colors.green),
      _shipmentCardCust("محمد - الحصري", "قيد الانتظار", Color(0xFFFF6B00)),
    ]);
  }
  Widget _statCard(String l, String v, Color c){ return Container(padding: EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(v, style: TextStyle(fontSize:28, fontWeight: FontWeight.bold, color: c)), Text(l)])); }
  Widget _shipmentCardCust(String name, String status, Color col){ return Container(margin: EdgeInsets.only(bottom:10), padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(name, style: TextStyle(fontWeight: FontWeight.bold)), Container(padding: EdgeInsets.symmetric(horizontal:10, vertical:4), decoration: BoxDecoration(color: col.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: Text(status, style: TextStyle(color: col, fontSize:12)))])); }
}

class TrackingScreen extends StatefulWidget { @override _TrackingScreenState createState()=>_TrackingScreenState(); }
class _TrackingScreenState extends State<TrackingScreen>{
  final _pickup = TextEditingController(text: "6 اكتوبر");
  final _delivery = TextEditingController(text: "الشيخ زايد");
  bool loading=false;
  Future<void> saveShipment() async {
    setState(()=>loading=true);
    try{
      await Supabase.instance.client.from('shipments').insert({
        'customer_name': 'سعيد - اكتوبر',
        'pickup_address': _pickup.text,
        'delivery_address': _delivery.text,
        'price': 75,
        'status': 'pending',
      });
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم حفظ سعيد - اكتوبر بنجاح ✅"), backgroundColor: Colors.green));
    } catch(e){
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("خطأ: $e"), backgroundColor: Colors.red));
    }
    setState(()=>loading=false);
  }
  @override
  Widget build(BuildContext context){
    return ListView(padding: EdgeInsets.all(16), children: [
      Container(height:160, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black12)), child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.map_rounded, size:40, color: Color(0xFFFF6B00)), SizedBox(height:8), Text("6 أكتوبر → الشيخ زايد", style: TextStyle(fontWeight: FontWeight.bold)), Text("المندوب على بعد 2.3 كم", style: TextStyle(color: Colors.black54, fontSize:12))]))),
      SizedBox(height:16),
      Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Column(children: [
        TextField(controller: _pickup, decoration: InputDecoration(labelText: "من فين", prefixIcon: Icon(Icons.location_on_outlined))),
        SizedBox(height:12),
        TextField(controller: _delivery, decoration: InputDecoration(labelText: "إلى فين", prefixIcon: Icon(Icons.flag_outlined))),
        SizedBox(height:16),
        SizedBox(width: double.infinity, height:54, child: ElevatedButton(onPressed: loading?null:saveShipment, style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFF6B00), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: loading?CircularProgressIndicator(color: Colors.white):Text("تأكيد الشحنة - 75 جنيه", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize:16)))),
      ])),
    ]);
  }
}

class WalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return ListView(padding: EdgeInsets.all(16), children: [
      Container(padding: EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(24)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("رصيدك", style: TextStyle(color: Colors.white54)), SizedBox(height:4), Text("340 جنيه", style: TextStyle(color: Colors.white, fontSize:32, fontWeight: FontWeight.bold)), SizedBox(height:12), Row(children: [Icon(Icons.trending_up, color: Color(0xFFFF6B00), size:16), SizedBox(width:4), Text("+ 85 جنيه اليوم", style: TextStyle(color: Color(0xFFFF6B00)))])])),
      SizedBox(height:16),
      Text("المعاملات", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height:8),
      _tx("تحصيل شحنة - أحمد", "+75", Colors.green),
      _tx("سحب", "-200", Colors.red),
      _tx("تحصيل شحنة - سعيد", "+75", Colors.green),
    ]);
  }
  Widget _tx(String t, String a, Color c){ return Container(margin: EdgeInsets.only(bottom:8), padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(t), Text(a, style: TextStyle(color: c, fontWeight: FontWeight.bold))])); }
}
