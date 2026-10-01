import 'package:flutter/material.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});
  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final email = TextEditingController(text: 'admin@nutrigrain.in');
  final pin = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nutrigrain Admin')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(Icons.admin_panel_settings, size: 72, color: Colors.green),
          const SizedBox(height: 12),
          const Text('Galla Bazar Admin Panel',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Demo login PIN: 2026', textAlign: TextAlign.center),
          const SizedBox(height: 22),
          TextField(
            controller: email,
            decoration: const InputDecoration(
              labelText: 'Admin Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: pin,
            obscureText: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Admin PIN',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () {
              if (pin.text.trim() != '2026') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('गलत PIN')),
                );
                return;
              }
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
              );
            },
            icon: const Icon(Icons.login),
            label: const Text('Login'),
          ),
        ],
      ),
    );
  }
}

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});
  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage>
    with SingleTickerProviderStateMixin {
  late final TabController tabs;

  final orders = <Map<String, String>>[
    {'id':'GB10001','customer':'Demo Customer','amount':'₹1,280','status':'Processing'},
    {'id':'GB10002','customer':'Satna Customer','amount':'₹2,250','status':'Packed'},
  ];

  final procurement = <Map<String, String>>[
    {'farmer':'रामलाल','grain':'गेहूं','qty':'500 kg','rate':'₹30/kg','mode':'Direct Purchase'},
    {'farmer':'मोहन','grain':'चना','qty':'250 kg','rate':'₹68/kg','mode':'Direct Purchase'},
  ];

  final stock = <Map<String, dynamic>>[
    {'item':'गेहूं','qty':920.0,'unit':'kg'},
    {'item':'चना','qty':410.0,'unit':'kg'},
    {'item':'आटा','qty':280.0,'unit':'kg'},
    {'item':'सरसों तेल','qty':145.0,'unit':'L'},
  ];

  final processing = <Map<String, String>>[
    {'input':'गेहूं 100 kg','output':'आटा 88 kg','byproduct':'चोकर 10 kg','loss':'2 kg'},
  ];

  final sellers = <Map<String, String>>[
    {'name':'Demo Seller','product':'दालें','commission':'5%','status':'Active'},
  ];

  final scrap = <Map<String, String>>[
    {'mobile':'98XXXXXX10','type':'Plastic','value':'₹120','status':'Credited'},
  ];

  @override
  void initState() {
    super.initState();
    tabs = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrigrain Admin'),
        bottom: TabBar(
          controller: tabs,
          isScrollable: true,
          tabs: const [
            Tab(text:'Dashboard'),
            Tab(text:'Orders'),
            Tab(text:'Farmer Buy'),
            Tab(text:'Processing'),
            Tab(text:'Stock'),
            Tab(text:'Sellers'),
            Tab(text:'Scrap'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabs,
        children: [
          dashboardTab(),
          ordersTab(),
          procurementTab(),
          processingTab(),
          stockTab(),
          sellersTab(),
          scrapTab(),
        ],
      ),
    );
  }

  Widget dashboardTab() {
    double totalStock = 0;
    for (final row in stock) {
      totalStock += (row['qty'] as num).toDouble();
    }
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text('Business Overview',
            style: TextStyle(fontSize:22,fontWeight:FontWeight.bold)),
        const SizedBox(height:12),
        GridView.count(
          crossAxisCount:2,
          shrinkWrap:true,
          physics:const NeverScrollableScrollPhysics(),
          crossAxisSpacing:10,
          mainAxisSpacing:10,
          childAspectRatio:1.35,
          children:[
            metric('Orders', orders.length.toString(), Icons.shopping_bag, Colors.blue),
            metric('Farmer Purchases', procurement.length.toString(), Icons.agriculture, Colors.green),
            metric('Stock Total', totalStock.toStringAsFixed(0) + ' units', Icons.inventory, Colors.orange),
            metric('Sellers', sellers.length.toString(), Icons.store, Colors.purple),
          ],
        ),
        const SizedBox(height:14),
        const Card(
          child:ListTile(
            leading:Icon(Icons.info_outline),
            title:Text('Admin Flow'),
            subtitle:Text('Farmer से खरीदी → Stock → Direct Sale या Processing → Output + By-product + Loss → Updated Stock'),
          ),
        ),
      ],
    );
  }

  Widget metric(String title,String value,IconData icon,Color color) {
    return Card(
      child:Padding(
        padding:const EdgeInsets.all(12),
        child:Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children:[
            Icon(icon,color:color,size:30),
            const SizedBox(height:6),
            Text(value,style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
            Text(title,textAlign:TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget ordersTab() {
    const statuses=['Order Placed','Processing','Packed','Out for Delivery','Delivered'];
    return ListView(
      padding:const EdgeInsets.all(12),
      children:orders.asMap().entries.map((entry) {
        final i=entry.key;
        final o=entry.value;
        return Card(
          child:Padding(
            padding:const EdgeInsets.all(12),
            child:Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children:[
                Text('#' + (o['id'] ?? '') + ' • ' + (o['customer'] ?? ''),
                    style:const TextStyle(fontWeight:FontWeight.bold)),
                Text('Amount: ' + (o['amount'] ?? '')),
                const SizedBox(height:8),
                DropdownButtonFormField<String>(
                  value:o['status'],
                  decoration:const InputDecoration(labelText:'Order Status',border:OutlineInputBorder()),
                  items:statuses.map((s)=>DropdownMenuItem(value:s,child:Text(s))).toList(),
                  onChanged:(v)=>setState(()=>orders[i]['status']=v ?? o['status']!),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget procurementTab() {
    return ListView(
      padding:const EdgeInsets.all(12),
      children:[
        FilledButton.icon(
          onPressed:addProcurementDialog,
          icon:const Icon(Icons.add),
          label:const Text('नई किसान खरीदी जोड़ें'),
        ),
        const SizedBox(height:10),
        ...procurement.map((p)=>Card(
          child:ListTile(
            leading:const Icon(Icons.agriculture),
            title:Text((p['farmer'] ?? '') + ' • ' + (p['grain'] ?? '')),
            subtitle:Text((p['qty'] ?? '') + ' @ ' + (p['rate'] ?? '') + '\n' + (p['mode'] ?? '')),
          ),
        )),
      ],
    );
  }

  void addProcurementDialog() {
    final farmer=TextEditingController();
    final grain=TextEditingController(text:'गेहूं');
    final qty=TextEditingController();
    final rate=TextEditingController();
    showDialog(
      context:context,
      builder:(ctx)=>AlertDialog(
        title:const Text('Farmer Procurement'),
        content:SingleChildScrollView(
          child:Column(
            children:[
              TextField(controller:farmer,decoration:const InputDecoration(labelText:'Farmer Name')),
              TextField(controller:grain,decoration:const InputDecoration(labelText:'Grain')),
              TextField(controller:qty,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'Quantity kg')),
              TextField(controller:rate,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'Rate ₹/kg')),
            ],
          ),
        ),
        actions:[
          TextButton(onPressed:()=>Navigator.pop(ctx),child:const Text('Cancel')),
          FilledButton(
            onPressed:(){
              if(farmer.text.trim().isEmpty || qty.text.trim().isEmpty) return;
              setState(() {
                procurement.add({
                  'farmer':farmer.text.trim(),
                  'grain':grain.text.trim(),
                  'qty':qty.text.trim() + ' kg',
                  'rate':'₹' + rate.text.trim() + '/kg',
                  'mode':'Direct Purchase',
                });
              });
              Navigator.pop(ctx);
            },
            child:const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget processingTab() {
    return ListView(
      padding:const EdgeInsets.all(12),
      children:[
        const Card(
          child:ListTile(
            leading:Icon(Icons.factory),
            title:Text('Processing Register'),
            subtitle:Text('Input, finished product, by-product और process loss दर्ज करें।'),
          ),
        ),
        ...processing.map((p)=>Card(
          child:ListTile(
            title:Text('Input: ' + (p['input'] ?? '')),
            subtitle:Text('Output: ' + (p['output'] ?? '') +
                '\nBy-product: ' + (p['byproduct'] ?? '') +
                '\nLoss: ' + (p['loss'] ?? '')),
          ),
        )),
        const SizedBox(height:8),
        FilledButton.icon(
          onPressed:(){
            setState(() {
              processing.add({
                'input':'गेहूं 50 kg',
                'output':'आटा 44 kg',
                'byproduct':'चोकर 5 kg',
                'loss':'1 kg',
              });
            });
          },
          icon:const Icon(Icons.add),
          label:const Text('Demo Processing Entry जोड़ें'),
        ),
      ],
    );
  }

  Widget stockTab() {
    return ListView(
      padding:const EdgeInsets.all(12),
      children:stock.asMap().entries.map((entry) {
        final i=entry.key;
        final s=entry.value;
        return Card(
          child:ListTile(
            leading:const Icon(Icons.inventory_2),
            title:Text(s['item'].toString()),
            subtitle:Text((s['qty'] as num).toStringAsFixed(1) + ' ' + s['unit'].toString()),
            trailing:Wrap(
              spacing:4,
              children:[
                IconButton(
                  onPressed:()=>setState(()=>stock[i]['qty']=(stock[i]['qty'] as num).toDouble()+10),
                  icon:const Icon(Icons.add_circle),
                ),
                IconButton(
                  onPressed:()=>setState(() {
                    final q=(stock[i]['qty'] as num).toDouble();
                    stock[i]['qty']=q>=10 ? q-10 : 0.0;
                  }),
                  icon:const Icon(Icons.remove_circle),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget sellersTab() {
    return ListView(
      padding:const EdgeInsets.all(12),
      children:sellers.map((s)=>Card(
        child:ListTile(
          leading:const Icon(Icons.storefront),
          title:Text(s['name'] ?? ''),
          subtitle:Text((s['product'] ?? '') + ' • Commission ' + (s['commission'] ?? '')),
          trailing:Chip(label:Text(s['status'] ?? '')),
        ),
      )).toList(),
    );
  }

  Widget scrapTab() {
    return ListView(
      padding:const EdgeInsets.all(12),
      children:scrap.map((s)=>Card(
        child:ListTile(
          leading:const Icon(Icons.recycling),
          title:Text((s['type'] ?? '') + ' • ' + (s['value'] ?? '')),
          subtitle:Text('Mobile: ' + (s['mobile'] ?? '')),
          trailing:Text(s['status'] ?? ''),
        ),
      )).toList(),
    );
  }
}
