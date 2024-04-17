import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
User? currentUser = auth.currentUser;

//Collection
const usersCollection = "users";
const productsCollection = "products";
const usermixmatchCollection = "usermixmatchs";
const cartCollection = "cart";
const chatsCollection = 'chats';
const messagesCollection = 'messages';
const ordersCollection = 'orders';
const vendorsCollection = 'vendors';
