import 'package:flutter/material.dart';

class GroundModel {
  String id;
  String name;
  String type; // e.g., Turf, Indoor, etc.
  String sport;
  String size;
  String? surfaceType;
  bool isIndoor;
  bool hasFloodlights;
  int? maxPlayers;
  double? pricePerHour;

  // Availability
  List<String> operatingDays;
  TimeOfDay? openingTime;
  TimeOfDay? closingTime;

  // Amenities
  Map<String, bool> amenities;

  // Media
  List<String> imagePaths;
  String? videoPath;

  GroundModel({
    required this.id,
    this.name = '',
    this.type = '',
    this.sport = '',
    this.size = '',
    this.surfaceType,
    this.isIndoor = false,
    this.hasFloodlights = false,
    this.maxPlayers,
    this.pricePerHour,
    List<String>? operatingDays,
    this.openingTime,
    this.closingTime,
    Map<String, bool>? amenities,
    List<String>? imagePaths,
    this.videoPath,
  }) : this.operatingDays = operatingDays ?? [],
       this.amenities =
           amenities ??
           {
             "Washroom": false,
             "Drinking Water": false,
             "Changing Room": false,
             "Seating Area": false,
             "Equipment Provided": false,
             "Bowling Machine": false,
             "Canteen / Snacks": false,
           },
       this.imagePaths = imagePaths ?? [];
}
