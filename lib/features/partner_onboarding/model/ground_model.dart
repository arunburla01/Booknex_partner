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
  }) : operatingDays = operatingDays ?? [],
       amenities =
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
       imagePaths = imagePaths ?? [];
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'sport': sport,
      'size': size,
      'surfaceType': surfaceType,
      'isIndoor': isIndoor,
      'hasFloodlights': hasFloodlights,
      'maxPlayers': maxPlayers,
      'pricePerHour': pricePerHour,
      'operatingDays': operatingDays,
      'openingTime': openingTime != null
          ? '${openingTime!.hour}:${openingTime!.minute}'
          : null,
      'closingTime': closingTime != null
          ? '${closingTime!.hour}:${closingTime!.minute}'
          : null,
      'amenities': amenities,
      'imagePaths': imagePaths,
      'videoPath': videoPath,
    };
  }
}
