import 'package:flutter/material.dart';
import '../utils/dimension.dart';


class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final IconData prefixIcon;
  final Color iconColor;
  final String hintText;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final  TextInputType textInputType;
  final bool isSuffix ;
    bool  obscureText;

   AppTextField({Key? key,
    required this.controller,
    required this.prefixIcon,
    required this.iconColor,
    required this.hintText,
    required this.textInputAction,
     this.focusNode,
     this.isSuffix = false,
     this.obscureText = false,
     required this.textInputType
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimension.screenWidth,
      padding: EdgeInsets.symmetric(vertical: Dimension.height10/2),
      margin: EdgeInsets.symmetric(horizontal: Dimension.width20, vertical: Dimension.height10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimension.radius30),
        // border: const Border.fromBorderSide(BorderSide.none),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0,1),
          )
        ]
      ),
      child: TextField(
        focusNode: widget.focusNode,
        textInputAction: widget.textInputAction,
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.textInputType,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(widget.prefixIcon, color: widget.iconColor,),
          suffixIcon: widget.isSuffix? GestureDetector(
              onTap: (){
                setState(() {widget.obscureText  = !widget.obscureText;});
                },
              child: Icon(widget.obscureText ? Icons.visibility : Icons.visibility_off, color: Colors.grey,)) : null,
          hintText: widget.hintText,
          enabledBorder:  InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
