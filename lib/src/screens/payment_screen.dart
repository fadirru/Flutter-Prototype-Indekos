import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../src/widgets/custom_dropdown.dart';
import '../../src/models/carousel_data.dart';
import '../../src/models/dropdown_model.dart';
import '../../src/theme/constant_colors.dart';
import '../../src/screens/confirmed_screen.dart';
import '../../src/provider/reserve_provider.dart';

class Paymentscreen extends StatefulWidget {
  final CarouselData carouselData;
  final int index;

  Paymentscreen({@required this.carouselData, this.index});
  @override
  _PaymentscreenState createState() => _PaymentscreenState();
}

class _PaymentscreenState extends State<Paymentscreen> {
  List<PaymentModel> _payments = PaymentModel.getPayment();
  List<DropdownMenuItem<PaymentModel>> _dropdownMenuItemsPayment;
  PaymentModel _selectedPayment;

  List<PeriodModel> _periods = PeriodModel.getPeriod();
  List<DropdownMenuItem<PeriodModel>> _dropdownMenuItemsPeriod;
  PeriodModel _selectedPeriod;

  String _price;
  String _text;

  @override
  void initState() {
    _dropdownMenuItemsPayment = buildDropdownMenuItemsPayments(_payments);
    _dropdownMenuItemsPeriod = buildDropdownMenuItemsPeriods(_periods);
    _price = widget.carouselData.price;
    _text = 'Monthly';
    super.initState();
  }

  List<DropdownMenuItem<PaymentModel>> buildDropdownMenuItemsPayments(
      List payments) {
    List<DropdownMenuItem<PaymentModel>> items = List();
    for (PaymentModel payment in payments) {
      items.add(
        DropdownMenuItem(
          value: payment,
          child: Text(payment.payment),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItemPayment(PaymentModel selectedPayment) {
    setState(() {
      _selectedPayment = selectedPayment;
    });
  }

  List<DropdownMenuItem<PeriodModel>> buildDropdownMenuItemsPeriods(
      List periods) {
    List<DropdownMenuItem<PeriodModel>> items = List();
    for (PeriodModel period in periods) {
      items.add(
        DropdownMenuItem(
          value: period,
          child: Text(period.period),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItemPeriod(PeriodModel selectedPeriod) {
    setState(() {
      _selectedPeriod = selectedPeriod;
      if (_selectedPeriod.period == _periods[0].period) {
        _price = widget.carouselData.priceYearly;
        _text = 'Yearly';
      } else if (_selectedPeriod.period == _periods[2].period) {
        _price = widget.carouselData.priceWeekly;
        _text = 'Weekly';
      } else {
        _price = widget.carouselData.price;
        _text = 'Monthly';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _bloc = Provider.of<ReserveProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.carouselData.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(12),
                    height: MediaQuery.of(context).size.height * .275,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: mainBlack.withOpacity(.38),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: '$_text\n',
                            style: TextStyle(color: Colors.white),
                            children: [
                              TextSpan(
                                text: _price,
                                style: Theme.of(context).textTheme.headline1,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: <Widget>[
                              DropdownButtonHideUnderline(
                                child: CustomDropDown(
                                  child: DropdownButton(
                                    elevation: 0,
                                    isExpanded: true,
                                    items: _dropdownMenuItemsPayment,
                                    onChanged: onChangeDropdownItemPayment,
                                    value: _selectedPayment,
                                    hint: Text('Select Payment'),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              DropdownButtonHideUnderline(
                                child: CustomDropDown(
                                  child: DropdownButton(
                                    elevation: 0,
                                    isExpanded: true,
                                    items: _dropdownMenuItemsPeriod,
                                    onChanged: onChangeDropdownItemPeriod,
                                    value: _selectedPeriod,
                                    hint: Text('Select Period'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            trailing: IconButton(
                              icon: Icon(
                                Icons.calendar_today,
                                color: Colors.blue[700],
                              ),
                              onPressed: () => _selectDate(context),
                            ),
                            title:
                                Text('${selectedDate.toLocal()}'.split(' ')[0]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Hero(
                    tag: 'proces',
                    child: Container(
                      width: MediaQuery.of(context).size.width * .7,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.green[300],
                        disabledColor: Colors.grey,
                        disabledElevation: 0,
                        onPressed: _selectedPayment == null ||
                                _selectedPeriod == null
                            ? null
                            : () {
                                print(selectedDate.toString().split(' ')[0]);
                                return {
                                  _bloc.addToReserved(
                                    widget.index,
                                    _selectedPayment.payment,
                                    _selectedPeriod.period,
                                    selectedDate.toString().split(' ')[0],
                                    _text,
                                  ),
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Confirmedscreen(
                                        carouselData: widget.carouselData,
                                        selectedPayment: _selectedPayment,
                                        selectedPeriod: _selectedPeriod,
                                        trigger: _text,
                                      ),
                                    ),
                                  )
                                };
                              },
                        child: Text(
                          'Confirm',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
}
