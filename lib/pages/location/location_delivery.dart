import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationDelivery extends StatefulWidget {
  const LocationDelivery({super.key});

  @override
  State<LocationDelivery> createState() => _LocationDeliveryState();
}

class _LocationDeliveryState extends State<LocationDelivery> {
  final CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(11.572543, 104.893275),
    zoom: 16,
  );

  String address = 'Loading ...';
  Timer? _timer;
  int _start = 1;

  void delayTwoSecondToGetAddress(LatLng location) {
    _timer?.cancel();
    _start = 1;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          getLocationAddress(location);
        } else {
          _start--;
        }
      },
    );
  }

  void getLocationAddress(LatLng location) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(location.latitude, location.longitude);

      if (placemarks.isNotEmpty) {
        Placemark mark = placemarks.first;

        String formattedAddress = '';
        formattedAddress += '${mark.thoroughfare ?? ''}, ';
        formattedAddress += '${mark.subLocality ?? ''}, ';
        formattedAddress += mark.locality ?? '';

        setState(() {
          address = formattedAddress.isNotEmpty
              ? formattedAddress
              : 'Address not found';
        });
      } else {
        setState(() {
          address = 'Address not found';
        });
      }
    } catch (e) {
      setState(() {
        address = 'Error: Unable to fetch address';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Location '),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: GoogleMap(
              initialCameraPosition: initialCameraPosition,
              onCameraMove: (position) {
                setState(() {
                  address = 'Loading ...';
                });
                delayTwoSecondToGetAddress(position.target);
              },
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height) / 2 - 64,
            child: const SizedBox(
              height: 64,
              child: Icon(
                Icons.location_on_rounded,
                color: Colors.red,
                size: 64,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: ColoredBox(
              color: Colors.white,
              child: Container(
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: Colors.red,
                              size: 24,
                            ),
                            Expanded(
                              child: Text(
                                address,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(),
                          minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.9,
                            45,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onPressed: () {
                          Navigator.pop(context, address);
                        },
                        child: const Text(
                          "SELECT THIS LOCATION",
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
