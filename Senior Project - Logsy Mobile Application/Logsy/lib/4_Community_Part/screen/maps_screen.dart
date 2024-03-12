import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logsy_app/3_Record_Part/provider/foodRequest.dart';
import 'package:logsy_app/3_Record_Part/provider/restaurant.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapsScreen extends StatefulWidget {
  static const routeName = "/maps-screen";

  @override
  _MapsScreenState createState() => _MapsScreenState();
}

final kGoogleApiKey = dotenv.env['kGoogleApiKey'];
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
Completer<GoogleMapController> _controller = Completer();

class _MapsScreenState extends State<MapsScreen> {
  List<PlacesSearchResult> places = [];
  bool _isInit = true;
  bool _isLoading = false;
  Restaurant _res;
  String distance;
  double distanceInMeters;
  Position _userPosition;
  Set<Marker> markers = Set();
  FoodRequest _foodData;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final restaurant =
          Provider.of<RestaurantProvider>(context, listen: false);
      final data = ModalRoute.of(context).settings.arguments as List;
      final branchID = data[0];
      final position = data[1] as Position;
      final food = data[2] as FoodRequest;

      _userPosition = position;
      _foodData = food;

      // await restaurant.getRestaurant().then((value) {
      //   int index = value.indexWhere((element) => element.branchID == branchID);
      //   _res = value[index];
      // });

      // distanceInMeters = await Geolocator().distanceBetween(
      //     position.latitude, position.longitude, _res.latitude, _res.longitude);
      // if (distanceInMeters < 1000) {
      //   distance = distanceInMeters.toStringAsFixed(2) + " m";
      // } else {
      //   distance = (distanceInMeters / 1000).toStringAsFixed(2) + " km";
      // }

      
      final location =
          Location(_userPosition.latitude, _userPosition.longitude);
      String foodName;
      if (food.name.indexOf(' ') == -1) {
        foodName = food.name;
      } else {
        foodName = food.name.substring(0, food.name.indexOf(' '));
      }

      final result = await _places.searchNearbyWithRadius(location, 3000,
          keyword: foodName, type: "restaurant");

      setState(() {
        if (result.status == "OK") {
          places = result.results;

          result.results.forEach((f) {
            print(f.name);
            Marker resultMarker = Marker(
              markerId: MarkerId(f.name),
              infoWindow: InfoWindow(
                  onTap: () => _launchMap(f.name),
                  title: "${f.name}",
                  snippet: "${f.vicinity}"),
              position:
                  LatLng(f.geometry.location.lat, f.geometry.location.lng),
            );
            markers.add(resultMarker);
          });
          setState(() {
            _isLoading = false;
          });
        } else {
          print(result.errorMessage);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  void _launchMap(String address) async {
    String query = Uri.encodeComponent(address);
    String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    }
  }

  Widget _listRestaurant(
      List<Photo> photo, String name, String address, String rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: Material(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.1,
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15)),
                      child: Image.network(
                        photo == null
                            ? "https://genesisairway.com/wp-content/uploads/2019/05/no-image.jpg"
                            : "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photo[0].photoReference}&key=${kGoogleApiKey}",
                        height: MediaQuery.of(context).size.height * 0.1,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        Text(address, style: TextStyle(fontSize: 10)),
                        Row(
                          children: [
                            Icon(Icons.star, size: 15),
                            SizedBox(width: 5),
                            Text(rating.toString()),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _gotoRes(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text(
              _foodData == null ? "" : _foodData.name,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        elevation: 0.0,
        backgroundColor: Colors.teal[500],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _isLoading == null
          ? LinearProgressIndicator(
              backgroundColor: Colors.white,
              minHeight: 0.5,
            )
          : Column(
              children: [
                Container(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    width: double.infinity,
                    child: GoogleMap(
                      myLocationEnabled: true,
                      markers: markers,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                            _userPosition.latitude,
                            _userPosition
                                .longitude), //กำหนดพิกัดเริ่มต้นบนแผนที่
                        zoom: 13, //กำหนดระยะการซูม สามารถกำหนดค่าได้ 0-20
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                  ),
                ),
                places.length == 0
                    ? Expanded(
                        child: Center(
                          child: Text('No Restaurant Found'),
                        ),
                      )
                    : Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            color: Colors.grey[200],
                            child: Column(
                              children: places
                                  .map((p) => GestureDetector(
                                        onTap: () => _gotoRes(
                                            p.geometry.location.lat,
                                            p.geometry.location.lng),
                                        child: _listRestaurant(p.photos, p.name,
                                            p.vicinity, p.rating.toString()),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
    );
  }
}
