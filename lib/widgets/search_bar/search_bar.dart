import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transit/core/theme/colors.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;

  const CustomSearchBar({super.key, required this.controller});

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        _isTyping = widget.controller.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric( horizontal: 8.0, vertical: 8),
      child: Container(padding: EdgeInsets.all(0),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: const Color.fromARGB(65, 0, 0, 0),blurRadius: 30,offset: Offset(2, 2),spreadRadius: 2)
      ]),
        child: TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: "",
            filled: true,
            fillColor: white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16,horizontal: 4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            prefixIcon: _isTyping
                ? null
                : SizedBox(height: 40.h,width: 40.w,
                  child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Image.asset(
                        "assets/logos/transit_logo.png",
                       // height: 15,
                      ),
                    ),
                ),
            suffixIcon:  Padding(
              padding: EdgeInsets.only(right: 10),
              child: SizedBox(
                height: 5.h,width: 7.w,
                child: Image.asset('assets/general_icons/search.png', fit: BoxFit.scaleDown,scale: 4,), ),
            ),
          ),
        ),
      ),
    );
  }
}
