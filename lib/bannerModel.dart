import 'package:flutter/material.dart';

class BannerModel {
  String text;
  List<Color> cardBackground;
  String image;

  BannerModel(this.text, this.cardBackground, this.image);
}

List<BannerModel> bannerCards = [
  new BannerModel(
      "Check Disease",
      [
        Color(0xffa1d4ed),
        Color(0xffc0eaff),
      ],
      "assets/414.jpg"),
  new BannerModel(
      "Covid-19",
      [
        Color(0xffffffff),
        Color(0xffffddde),
      ],
      "assets/virus.jpg"),
];
