import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/consts/consts.dart';

class FirestoreServices {
  //get users data
  static getUser(uid) {
    return firestore
        .collection(usersCollection)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

  //get products according to collection
  static getProducts(collection) {
    return firestore
        .collection(productsCollection)
        .where('p_collection', isEqualTo: collection)
        .snapshots();
  }

  static getSubCollectionProducts(title) {
    return firestore
        .collection(productsCollection)
        .where('p_subcollection', isEqualTo: title)
        .snapshots();
  }

  //get cart
  static getCart(uid) {
    return firestore
        .collection(cartCollection)
        .where('added_by', isEqualTo: uid)
        .snapshots();
  }

  //get address
  static getAddress(uid) {
    return firestore
        .collection(usersCollection)
        .where('address', isEqualTo: uid)
        .snapshots();
  }

  // delete document
  static deleteDocument(docId) {
    return firestore.collection(cartCollection).doc(docId).delete();
  }

  static getChatMessages(docId) {
    return firestore
        .collection(chatsCollection)
        .doc(docId)
        .collection(messagesCollection)
        .orderBy('created_on', descending: false)
        .snapshots();
  }

  static getAllOrders() {
    return firestore
        .collection(ordersCollection)
        .where('order_by', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static getWishlists() {
    return firestore
        .collection(productsCollection)
        .where('p_wishlist', arrayContains: currentUser!.uid)
        .snapshots();
  }

  static getAllMessages() {
    return firestore
        .collection(chatsCollection)
        .where('fromId', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static getCounts() async {
    var res = await Future.wait([
      firestore
          .collection(cartCollection)
          .where('added_by', isEqualTo: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
      firestore
          .collection(productsCollection)
          .where('p_wishlist', arrayContains: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
      firestore
          .collection(ordersCollection)
          .where('order_by', isEqualTo: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
    ]);
    return res;
  }

  static allproducts() {
    return firestore.collection(productsCollection).snapshots();
  }

  static allmatchbystore() {
    return firestore.collection(vendorsCollection).snapshots();
  }

  static getFeaturedProducts() {
    return firestore
        .collection(productsCollection)
        .where('is_featured', isEqualTo: true)
        .get();
  }

  static searchProducts(title) {
    return firestore.collection(productsCollection).get();
  }

  //get vendors
  static getVendor(uid) {
    return firestore
        .collection(vendorsCollection)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

  static Stream<QuerySnapshot> getOrders() {
    return firestore
        .collection(ordersCollection)
        .where('order_on_delivery', isEqualTo: false)
        .where('order_delivered', isEqualTo: false)
        .where('order_by',
            isEqualTo:
                currentUser!.uid) // If you want to filter by the current user
        .snapshots();
  }

  // Fetch orders that are currently on delivery
  static Stream<QuerySnapshot> getDeliveryOrders() {
    return firestore
        .collection(ordersCollection)
        .where('order_on_delivery', isEqualTo: true)
        .where('order_delivered',
            isEqualTo: false) // Ensuring it's not yet delivered
        .where('order_by',
            isEqualTo:
                currentUser!.uid) // If you want to filter by the current user
        .snapshots();
  }

  // Fetch orders that have been delivered (for History)
  static Stream<QuerySnapshot> getOrderHistory() {
    return firestore
        .collection(ordersCollection)
        .where('order_delivered', isEqualTo: true)
        .where('order_by',
            isEqualTo:
                currentUser!.uid) // If you want to filter by the current user
        .snapshots();
  }
}
