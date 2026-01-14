import 'package:flutter/material.dart';
import '../../../../common/text_input/mask_text_input_formatter.dart';
import '../../data/enums/input_type.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({required this.controller, required this.type, required this.focusNode, this.nextFocus, super.key});

  final TextEditingController controller;
  final InputType type;
  final FocusNode focusNode;
  final FocusNode? nextFocus;

  @override
  Widget build(BuildContext context) {
    final isCard = type == InputType.cardNumber;
    final maxLen = isCard ? 19 : 5;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      maxLength: maxLen,
      decoration: InputDecoration(
        counterText: '',
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputFormatters: [MaskedInputFormatter(maskPattern: isCard ? '#### #### #### ####' : '##/##')],
      onChanged: (value) {
        if (value.length == maxLen && nextFocus != null) {
          nextFocus!.requestFocus();
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) return 'Maydon bo‘sh';

        if (isCard) {
          if (value.replaceAll(' ', '').length != 16) {
            return 'Karta raqami noto‘g‘ri';
          }
        } else {
          if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(value)) {
            return 'MM/YY formatda kiriting';
          }
        }
        return null;
      },
    );
  }
}
