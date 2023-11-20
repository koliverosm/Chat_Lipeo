import 'package:flutter/material.dart';

class MyChatBubble extends StatelessWidget{
  const MyChatBubble({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(20)
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text("Lorem ipsut dolore", style: TextStyle(color: Colors.white,),),
          ),
        ),
        const SizedBox(height: 20,)

      ],
    );
  }

}
