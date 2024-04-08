// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter_finalproject/Views/collection_screen/address_controller.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Address ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddressScreen(),
    );
  }
}

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  List<String> addresses = [
    '7/4 Village No.s Bamroongrat Road,Pibulsongkran Sub-district,Muang District,Bangkok, 10400',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text('Address'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: Colors.grey.shade200, height: 1.0),
        ),
      ),
      body: ListView.builder(
        itemCount: addresses.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add new address'),
              onTap: () async {
                Get.to(() => AddressForm());
              },
            );
          } else {
            return ListTile(
              title: Text(addresses[index - 1]),
              trailing: TextButton(
                child: const Text(
                  'Edit',
                  style:
                      TextStyle(color: Colors.red), // Change text color to red
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditAddressScreen(
                            initialAddress: addresses[index - 1])),
                  );
                  if (result != null) {
                    setState(() {
                      addresses[index - 1] = result['firstName'] +
                          ' ' +
                          result['surname'] +
                          ', ' +
                          result['number'] +
                          ' ' +
                          result['street'] +
                          ', ' +
                          result['city'] +
                          ', ' +
                          result['county'] +
                          ', ' +
                          result['postcode'];
                    });
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class EditAddressScreen extends StatelessWidget {
  final String initialAddress;

  const EditAddressScreen({required this.initialAddress});

  @override
  Widget build(BuildContext context) {
    TextEditingController firstNameController = TextEditingController(text: '');
    TextEditingController surnameController = TextEditingController(text: '');
    TextEditingController numberController = TextEditingController(text: '');
    TextEditingController streetController = TextEditingController(text: '');
    TextEditingController cityController = TextEditingController(text: '');
    TextEditingController countyController = TextEditingController(text: '');
    TextEditingController postcodeController = TextEditingController(text: '');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Address'),
        centerTitle: true, // Align title to center
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: Colors.grey.shade200, height: 1.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: surnameController,
              decoration: const InputDecoration(labelText: 'Surname'),
            ),
            TextField(
              controller: numberController,
              decoration: const InputDecoration(labelText: 'Number'),
            ),
            TextField(
              controller: streetController,
              decoration: const InputDecoration(labelText: 'Street'),
            ),
            TextField(
              controller: cityController,
              decoration: const InputDecoration(labelText: 'City'),
            ),
            TextField(
              controller: countyController,
              decoration: const InputDecoration(labelText: 'County'),
            ),
            TextField(
              controller: postcodeController,
              decoration: const InputDecoration(labelText: 'Postcode'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, {
                    'firstName': firstNameController.text,
                    'surname': surnameController.text,
                    'number': numberController.text,
                    'street': streetController.text,
                    'city': cityController.text,
                    'county': countyController.text,
                    'postcode': postcodeController.text,
                  }),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
