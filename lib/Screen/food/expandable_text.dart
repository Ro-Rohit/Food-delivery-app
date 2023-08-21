import 'package:flutter/material.dart';
import 'package:yummy/utils/colors.dart';
import 'package:yummy/widgets/Big_text.dart';
import 'package:yummy/widgets/small_text.dart';
import 'package:yummy/utils/dimension.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  const ExpandableText({Key? key, required this.text}) : super(key: key);

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool showFullText = false;
  late String firstHalf ;
  late String secondHalf;
  double textHeight = Dimension.screenHeight/5.63;

  @override
  void initState() {
    if(widget.text.length  > textHeight){
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf = widget.text.substring( textHeight.toInt() +1, widget.text.length);
    }else{
      firstHalf = widget.text;
      secondHalf = "";
    }

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SmallText(
          text: showFullText? "$firstHalf$secondHalf" : "$firstHalf...",
          color: AppColors.paraColor,
          size: Dimension.font16,
          overflow: TextOverflow.visible,
          lineHeight: 1.5,
        ),
        SizedBox(height: Dimension.height10/2,),
        GestureDetector(
          onTap: (){
            setState(() {
              showFullText = !showFullText;
            });
          },
          child: Row(
            children: [
               BigText(text: showFullText ? "Read less": "Read more", size: Dimension.font20,),
              SizedBox(height: Dimension.height10/5,),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Icon(
                  showFullText
                      ? Icons.keyboard_arrow_down_outlined
                      : Icons.keyboard_arrow_up_outlined,
                  color: AppColors.mainColor,),
              )
            ],
          ),
        ),
      ],
    );
  }
}
