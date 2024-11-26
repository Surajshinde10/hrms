import 'package:flutter/material.dart';
import 'package:flutter_marquee/flutter_marquee.dart';
import 'package:get/get.dart';
import 'package:FaceAxis/utilities/color_utilities.dart';
import 'package:FaceAxis/utilities/font_utilities.dart';

class CommonDropDownField extends StatelessWidget {
  final double? verticalPadding;
  final String selectedValue;
  final String title;
  final String? emptySelectedValue;
  final List dataList;
  final bool isValueSelected;
  final bool? isValueInDialog;
  final TextEditingController? searchController;
  final Function() onIconTap;
  final Function(String a)? onChange;
  final Function(int a) onTileTap;

  CommonDropDownField({
    super.key,
    required this.onTileTap,
    required this.onIconTap,
    required this.dataList,
    required this.title,
    required this.isValueSelected,
    this.isValueInDialog,
    required this.selectedValue,
    this.emptySelectedValue,
    this.verticalPadding,
    this.onChange,
    this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: FontUtilities.h14(
              color: ColorUtilities.whiteColor.withOpacity(0.7),
              fontFamily: FontFamily.interRegular,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: verticalPadding ?? 10,
        ),
        Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onIconTap,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color:
                        ColorUtilities.whiteColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: verticalPadding ?? 10),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 310, // Set a specific width for the marquee
                          child: Marquee(
                            str: selectedValue, // Long text
                            containerWidth: 280, // Adjusted width based on your design
                            baseMilliseconds: 5000, // Faster speed for better visibility
                            textStyle: TextStyle(

                                color: ColorUtilities.whiteColor
                                    .withOpacity(0.7),
                                fontFamily: FontFamily.interRegular,

                            ),
                          ),
                        ),

                        Icon(
                          isValueSelected
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: ColorUtilities.whiteColor
                              .withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              isValueSelected
                  ? Container(
                      decoration: BoxDecoration(
                        color: ColorUtilities.whiteColor
                            .withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: Get.height * 0.22,
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 7),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                onTileTap(index);
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.start,
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 10, right: 15),
                                    child: Text(
                                      dataList[index] ?? "",
                                      style: FontUtilities.h18(
                                        color: ColorUtilities
                                            .whiteColor
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: dataList.length,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
