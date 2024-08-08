import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key, required this.image, required this.categoria});

  final String image, categoria;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        // Navigator.pushNamed(context, SearchPage.routeName, arguments: categoria);
      },
      child: HoverCrossFadeWidget(
        duration: const Duration(milliseconds: 100),
        firstChild: Column(
          children: [
            Image.asset(image, height: 50, width: 50,),
            const SizedBox(height: 5,),
            Text(categoria, style: const TextStyle(fontWeight: FontWeight.w700),),
          ],
        ),
        secondChild: MaterialButton(
          onPressed: () {  },
          child: Column(
            children: [
              Image.asset(image, height: 55, width: 60,),
              Text(categoria, style: const TextStyle(fontWeight: FontWeight.w700),),
            ],
          ),
        ),
      )
    );
  }
}
