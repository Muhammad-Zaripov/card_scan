import 'package:flutter/material.dart';
import '../../../../common/extension/context_extension.dart';
import '../../../../common/util/dimension.dart';
import '../state/home_state.dart';
import '../widget/custom_input.dart';
import '../widget/info_tile.dart';
import '../widget/primary_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends HomeScreenState {
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.color.white,
    appBar: AppBar(backgroundColor: context.color.white),
    body: SingleChildScrollView(
      child: Padding(
        padding: Dimension.pAll16,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Dimension.hBox10,
            CustomInput(
              controller: cardNumberController,
              type: .cardNumber,
              focusNode: cardFocus,
              nextFocus: expiryFocus,
            ),

            Dimension.hBox10,
            SizedBox(
              width: 80,
              child: CustomInput(type: .expiryDate, focusNode: expiryFocus, controller: cardDateController),
            ),
            Dimension.hBox10,
            Row(
              spacing: 30,
              children: [
                Expanded(
                  child: PrimaryButton(title: 'NFC', onTap: () {}),
                ),
                Expanded(
                  child: PrimaryButton(title: 'Cam', onTap: openScan),
                ),
              ],
            ),
            InfoTile(title: 'Card Number', value: cardNumberController.text),
            InfoTile(title: 'Expiry Date', value: cardDateController.text),
          ],
        ),
      ),
    ),
    bottomNavigationBar: Padding(
      padding: Dimension.pAll16.copyWith(bottom: 30),
      child: PrimaryButton(
        title: 'Add',
        onTap: () {
          setState(() {});
        },
      ),
    ),
  );
}
