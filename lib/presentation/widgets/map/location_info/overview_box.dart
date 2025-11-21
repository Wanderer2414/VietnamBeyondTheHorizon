import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/presentation/constants/color_palette.dart';
import 'package:intl/intl.dart';

class OverviewBox extends StatelessWidget {
  final String address;
  final double cost;
  final String openTime; // "07:30"
  final String closeTime; // "20:00"

  const OverviewBox({
    super.key,
    required this.address,
    required this.cost,
    required this.openTime,
    required this.closeTime,
  });

  bool _isOpenNow() {
    final now = DateTime.now();
    final format = DateFormat("HH:mm");
    final open = format.parse(openTime);
    final close = format.parse(closeTime);

    final nowMinutes = now.hour * 60 + now.minute;
    final openMinutes = open.hour * 60 + open.minute;
    final closeMinutes = close.hour * 60 + close.minute;

    if (closeMinutes < openMinutes) {
      return nowMinutes >= openMinutes || nowMinutes <= closeMinutes;
    }
    return nowMinutes >= openMinutes && nowMinutes <= closeMinutes;
  }

  @override
  Widget build(BuildContext context) {
    final bool isOpen = _isOpenNow();
    final Color statusColor = isOpen ? Colors.green : Colors.red;
    final String statusText = isOpen ? "OPENING" : "CLOSED";

    final price = cost.toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Overview", style: TextStyle(fontSize: 15)),
        SizedBox(height: 8),

        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 25,
              color: ColorPalette.primaryColor,
            ),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                address,
                style: TextStyle(fontFamily: "Kay Pho Du", fontSize: 13),
              ),
            ),
          ],
        ),

        SizedBox(height: 10),
        Row(
          children: [
            Icon(
              Icons.attach_money_rounded,
              size: 25,
              color: ColorPalette.primaryColor,
            ),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                price + ((price != "0") ? " VND" : "Free"),
                style: TextStyle(fontFamily: "Kay Pho Du", fontSize: 13),
              ),
            ),
          ],
        ),

        SizedBox(height: 10),
        Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 25,
              color: ColorPalette.primaryColor,
            ),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                openTime + " - " + closeTime,
                style: TextStyle(fontFamily: "Kay Pho Du", fontSize: 13),
              ),
            ),
            Text(statusText, style: TextStyle(color: statusColor)),
          ],
        ),
      ],
    );
  }
}
