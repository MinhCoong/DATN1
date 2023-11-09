// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import 'package:http/http.dart' as http;

import '../../../components/widgets/big_text.dart';
import '../../../main.dart';
import '../../../models/nearby_response.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/list_item.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late CameraPosition _cameraPosition;
  double lat = 0.0;
  double long = 0.0;
  int x = 0;
  String address = '';
  String radius = "30";
  String city = '';
  final Mode _mode = Mode.overlay;
  Set<Marker> markers = {};

  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();

  @override
  void initState() {
    super.initState();
  }

  late GoogleMapController _mapController;
  @override
  Widget build(BuildContext context) {
    lat = ref.watch(latProvider);
    long = ref.watch(longProvider);

    address = ref.watch(addressCuren);

    _cameraPosition = CameraPosition(target: LatLng(lat, long), zoom: 17);
    if (nearbyPlacesResponse.results != null) {
      if (nearbyPlacesResponse.results!.length >= 10) {
        x = 10;
      } else {
        x = nearbyPlacesResponse.results!.length;
      }
    }
    return Scaffold(
        key: homeScaffoldKey,
        backgroundColor: AppColors.BURGUNDY,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.BURGUNDY,
          automaticallyImplyLeading: false,
          toolbarHeight: Dimensions.heightListtile,
          elevation: 0,
          title: BigText(
            text: 'Thêm địa chỉ',
            size: 15,
            fontweight: FontWeight.w800,
            color: Colors.white,
          ),
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        body: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            children: [
              GoogleMap(
                  onMapCreated: (GoogleMapController mapController) {
                    _mapController = mapController;
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
                  markers: markers,
                  mapType: MapType.normal,
                  initialCameraPosition: _cameraPosition),
              Positioned(
                top: 10,
                left: 10,
                right: 10,
                child: NeumorphicButton(
                  onPressed: () {
                    _handlePressButton();
                  },
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(15))),
                      depth: 3,
                      lightSource: LightSource.topLeft,
                      color: Colors.white),
                  child: SizedBox(
                    height: 70,
                    child: Row(children: [
                      Icon(Icons.location_on, size: 25, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 5),
                      //here we show the address on the top
                      Expanded(
                        child: BigText(
                          text: address,
                          size: 15,
                          overFlow: TextOverflow.visible,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.search,
                        size: 25,
                      ),
                    ]),
                  ),
                ),
              ),
              Positioned(
                bottom: Dimensions.heighContainer1 / 3,
                right: 15,
                child: SizedBox(
                  height: Dimensions.heightAppbarSearch,
                  width: Dimensions.heightAppbarSearch,
                  child: NeumorphicButton(
                    onPressed: () async {
                      Position position = await _handleButton();
                      _mapController.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 17)));
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(15))),
                        depth: 3,
                        lightSource: LightSource.topLeft,
                        color: AppColors.BURGUNDY),
                    child: const Icon(
                      Icons.location_searching_rounded,
                      color: AppColors.NOODLE_COLOR,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: Dimensions.heighContainer1 / 3,
                child: NeumorphicButton(
                  onPressed: () {
                    // ref.read(latProvider.notifier).update((state) => lat);
                    // ref.read(longProvider.notifier).update((state) => long);
                    // ref
                    //     .read(addressCuren.notifier)
                    //     .update((state) => address);
                    Get.back();
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  margin: EdgeInsets.symmetric(horizontal: Dimensions.screenWidth / 3),
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(15))),
                      depth: 3,
                      lightSource: LightSource.topLeft,
                      color: AppColors.BURGUNDY),
                  child: SizedBox(
                      height: Dimensions.heightAppbarSearch,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.NOODLE_COLOR,
                          ),
                          BigText(
                            text: 'Lấy địa chỉ',
                            color: AppColors.NOODLE_COLOR,
                          ),
                        ],
                      )),
                ),
              ),
              Positioned(
                  bottom: Dimensions.heighContainer1 * 1.1,
                  child: SizedBox(
                    height: Dimensions.heighContainer2 / 1.6,
                    width: Dimensions.screenWidth,
                    child: ListView(
                      children: [
                        if (nearbyPlacesResponse.results != null)
                          for (int i = 0; i < x; i++) nearbyPlacesWidget(nearbyPlacesResponse.results![i])
                      ],
                    ),
                  )),
              Center(
                child: Image.asset(
                  "assets/images/pin.png",
                  width: 25,
                  height: 50,
                ),
              )
            ],
          ),
        ));
  }

  Future<Position> _handleButton() async {
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

    Position position = await Geolocator.getCurrentPosition();
    //Contains detailed placemark information.
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
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
    ref.read(latProvider.notifier).update((state) => position.latitude);
    ref.read(longProvider.notifier).update((state) => position.longitude);
    ref.read(addressCuren.notifier).update((state) => address);
    city = '';

    return position;
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: 'vi',
        strictbounds: false,
        types: [""],
        overlayBorderRadius: BorderRadius.circular(20),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Tìm kiếm',
          hintStyle: GoogleFonts.comfortaa(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        logo: Container(
          height: Dimensions.heighContainer0 * 3,
        ),
        components: [
          Component(Component.country, "vn"),
          // Component(Component.country, "usa")
        ]);
    if (p != null) {
      displayPrediction(p, homeScaffoldKey.currentState);
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    Get.snackbar(
      'Lỗi',
      response.errorMessage!,
    );
    // ignore: avoid_print
    print(
      response.errorMessage!,
    );
  }

  Future<void> displayPrediction(Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: kGoogleApiKey, apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    lat = detail.result.geometry!.location.lat;
    long = detail.result.geometry!.location.lng;

    markers.clear();
    markers.add(Marker(markerId: const MarkerId("0"), position: LatLng(lat, long), infoWindow: InfoWindow(title: detail.result.name)));

    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    final placemark = placemarks[0];
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
    ref.read(latProvider.notifier).update((state) => lat);
    ref.read(longProvider.notifier).update((state) => long);
    ref.read(addressCuren.notifier).update((state) => address);
    city = '';
    //lấy vị trí lân cận
    var url = Uri.parse('https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$long&radius=$radius&key=$kGoogleApiKey');

    var response = await http.post(url);

    nearbyPlacesResponse = NearbyPlacesResponse.fromJson(jsonDecode(response.body));

    setState(() {});
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), 17.0));
  }

  Future<String> lstParcemarks(Results results) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(results.geometry!.location!.lat ?? lat, results.geometry!.location!.lng ?? long);
    final placemark = placemarks[0];
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
    city = '';
    return address;
  }

  Widget nearbyPlacesWidget(Results results) {
    return FutureBuilder<String>(
        future: lstParcemarks(results),
        builder: (_, snapshot) {
          if (!snapshot.hasData) return Container();
          if (snapshot.hasData) {
            return NeumorphicButton(
              margin: const EdgeInsets.only(top: 5),
              onPressed: () {
                ref.read(latProvider.notifier).update((state) => results.geometry!.location!.lat ?? lat);
                ref.read(longProvider.notifier).update((state) => results.geometry!.location!.lng ?? long);
                ref.read(addressCuren.notifier).update((state) => snapshot.data!);
                Get.back();
              },
              style: NeumorphicStyle(boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15))),
              child: SizedBox(
                width: Dimensions.screenWidth / 1.1,
                child: Column(
                  children: [
                    BigText(text: results.name!),
                    BigText(
                      text: snapshot.data!,
                      overFlow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        });
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
