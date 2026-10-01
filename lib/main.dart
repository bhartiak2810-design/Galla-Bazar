import 'package:flutter/material.dart';

void main() => runApp(const GallaBazarApp());

class GallaBazarApp extends StatelessWidget {
  const GallaBazarApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Galla Bazar',
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)), useMaterial3: true),
    home: const HomePage(),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int cart = 0;
  void open(Widget p) => Navigator.push(context, MaterialPageRoute(builder: (_) => p));
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white,
      title: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Galla Bazar', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Nutrigrain.in • Satna 485001 / 485005', style: TextStyle(fontSize: 11)),
      ]),
      actions: [IconButton(onPressed: () => open(CartPage(cart)), icon: Badge(label: Text('$cart'), child: const Icon(Icons.shopping_cart)))],
    ),
    body: ListView(padding: const EdgeInsets.all(12), children: [
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.orange.shade100, Colors.green.shade50]), borderRadius: BorderRadius.circular(16)),
        child: const Column(children: [
          Icon(Icons.local_offer, color: Colors.deepOrange, size: 34),
          Text('10 Kg आटे पर कंटेनर फ्री!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('स्क्रैप दें • अनाज, आटा और तेल लें'),
          Text('485001 / 485005 में 1 दिन में डिलीवरी', style: TextStyle(fontSize: 12)),
        ]),
      ),
      const SizedBox(height: 16),
      const Text('क्या खरीदना है?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, children: [
        tile(Icons.grass, 'अनाज\nGrains', Colors.green, () => open(GrainsPage(() => setState(() => cart++)))),
        tile(Icons.water_drop, 'आटा और तेल\nFlour & Oil', Colors.amber.shade800, () => open(FlourOilPage(() => setState(() => cart++)))),
        tile(Icons.recycling, 'Scrap Exchange\nReward Wallet', Colors.teal, () => open(const ScrapPage())),
        tile(Icons.card_giftcard, 'डेली ऑफर\nDaily Offers', Colors.deepOrange, () => open(const OffersPage())),
      ]),
      const SizedBox(height: 18),
      const Text('जुड़ें और कमाएं', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      action('किसान रजिस्ट्रेशन • 0% कमीशन सीधे Nutrigrain को बेचें', Colors.green, () => open(const FormPage('Farmer Registration', ['नाम','मोबाइल','गांव / Satna District','अनाज','मात्रा kg','अपेक्षित रेट ₹/kg']))),
      const SizedBox(height: 10),
      action('Seller Registration • Marketplace पर बेचें', Colors.blue, () => open(const FormPage('Seller Registration', ['नाम / Business','मोबाइल','पता','Seller Type','Product','Quantity','Rate']))),
    ]),
  );

  Widget tile(IconData i, String t, Color c, VoidCallback f) => Card(child: InkWell(onTap: f, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(i, color: c, size: 38), const SizedBox(height: 10), Text(t, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))])));
  Widget action(String t, Color c, VoidCallback f) => SizedBox(width: double.infinity, child: ElevatedButton(onPressed: f, style: ElevatedButton.styleFrom(backgroundColor: c, foregroundColor: Colors.white, padding: const EdgeInsets.all(15)), child: Text(t, textAlign: TextAlign.center)));
}

class GrainsPage extends StatelessWidget {
  final VoidCallback add; const GrainsPage(this.add,{super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('अनाज / Grains')), body: ListView(padding: const EdgeInsets.all(12), children: [
    const Info('Addon: सफाई +₹5/kg • सफाई + धुलाई +₹10/kg'),
    product(context,'🌾','गेहूं / Wheat','₹32/kg'), product(context,'🫘','चना / Gram','₹72/kg'), product(context,'🌿','जौ / Barley','Rate update'), product(context,'🌽','मक्का / Maize','Rate update'), product(context,'🥣','दालें / Pulses','Rate update'),
  ]));
  Widget product(BuildContext c,String e,String n,String p)=>Card(child:ListTile(leading:Text(e,style:const TextStyle(fontSize:28)),title:Text(n),subtitle:Text(p),trailing:FilledButton(onPressed:(){add();ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content:Text('Cart में जोड़ा गया')));},child:const Text('Add'))));
}

class FlourOilPage extends StatelessWidget {
  final VoidCallback add; const FlourOilPage(this.add,{super.key});
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('आटा और तेल')),body:ListView(padding:const EdgeInsets.all(12),children:[
    item(context,'🫓','घर जैसा आटा','चोकर युक्त, फाइबर और प्रोटीन'), item(context,'🥣','बाजार जैसा आटा','Regular fine flour'),
    Card(child:ListTile(title:const Text('Custom Flour Mix'),subtitle:const Text('गेहूं + चना + जौ + ज्वार • अनाज रेट + ₹15/kg service'),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const CustomPage())))),
    item(context,'🫙','शुद्ध सरसों तेल','₹225/L'),
  ]));
  Widget item(BuildContext c,String e,String n,String p)=>Card(child:ListTile(leading:Text(e,style:const TextStyle(fontSize:28)),title:Text(n),subtitle:Text(p),trailing:FilledButton(onPressed:add,child:const Text('Add'))));
}

class CustomPage extends StatefulWidget { const CustomPage({super.key}); @override State<CustomPage> createState()=>_CustomPageState(); }
class _CustomPageState extends State<CustomPage>{
  final ctrls=[for(final v in ['50','20','20','10']) TextEditingController(text:v)];
  @override Widget build(BuildContext context){final total=ctrls.fold<double>(0,(s,c)=>s+(double.tryParse(c.text)??0));return Scaffold(appBar:AppBar(title:const Text('Custom Flour')),body:ListView(padding:const EdgeInsets.all(16),children:[const Info('डॉक्टर/डाइटिशियन/अपनी जरूरत के अनुसार मिश्रण चुनें।'),for(int i=0;i<4;i++)Padding(padding:const EdgeInsets.only(top:10),child:TextField(controller:ctrls[i],keyboardType:TextInputType.number,decoration:InputDecoration(labelText:['गेहूं kg','चना kg','जौ kg','ज्वार kg'][i],border:const OutlineInputBorder()))),const SizedBox(height:10),FilledButton(onPressed:()=>setState((){}),child:const Text('Calculate')),Card(child:Padding(padding:const EdgeInsets.all(16),child:Text('कुल: ${total.toStringAsFixed(1)} kg\nService charge: ₹${(total*15).toStringAsFixed(0)} + अनाज लागत')))]));}
}

class ScrapPage extends StatefulWidget{const ScrapPage({super.key});@override State<ScrapPage> createState()=>_ScrapPageState();}
class _ScrapPageState extends State<ScrapPage>{double balance=0;final v=TextEditingController();@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Scrap Reward Wallet')),body:ListView(padding:const EdgeInsets.all(16),children:[Card(color:Colors.green.shade800,child:Padding(padding:const EdgeInsets.all(20),child:Text('Reward Balance ₹${balance.toStringAsFixed(0)}',style:const TextStyle(color:Colors.white,fontSize:24,fontWeight:FontWeight.bold)))),const Info('Plastic, Metal या Paper scrap थोड़ा-थोड़ा जमा करें और reward से खरीदारी करें।'),const SizedBox(height:10),TextField(controller:v,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'Estimated scrap value ₹',border:OutlineInputBorder())),const SizedBox(height:10),const TextField(decoration:InputDecoration(labelText:'Pickup Address / Location',border:OutlineInputBorder())),const SizedBox(height:10),FilledButton(onPressed:()=>setState(()=>balance+=double.tryParse(v.text)??0),child:const Text('Reward जमा करें (Demo)'))]));}

class OffersPage extends StatelessWidget{const OffersPage({super.key});@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Offers')),body:ListView(padding:EdgeInsets.all(12),children:[Info('🎁 पहली बार 10 kg आटा ऑर्डर पर कंटेनर फ्री।'),SizedBox(height:10),Info('♻️ स्क्रैप दें और reward value पाएं।'),SizedBox(height:10),Info('🔁 3 महीने लगातार खरीदारी पर पात्र ग्राहकों के लिए कंटेनर change सुविधा।')]));}

class FormPage extends StatelessWidget{final String title;final List<String> fields;const FormPage(this.title,this.fields,{super.key});@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:Text(title)),body:ListView(padding:const EdgeInsets.all(16),children:[for(final f in fields)Padding(padding:const EdgeInsets.only(bottom:10),child:TextField(decoration:InputDecoration(labelText:f,border:const OutlineInputBorder()))),FilledButton(onPressed:()=>ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Submitted (Demo)'))),child:const Text('Submit'))]));}
class CartPage extends StatelessWidget{final int count;const CartPage(this.count,{super.key});@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Cart / Checkout')),body:Padding(padding:const EdgeInsets.all(16),child:Column(children:[ListTile(title:Text('Cart items: $count'),subtitle:const Text('COD + Online Payment')),const Info('Delivery: 485001 और 485005 में 1 दिन; अन्य enabled areas में लगभग 3 दिन।')])));}
class Info extends StatelessWidget{final String text;const Info(this.text,{super.key});@override Widget build(BuildContext context)=>Container(margin:const EdgeInsets.only(bottom:8),padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:Colors.green.shade50,borderRadius:BorderRadius.circular(12),border:Border.all(color:Colors.green.shade200)),child:Text(text));}
