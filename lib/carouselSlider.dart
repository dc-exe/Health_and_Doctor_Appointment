import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_and_doctor_appointment/model/bannerModel.dart';
import 'package:health_and_doctor_appointment/screens/disease.dart';
import 'package:health_and_doctor_appointment/screens/diseasedetail.dart';

class Carouselslider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      child: CarouselSlider.builder(
        itemCount: bannerCards.length,
        itemBuilder: (context, index, realIndex) {
          return Container(
            //alignment:  Alignment.centerLeft,
            //width: MediaQuery.of(context).size.width,
            height: 140,
            margin: EdgeInsets.only(left: 0, right: 0, bottom: 20),
            padding: EdgeInsets.only(left: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                stops: [0.3, 0.7],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: bannerCards[index].cardBackground,
              ),
            ),
            child: GestureDetector(
              onTap: () {
                index == 0
                    ? Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                        return Disease();
                      }))
                    : Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                        return DiseaseDetail(disease: 'Covid-19');
                      }));
              },
              child: Stack(
                children: [
                  Image.asset(
                    bannerCards[index].image,
                    //'assets/414.jpg',
                    fit: BoxFit.fitHeight,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 7, right: 5),
                    alignment: Alignment.topRight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          bannerCards[index].text,
                          //'Check Disease',
                          style: GoogleFonts.lato(
                            color: Colors.lightBlue[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.lightBlue[900],
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          scrollPhysics: ClampingScrollPhysics(),
        ),
      ),
    );
  }
}
