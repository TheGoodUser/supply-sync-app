import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplysync/providers/private_key_provider.dart';
import 'package:supplysync/services/transaction.dart';

class MoneySendPopupWidget extends StatefulWidget {
  const MoneySendPopupWidget({super.key});

  @override
  State<MoneySendPopupWidget> createState() => _MoneySendPopupWidgetState();
}

class _MoneySendPopupWidgetState extends State<MoneySendPopupWidget> {
  late TextEditingController _controller;
  late EthService _ethService;

  // confirming loading
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _ethService = EthService();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitPayment(BigInt amountInEther) async {
    setState(() {
      _isLoading = true;
    });
    final key = context.read<PrivateKeyProvider>().privateKey;
    if (key == null) return;
    final tx = await _ethService.sendEth(
      toAddress: "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
      amountInEther: amountInEther,
      privateKey: key,
    );
    log('OUTPUT: $tx');
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Material(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // close button
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  // height: 200,
                  child: Column(
                    spacing: 25,
                    children: [
                      TextField(
                        keyboardType: TextInputType.number,
                        onTapOutside: (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        controller: _controller,
                        decoration: InputDecoration(
                          prefix: Text('ΞTH  '),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.orangeAccent,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade800,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Enter amount',
                        ),
                      ),
                      // submit button
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00d4ff), Color(0xFF5b5fff)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00d4ff).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              if (_controller.text.isEmpty) return;
                              await _submitPayment(
                                BigInt.parse(_controller.text),
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Center(
                              child: _isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      'Submit',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
