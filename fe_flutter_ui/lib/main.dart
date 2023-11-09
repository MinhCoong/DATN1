// ignore_for_file: unused_result, avoid_print
import 'dart:io';

import 'package:fe_flutter_ui/models/address.dart';
import 'package:fe_flutter_ui/models/coupons.dart';
import 'package:fe_flutter_ui/provider/cart_provider.dart';
import 'package:fe_flutter_ui/provider/customer_provider.dart';
import 'package:fe_flutter_ui/provider/news_provider.dart';
import 'package:fe_flutter_ui/provider/notification_provider.dart';
import 'package:fe_flutter_ui/provider/order_provider.dart';
import 'package:fe_flutter_ui/screens/curved_nationbar.dart';
import 'package:fe_flutter_ui/screens/login/login_screen.dart';
import 'package:fe_flutter_ui/screens/notification/notification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fe_flutter_ui/service/myhtttp.dart';
import 'package:fe_flutter_ui/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

final collectedUser = StateProvider<String>(
    (ref) => FirebaseAuth.instance.currentUser == null ? 'null' : FirebaseAuth.instance.currentUser!.uid);

final addressCuren = StateProvider<String>((ref) => 'null');
final textName = StateProvider<String>((ref) => 'null');
final textPhone = StateProvider<String>((ref) => 'null');
final latProvider = StateProvider<double>((ref) => 0.0);
final longProvider = StateProvider<double>((ref) => 0.0);
final addAddress = StateProvider<Addresses>((ref) => Addresses());
final addCoupons = StateProvider<Coupons>((ref) => Coupons());
final indexCoupons = StateProvider<int>((ref) {
  return 0;
});
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.instance.subscribeToTopic("AllUser");
  HttpOverrides.global = MyHttpOverrides();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // String locationMessage = 'Current Location of the User';
  String address = 'Địa chỉ hiện tại!';
  String city = '';
  // String district = '';
  late String lat;
  late String long;
  Future<void> _getCurrentLocation() async {
    Position position;
    if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
      // Use location.
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      //check đã bật vị trí chưa
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        //hỏi cho phép sài
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location permissions are permanently denided, we cannot request');
      }
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
//Contains detailed placemark information.
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      final placemark = placemarks[3];
      for (var element in placemarks) {
        if (element.locality != '') {
          city = '${element.locality!},';
          break;
        }
      }
      address =
          ' ${placemark.street}, $city ${placemark.subAdministrativeArea}, ${placemark.administrativeArea!}, ${placemark.country}.';
// lấy tên đường

      ref.read(addressCuren.notifier).update((state) => address);
    } else if (await Permission.speech.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
      openAppSettings();
    }
  }

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 50);
    Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      lat = position.latitude.toString();
      long = position.longitude.toString();

      ref.read(latProvider.notifier).update((state) => double.parse(lat));
      ref.read(longProvider.notifier).update((state) => double.parse(long));
    });
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  void setupFirebaseMessaging() {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings darwinInitializationSettings = DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings, iOS: darwinInitializationSettings);
    const AndroidNotificationChannel androidNotificationChannel = AndroidNotificationChannel("mrSoai", "Messages",
        description: "This is for flutter firebase", importance: Importance.max);
    createChanel(androidNotificationChannel);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _firebaseMessaging.getToken().then((token) {
      print('FCM Token: $token');
    });

    // Xử lý thông báo khi ứng dụng đang mở
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message: ${message.notification?.title}');
      ref.refresh(notificationData);
      ref.refresh(orderData);
      final notification = message.notification;
      final android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
              androidNotificationChannel.id,
              androidNotificationChannel.name,
              channelDescription: androidNotificationChannel.description,
              icon: android.smallIcon,
            )));
      }
    });

    // Xử lý thông báo khi ứng dụng được mở từ trạng thái nền
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
      Navigator.pushNamed(context, '/Notification');
    });
  }

  @override
  void initState() {
    setupFirebaseMessaging();
    super.initState();
  }

  void createChanel(AndroidNotificationChannel channel) async {
    final FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
    await plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  @override
  Widget build(BuildContext context) {
    _getCurrentLocation();
    _liveLocation();
    FirebaseAuth.instance.currentUser == null ? null : ref.watch(couponsData);
    FirebaseAuth.instance.currentUser == null ? null : ref.watch(cartData);
    final userId = ref.watch(collectedUser);
    FirebaseAuth.instance.currentUser == null ? null : ref.read(customerMrSoai).getCustomer(userId);
    ref.refresh(customerMrSoai);
    return GetMaterialApp(
        title: 'Mr.Soái',
        theme: ThemeData(
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            elevation: 5,
            shadowColor: Colors.black26,
            backgroundColor: Colors.white,
            foregroundColor: Colors.white,
            surfaceTintColor: Color.fromARGB(255, 150, 150, 150),
          ),
          colorScheme: const ColorScheme.light().copyWith(primary: AppColors.BURGUNDY),
        ),
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        initialRoute: FirebaseAuth.instance.currentUser == null ? 'Login' : 'Home',
        routes: {
          'Login': (context) => const LoginScreen(),
          'Home': (context) => const BottomNavigaBar(),
          'Notification': (context) => const NotificationScreen(),
        },
        home: const BottomNavigaBar());
  }
}
