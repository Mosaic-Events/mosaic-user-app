import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:user_app/utils/appbar.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final DateRangePickerController _dateRangePickerController =
      DateRangePickerController();
  DateTime selectedDates = DateTime.now();

  final firstDate = DateTime(2021, 1);
  final lastDate = DateTime(2021, 12);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Book Now'),
      body: SfDateRangePicker(
        controller: _dateRangePickerController,
        selectionMode: DateRangePickerSelectionMode.multiple,
        showTodayButton: true,
        showActionButtons: true,
        enablePastDates: false,
        onSubmit: (dates) {
          if (dates != null) {
            Get.back(result: dates);
          }
        },
        onCancel: () {
          _dateRangePickerController.selectedDates?.clear();
          Get.back();
        },
      ),
    );
  }
}
