import 'package:flutter_finalproject/Views/collection_screen/address_controller.dart';
import 'package:flutter_finalproject/controllers/address_controller.dart';
import 'package:flutter_finalproject/controllers/editaddress_controller.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  var controller = Get.put(AddressController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text('Address').text.size(24).fontFamily(medium).color(greyDark2).make(),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: Colors.grey.shade200, height: 1.0),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 8.0),
          Container(
            height: 100,
            width: double.infinity,
            child: ListTile(
              leading: const Icon(Icons.add),
              title: Text('Add new address'),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddressForm()),
                );
              },
            ),
          ),
          Divider(
            color: thinGrey01,
          ).box.padding(EdgeInsets.symmetric(horizontal: 12)).make(),
          SizedBox(height: 8.0),
          Expanded(
            child: Container(
              color: whiteColor,
              child: controller.addresses != null
                  ? ListView.builder(
                      itemCount: controller.addresses?.length ?? 0,
                      itemBuilder: (context, index) {
                        String uid = currentUser!.uid;
                        return GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(
                                      4), // Optional: if you want rounded corners
                                ),
                                child: ListTile(
                                  title: Text(controller.addresses![index]),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton(
                                        child: const Text(
                                          'Edit',
                                          style: TextStyle(
                                              color:
                                                  primaryApp), // Make sure primaryApp is defined
                                        ),
                                        onPressed: () {
                                          final addressData = controller
                                              .addresses![index]
                                              .split(',');
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  editaddress_controller(
                                                documentId: controller
                                                        .addressesDocumentIds![
                                                    index],
                                                firstname: addressData[0],
                                                surname: addressData[1],
                                                address: addressData[2],
                                                city: addressData[3],
                                                state: addressData[4],
                                                postalCode: addressData[5],
                                                phone: addressData[6],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      TextButton(
                                        child: const Text(
                                          'Remove',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            controller.removeAddress(
                                                uid, index);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(color: thinGrey0)
                                  .box
                                  .margin(EdgeInsets.symmetric(horizontal: 12))
                                  .make(),
                            ],
                          ),
                        );
                      },
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
