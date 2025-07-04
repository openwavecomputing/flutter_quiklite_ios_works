import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../main.dart';
import '../../constants/word_constants.dart';
import '../constants/size_constants.dart';
import 'alert_action.dart';

class AppAlert {
  AppAlert._();

  static showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    ));
  }

  static Future<AlertAction> showCustomDialogOK(BuildContext context,String message,
      {String? description = ""}) async {
    final action = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // Future.delayed(Duration(seconds: 5), () {
          //   Navigator.of(context).pop(true);
          // });
          return PopScope(
            canPop: false,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConstants.s16),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(SizeConstants.s8),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(SizeConstants.s24),
                ),
                child: Container(
                  padding: EdgeInsets.all(SizeConstants.s16),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(SizeConstants.s16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Padding(
                        padding: EdgeInsets.all(SizeConstants.s12),
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: SizeConstants.s20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87),
                        ),
                      ),
                      description!.isEmpty
                          ? const SizedBox()
                          : Padding(
                        padding: EdgeInsets.all(SizeConstants.s12),
                        child: Text(
                          description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: SizeConstants.s16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: SizeConstants.s12),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(AlertAction.yes);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  SizeConstants.s16,
                                  SizeConstants.s8,
                                  SizeConstants.s16,
                                  SizeConstants.s8),
                              child: Text("OK",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConstants.s20,
                                    fontWeight: FontWeight.w500),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
    return (action != null) ? action : AlertAction.cancel;
  }

}


