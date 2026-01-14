import 'dart:typed_data';

import 'package:card_scanner/card_scanner.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/nfc_manager_android.dart';
import '../screen/home_screen.dart';

abstract class HomeScreenState extends State<HomeScreen> {
  late final TextEditingController cardNumberController;
  late final TextEditingController cardDateController;
  final cardFocus = FocusNode();
  final expiryFocus = FocusNode();

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

  Future<void> readNfcCard() async {
    debugPrint('🔵 readNfcCard() chaqirildi');

    final isAvailable = await NfcManager.instance.isAvailable();
    debugPrint('🔵 NFC available: $isAvailable');

    if (!isAvailable) {
      debugPrint('❌ NFC yoqilmagan');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('NFC yoqilmagan yoki mavjud emas')));
      return;
    }

    debugPrint('🟡 NFC session start qilinyapti');

    await NfcManager.instance.startSession(
      pollingOptions: {NfcPollingOption.iso14443},
      onDiscovered: (tag) async {
        debugPrint('🟢 TAG TOPILDI');
        debugPrint('🟢 TAG DATA: $tag');

        final isoDep = IsoDepAndroid.from(tag);
        debugPrint('🟢 IsoDep: $isoDep');

        if (isoDep == null) {
          debugPrint('❌ IsoDep null (EMV karta emas)');
          await NfcManager.instance.stopSession();
          return;
        }

        try {
          debugPrint('➡️ PPSE yuborilyapti');
          final ppse = Uint8List.fromList([
            0x00,
            0xA4,
            0x04,
            0x00,
            0x0E,
            0x32,
            0x50,
            0x41,
            0x59,
            0x2E,
            0x53,
            0x59,
            0x53,
            0x2E,
            0x44,
            0x44,
            0x46,
            0x30,
            0x31,
          ]);

          final ppseResp = await isoDep.transceive(ppse);
          debugPrint('✅ PPSE RESP: ${_bytesToHex(ppseResp)}');

          debugPrint('➡️ AID yuborilyapti');
          final aid = Uint8List.fromList([0x00, 0xA4, 0x04, 0x00, 0x07, 0xA0, 0x00, 0x00, 0x00, 0x03, 0x10, 0x10]);

          final aidResp = await isoDep.transceive(aid);
          debugPrint('✅ AID RESP: ${_bytesToHex(aidResp)}');

          debugPrint('➡️ GPO yuborilyapti');
          final gpo = Uint8List.fromList([0x80, 0xA8, 0x00, 0x00, 0x02, 0x83, 0x00, 0x00]);

          final gpoResp = await isoDep.transceive(gpo);
          debugPrint('✅ GPO RESP: ${_bytesToHex(gpoResp)}');

          debugPrint('➡️ READ RECORD yuborilyapti');
          final read = Uint8List.fromList([0x00, 0xB2, 0x01, 0x14, 0x00]);

          final recResp = await isoDep.transceive(read);
          debugPrint('✅ RECORD RESP: ${_bytesToHex(recResp)}');

          debugPrint('🎉 NFC O‘QISH YAKUNLANDI');
        } catch (e, s) {
          debugPrint('🔥 NFC ERROR: $e');
          debugPrint('🔥 STACK: $s');
        } finally {
          debugPrint('🛑 NFC SESSION STOP');
          await NfcManager.instance.stopSession();
        }
      },
    );
  }

  String _bytesToHex(Uint8List bytes) => bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ').toUpperCase();
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
}
