import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gst_calculator/features/gst_calculator/data/models/gst_ui_model.dart';
import 'package:gst_calculator/features/gst_calculator/presentation/cubit/gst_calculator_cubit.dart';
import 'package:gst_calculator/get_it.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  late GstCalculatorCubit gstCalculatorCubit;
  @override
  void initState() {
    super.initState();
    gstCalculatorCubit = getItInstance<GstCalculatorCubit>();
    gstCalculatorCubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: const Text(
            "Gst Calculator",
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: BlocBuilder<GstCalculatorCubit, GstCalculatorState>(
          bloc: gstCalculatorCubit,
          builder: (context, state) {
            if (state is GstCalculatorLoadedState) {
              List<GstModel> list = state.ui;
              List<GstModel> gst = state.gst;
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Visibility(
                                  visible: state.csGst.isEmpty,
                                  child: Container(
                                    alignment: Alignment.topRight,
                                    child: Column(
                                      children: [
                                        AnimatedContainer(
                                          duration: const Duration(milliseconds: 100),
                                          alignment: Alignment.topRight,
                                          child: Visibility(
                                            visible: state.button == false,
                                            child: TextField(
                                              style: TextStyle(fontSize: 25.sp),
                                              textAlign: TextAlign.right,
                                              keyboardType: TextInputType.none,
                                              onChanged: (value) {
                                                gstCalculatorCubit.textEdToetxt(state: state, text: value);
                                              },
                                              controller: gstCalculatorCubit.textEditingController,
                                              decoration: const InputDecoration(border: InputBorder.none),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: state.button ? 0.h : 80.h),
                                        Visibility(
                                          visible: state.iGst.isEmpty,
                                          child: AnimatedContainer(
                                            curve: Curves.linearToEaseOut,
                                            duration: const Duration(milliseconds: 100),
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              state.totalValue,
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: state.button ? 35.sp : 30.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: state.totalWithGst.isNotEmpty,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: ScreenUtil().screenWidth * 0.95,
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        state.totalValue,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 35.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                nameDetailRow(data: state.csGst, title: "CGST[${state.csGstPer}%]"),
                                SizedBox(height: 4.h),
                                nameDetailRow(data: state.csGst, title: "SGST[${state.csGstPer}%]"),
                                SizedBox(height: 4.h),
                                nameDetailRow(data: state.iGst, title: "IGST[${state.iGstPer}%]"),
                                SizedBox(height: 6.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total (With GSt)",
                                      style: TextStyle(
                                        color: Colors.green.shade800,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      width: ScreenUtil().screenWidth * 0.55,
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        (state.totalWithGst),
                                        style: TextStyle(
                                          color: Colors.green.shade800,
                                          fontSize: 25.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.black12),
                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: gst.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        childAspectRatio: 7 / 3.5,
                        crossAxisSpacing: 9.w,
                        mainAxisSpacing: 5.h,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            HapticFeedback.vibrate();
                            gstCalculatorCubit.calculation(name: gst[index].name, state: state, context: context);
                          },
                          borderRadius: BorderRadius.circular(100.r),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              color: const Color.fromARGB(13, 0, 0, 0),
                            ),
                            child: Text(
                              gst[index].name,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 5.h),
                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: list.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 8.h,
                        childAspectRatio: 7 / 5.2,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          splashFactory: InkSparkle.splashFactory,
                          onTap: () {
                            HapticFeedback.vibrate();
                            gstCalculatorCubit.calculation(name: list[index].name, state: state, context: context);
                          },
                          borderRadius: BorderRadius.circular(100.r),
                          child: Container(
                            height: 70.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  list[index].name == "=" ? Colors.green.shade800 : const Color.fromARGB(13, 0, 0, 0),
                            ),
                            child: Center(
                              child: Text(
                                list[index].name,
                                style: TextStyle(
                                  fontSize: list[index].fontSize,
                                  color: list[index].color,
                                  fontWeight: list[index].fontWeight,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget nameDetailRow({required String title, required String data}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          overflow: TextOverflow.ellipsis,
          title,
          style: TextStyle(color: Colors.black54, fontSize: 13.sp),
        ),
        Text(
          overflow: TextOverflow.ellipsis,
          data,
          style: TextStyle(color: Colors.black54, fontSize: 18.sp, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
