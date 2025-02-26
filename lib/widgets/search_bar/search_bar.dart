import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: "",
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          prefixIcon: _isTyping
              ? null
              : SizedBox(height: 10.h,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      "assets/logos/transit_logo.png",
                      height: 15,
                    ),
                  ),
              ),
          suffixIcon: const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.search, color: Colors.black, size: 24),
          ),
        ),
      ),
    );
  }
}
