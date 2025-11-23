import 'package:flutter/material.dart';
import 'package:vietnambeyondthehorizon/data/models/location_model.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/map_show.dart';
import 'package:vietnambeyondthehorizon/presentation/widgets/map/search_bar.dart';

class Content extends StatefulWidget {
  final List<LocationModel> route;
  final void Function(List<LocationModel> route) onSubmit;
  final void Function(LocationModel location) onLocationPress;
  final void Function() onStart;
  const Content({
    super.key,
    required this.controller, 
    required this.screenSize, 
    required this.route, 
    required this.onSubmit, 
    required this.onLocationPress,
    required this.onStart
    }
  );

  final MyMapController controller;
  final Size screenSize;

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    var mapShow = MapShow(controller: widget.controller, size: Size(screenSize.width, screenSize.height*0.6));
    return Stack(
      children: [
        mapShow,
        SearchBarWidget(
          controller: widget.controller,
          size: Size(screenSize.width * 0.9, screenSize.height * 0.05),
          onTap: () => setState(() {}),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: screenSize.width, 
            height: screenSize.height*0.4, 
            decoration: BoxDecoration(
              color:Colors.white
            ),
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: ListView(
              children: widget.route.map<Widget>((model) {
                return Container(
                  height: screenSize.height*0.06,
                  margin: EdgeInsets.only(top: 3, bottom: 3, left:10, right: 10),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black87),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: TextButton(
                    onPressed: () => widget.onLocationPress(model),
                    style: TextButton.styleFrom(
                      fixedSize: Size(screenSize.width, screenSize.height*0.06),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.zero),
                      alignment: Alignment.centerLeft
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(model.name, style: TextStyle(
                        fontFamily: "Kay Pho Du",
                        fontSize: 20
                      ),),
                    ),
                  ),
                );
              }).toList() + [
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: widget.onStart,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
                      fixedSize: Size(screenSize.width*0.4, screenSize.height*0.05),
                    ),
                    child: Text("Start", style: TextStyle(fontFamily: "Kay Pho Du", fontSize: 25, color: Colors.white))
                  ),
                )
              ]
            )
          )
        )
      ],
    );
  }
}
