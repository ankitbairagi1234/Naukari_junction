import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:http/http.dart'as http;
import 'package:job_dekho_app/Utils/style.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/getwalletmodel.dart';
import '../../Model/addwalletmodel.dart';
import '../../Services/tokenString.dart';
import '../../Utils/CustomWidgets/customButton.dart';


class AddMoneyUI extends StatefulWidget {
  @override
  _AddMoneyUIState createState() => _AddMoneyUIState();
}

class _AddMoneyUIState extends State<AddMoneyUI> {
  final _formKey = GlobalKey<FormState>();

  AddWalletModel? addWalletModel;

  TextEditingController _amountController = TextEditingController();

  addWallet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString(TokenString.userid);


    print('_________________>>>>>>>>>>>>>>>>>>>>>${userid}');


    var headers = {
      'Cookie': 'ci_session=ec52faaf4141b7aee9f262fa0bdfee398ae84f13'
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://developmentalphawizz.com/naukari_junction/api/add_money_wallet'));
    request.fields.addAll({
      'user_id': userid.toString(),
      'amount': _amountController.text,
      'transaction_id': '120',
      'type': 'credit'
    });

    print("This is user request>>>>>>>>>>>${request.fields}");

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var finalresponse = await response.stream.bytesToString();
      final jsonresponse = AddWalletModel.fromJson(jsonDecode(finalresponse));

      setState(() {
        addWalletModel = jsonresponse;
      });

    }
    else {
      print(response.reasonPhrase);
    }
  }

  @override
  Getwalletmodel? walletData;

  getWallet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString(TokenString.userid);


    print('_________________>>>>>>>>>>>>>>>>>>>>>${userid}');
    var headers = {
      'Cookie': 'ci_session=8c2275d8af8aa49a38366843cf03ea05190bd53b'
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://developmentalphawizz.com/naukari_junction/api/get_wallet_transaction'));
    request.fields.addAll({
      'user_id': userid.toString()
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var walletresult = await response.stream.bytesToString();
      final finalresponse = Getwalletmodel.fromJson(json.decode(walletresult));
      setState((){
        walletData = finalresponse;
      });

    }
    else {
      print(response.reasonPhrase);
    }
  }


  // getWallet() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String? id = preferences.getString("id");
  //
  //   print('_________________>>>>>>>>>>>>>>>>>>>>>${id}');
  //   var headers = {
  //     'Cookie': 'ci_session=8c2275d8af8aa49a38366843cf03ea05190bd53b'
  //   };
  //   var request = http.MultipartRequest('POST', Uri.parse('https://developmentalphawizz.com/financego/app/v1/api/get_wallet_transaction'));
  //   request.fields.addAll({
  //     'user_id': id.toString()
  //   });
  //
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     var walletresult = await response.stream.bytesToString();
  //     final finalresponse = Getwalletmodel.fromJson(json.decode(walletresult));
  //     setState((){
  //       walletData = finalresponse;
  //     });
  //
  //   }
  //   else {
  //     print(response.reasonPhrase);
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWallet();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("${getTranslated(context, 'Add_Money')}",
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontWeight: FontWeight.w700,color:whiteColor),
        ),
      ),
      body:
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                Center(
                  child: Container(
                      height: 90,
                      width: 170,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white, border: Border.all(color: primaryColor)),
                      child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                              children:[
                                Text( "${getTranslated(context, 'Current_Bal')}",
                                  // "Your Current Balance",
                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                walletData==null || walletData?.data?.first.amount == ""? Center(child: CircularProgressIndicator(color: primaryColor,),):
                                Text('\₹' + "${walletData?.data?.first.amount}",
                                    style: Theme.of(context).textTheme
                                        .headline4!
                                        .copyWith(color: Colors.black),
                                    textAlign: TextAlign.center),
                              ]))),
                ),

                SizedBox(height: 20),

                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 25),
                        child: TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '${getTranslated(context, 'Please_enter_amount')}';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            hintText: "${getTranslated(context, 'Enter_Amount')}",

                            suffixIcon: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child: Icon(Icons.wallet,color: primaryColor,),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                         child: CustomButton(buttonText: "${getTranslated(context, 'Add_Money')}", onTap: (){
                           if (_formKey.currentState!.validate()) {
                            Razorpay razorpay = Razorpay();
                             var options = {
                            'key': 'rzp_test_1spO8LVd5ENWfO',
                             'amount': int.parse(_amountController.text)*100,
                             'name': 'Ankit',
                             'description': 'Fine T-Shirt',
                            'retry': {'enabled': true, 'max_count': 1},
                            'send_sms_hash': true,
                            'prefill': {
                            'contact': '8888888888',
                            'email': 'test@razorpay.com'
                         },
                         'external': {
                         'wallets': ['paytm']
                         }
                         };
                         razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                         handlePaymentErrorResponse);
                         razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                         handlePaymentSuccessResponse);
                         razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                         handleExternalWalletSelected);
                         razorpay.open(options);
                         }
                           }),
                      ),
                      // addWalletModel==null || addWalletModel?.data?.amount== ""? Center(child: CircularProgressIndicator(),):
                      // Text(
                      //   'Recharge Application ' + locale.balance! + ' \₹${addWalletModel?.data?.amount}' ?? "",
                      //   style: Theme.of(context).textTheme.subtitle1,
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),

    );

  }
  void handlePaymentErrorResponse(PaymentFailureResponse response){
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response){

    addWallet();

    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }
  void handleExternalWalletSelected(ExternalWalletResponse response){
    showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }


  void showAlertDialog(BuildContext context, String title, String message){
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
