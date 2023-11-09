// ignore_for_file: unused_result

import 'package:fe_flutter_ui/models/address.dart';
import 'package:fe_flutter_ui/provider/address_provider.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../components/dots_.dart';
import '../../../components/widgets/big_text.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import 'map.dart';

class AddAddressScreen extends ConsumerStatefulWidget {
  const AddAddressScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends ConsumerState<AddAddressScreen> {
  var textNameAddress = TextEditingController();
  var textDescription = TextEditingController();
  double lat = 0.0;
  double long = 0.0;
  late GoogleMapController _mapController;
  late CameraPosition _cameraPosition;
  bool isOpen = false;
  String address = '';
  String city = '';

  Future<void> handleAddress(WidgetRef ref) async {
    var userId = ref.watch(collectedUser);
    var addressX = Addresses(
        id: 0,
        userId: userId,
        nameAddress: textNameAddress.text == '' ? '' : textNameAddress.text,
        addrressValue: address,
        description: textDescription.text == '' ? '' : textDescription.text,
        status: true);

    await ref.read(addressNotifier).onSubmitAddres(addressX);
    ref.watch(addressData);
    ref.refresh(addressData);
  }

  @override
  Widget build(BuildContext context) {
    lat = ref.watch(latProvider);
    long = ref.watch(longProvider);
    _cameraPosition = CameraPosition(target: LatLng(lat, long), zoom: 17);
    if (isOpen) {
      _mapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), 17.0));
    }
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Scaffold(
        backgroundColor: Colors.black38,
        body: Consumer(
          builder: (context, ref, child) {
            address = ref.watch(addressCuren);
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                margin: EdgeInsets.only(top: Dimensions.heightListtile * 1.6, left: 15, right: 15),
                height: Dimensions.screenHeight / 1.4,
                decoration: const BoxDecoration(
                    color: AppColors.WH,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30), bottom: Radius.circular(30))),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Dimensions.heighContainer0 * 2,
                      ),
                      SizedBox(
                        height: Dimensions.heightListtile / 2.5,
                        width: Dimensions.screenWidth,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            BigText(
                              text: "Thêm địa chỉ mới",
                              textAlign: TextAlign.center,
                              size: 15,
                            ),
                            Positioned(
                              left: 15,
                              child: GestureDetector(
                                onTap: () {
                                  ref.watch(addressData);
                                  ref.refresh(addressData);
                                  Get.back();
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const DottedBoderAPP(),
                      SizedBox(
                        height: Dimensions.heighContainer3 / 1.5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              GoogleMap(
                                  onMapCreated: (GoogleMapController mapController) {
                                    _mapController = mapController;
                                  },
                                  onTap: (a) {
                                    Get.to(() => const MapScreen());
                                    isOpen = true;
                                  },
                                  onCameraMove: (position) {
                                    _cameraPosition = position;
                                  },
                                  onCameraIdle: () {
                                    _getLocationWithPin(_cameraPosition);
                                  },
                                  myLocationEnabled: true,
                                  mapToolbarEnabled: false,
                                  zoomControlsEnabled: false,
                                  compassEnabled: false,
                                  mapType: MapType.normal,
                                  initialCameraPosition: _cameraPosition),
                              Image.asset(
                                "assets/images/pin.png",
                                width: 25,
                                height: 50,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.heighContainer0,
                      ),
                      BigText(text: "Tên địa chỉ"),
                      SizedBox(
                        height: Dimensions.heighContainer0,
                      ),
                      Neumorphic(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(15))),
                            depth: -2,
                            lightSource: LightSource.topLeft,
                            color: AppColors.BACKGROUND_COLOR),
                        child: SizedBox(
                            height: Dimensions.heightAppbarSearch,
                            child: TextField(
                                controller: textNameAddress,
                                cursorColor: AppColors.BURGUNDY,
                                cursorWidth: 2,
                                cursorHeight: 35,
                                autofocus: false,
                                style: GoogleFonts.comfortaa(height: 2, fontSize: 13, fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Ví dụ nhà của Soái....',
                                  hintStyle: GoogleFonts.comfortaa(fontSize: 13, fontWeight: FontWeight.w500),
                                ))),
                      ),
                      SizedBox(
                        height: Dimensions.heighContainer0 * 2,
                      ),
                      BigText(text: "Địa chỉ*"),
                      SizedBox(
                        height: Dimensions.heighContainer0,
                      ),
                      NeumorphicButton(
                        onPressed: () {
                          Get.to(() => const MapScreen());
                          isOpen = true;
                        },
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(15))),
                            depth: 2,
                            lightSource: LightSource.topLeft,
                            color: AppColors.BACKGROUND_COLOR),
                        child: Container(
                            alignment: Alignment.centerLeft,
                            height: Dimensions.heightAppbarSearch * 1.5,
                            width: double.infinity,
                            child: BigText(
                              text: address,
                              overFlow: TextOverflow.visible,
                            )),
                      ),
                      SizedBox(
                        height: Dimensions.heighContainer0 * 2,
                      ),
                      BigText(text: "Thêm hướng dẫn"),
                      SizedBox(
                        height: Dimensions.heighContainer0,
                      ),
                      Neumorphic(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(15))),
                            depth: -2,
                            lightSource: LightSource.topLeft,
                            color: AppColors.BACKGROUND_COLOR),
                        child: SizedBox(
                            height: Dimensions.heightAppbarSearch,
                            child: TextField(
                                controller: textDescription,
                                cursorColor: AppColors.BURGUNDY,
                                cursorWidth: 2,
                                cursorHeight: 35,
                                autofocus: false,
                                style: GoogleFonts.comfortaa(height: 2, fontSize: 13, fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Ví dụ như tên cổng....',
                                  hintStyle: GoogleFonts.comfortaa(fontSize: 13, fontWeight: FontWeight.w500),
                                ))),
                      ),
                      SizedBox(
                        height: Dimensions.heighContainer0 * 3,
                      ),
                      NeumorphicButton(
                        onPressed: () async {
                          await handleAddress(ref);
                          Get.back();
                        },
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        margin: EdgeInsets.symmetric(horizontal: Dimensions.heighContainer2 / 3),
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(15))),
                            depth: 3,
                            lightSource: LightSource.topLeft,
                            color: AppColors.BURGUNDY),
                        child: SizedBox(
                            height: Dimensions.heightAppbarSearch,
                            child: Center(
                              child: BigText(
                                text: 'Thêm',
                                color: AppColors.NOODLE_COLOR,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<String> _getLocationWithPin(CameraPosition position) async {
    bool serviceEnableb;
    LocationPermission permission;

    serviceEnableb = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnableb) {
      return Future.error("Dịch vụ vị trí bị tắt");
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      return Future.error("Quyền truy cập bị từ chối");
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Error');
    }

    List<Placemark> placemarks = await placemarkFromCoordinates(position.target.latitude, position.target.longitude);
    final placemark = placemarks[3];
    for (var element in placemarks) {
      if (element.locality != '') {
        city = '${element.locality!},';
        break;
      }
    }
    if (city == "") {
      for (var element in placemarks) {
        if (element.subLocality != '') {
          city = '${element.subLocality!},';
          break;
        }
      }
    }
    address =
        ' ${placemark.street}, $city ${placemark.subAdministrativeArea == '' ? '' : '${placemark.subAdministrativeArea},'} ${placemark.administrativeArea!}, ${placemark.country}.';
// lấy tên đường
    ref.read(latProvider.notifier).update((state) => position.target.latitude);
    ref.read(longProvider.notifier).update((state) => position.target.longitude);
    ref.read(addressCuren.notifier).update((state) => address);
    city = '';

    return address;
  }
}
