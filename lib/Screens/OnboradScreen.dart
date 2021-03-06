import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:order/Constants/constants.dart';

class OnboardScreen extends StatefulWidget {
  @override
  _OnboardScreenState createState() => _OnboardScreenState();
}

final _controller = PageController(initialPage: 0);
int _currentPage = 0;

List<Widget> _pages = [
  Column(
    children: [
      Expanded(
          child: SizedBox(
              height: 300, width: 300, child: Lottie.asset('assets/map.json'))),
      Text(
        'ເລືອກສະຖານທີ່ຈັດສົ່ງ',
        style: kPageViewTextStyle,
      ),
    ],
  ),
  Column(
    children: [
      Expanded(
          child: SizedBox(
              height: 300,
              width: 300,
              child: Lottie.asset('assets/store.json'))),
      Text(
        'ສັ່ງສີນຄ້າຈາກຮ້ານທີ່ສົນໃຈ',
        style: kPageViewTextStyle,
      ),
    ],
  ),
  Column(
    children: [
      Expanded(
          child: SizedBox(
              height: 300,
              width: 300,
              child: Lottie.asset('assets/delivery.json'))),
      Text(
        'ຂົນສົ່ງວ່ອງໄວ ທັນໃຈ ຮອດໜ້າບ້ານທ່ານ',
        style: kPageViewTextStyle,
      ),
    ],
  )
];

class _OnboardScreenState extends State<OnboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _controller,
            children: _pages,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        DotsIndicator(
            dotsCount: _pages.length,
            position: _currentPage.toDouble(),
            decorator: DotsDecorator(
                size: const Size.square(9.0),
                activeSize: const Size(18.0, 9.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                activeColor: Colors.orange)),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
