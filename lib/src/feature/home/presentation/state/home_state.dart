import 'package:card_scanner/card_scanner.dart';
import 'package:flutter/material.dart';
import '../screen/home_screen.dart';

abstract class HomeScreenState extends State<HomeScreen> {
  late final TextEditingController cardNumberController;
  late final TextEditingController cardDateController;
  final cardFocus = FocusNode();
  final expiryFocus = FocusNode();
  Future<void> openScan() async {
    final cardInfo = await CardScanner.scanCard(
      scanOptions: const CardScanOptions(scanCardHolderName: true, enableDebugLogs: false),
    );

    if (cardInfo != null) {
      setState(() {
        cardNumberController.text = cardInfo.cardNumber;
        cardDateController.text = cardInfo.expiryDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    cardNumberController = TextEditingController();
    cardDateController = TextEditingController();
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    cardDateController.dispose();
    cardFocus.dispose();
    expiryFocus.dispose();
    super.dispose();
  }
}
