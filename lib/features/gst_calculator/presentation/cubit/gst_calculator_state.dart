part of 'gst_calculator_cubit.dart';

abstract class GstCalculatorState extends Equatable {
  const GstCalculatorState();

  @override
  List<Object> get props => [];
}

class GstCalculatorLoadingState extends GstCalculatorState {
  @override
  List<Object> get props => [];
}

class GstCalculatorLoadedState extends GstCalculatorState {
  final List<GstModel> ui = [
    GstModel(name: 'AC', color: Colors.green.shade800, fontSize: 23.sp, fontWeight: FontWeight.w500),
    GstModel(name: '⌫', color: Colors.green.shade800, fontSize: 23.sp, fontWeight: FontWeight.w600),
    GstModel(name: '%', color: Colors.green.shade800, fontSize: 23.sp, fontWeight: FontWeight.w600),
    GstModel(name: '÷', color: Colors.green.shade800, fontSize: 25.sp, fontWeight: FontWeight.w500),
    GstModel(name: '7', color: Colors.black, fontSize: 25.sp, fontWeight: FontWeight.w400),
    GstModel(name: '8', color: Colors.black, fontSize: 25.sp, fontWeight: FontWeight.w400),
    GstModel(name: '9', color: Colors.black, fontSize: 25.sp, fontWeight: FontWeight.w400),
    GstModel(name: 'x', color: Colors.green.shade800, fontSize: 25.sp, fontWeight: FontWeight.w500),
    GstModel(name: '4', color: Colors.black, fontSize: 25.sp, fontWeight: FontWeight.w400),
    GstModel(name: '5', color: Colors.black, fontSize: 25.sp, fontWeight: FontWeight.w400),
    GstModel(name: '6', color: Colors.black, fontSize: 25.sp, fontWeight: FontWeight.w400),
    GstModel(name: '-', color: Colors.green.shade800, fontSize: 25.sp, fontWeight: FontWeight.w500),
    GstModel(name: '1', color: Colors.black, fontSize: 25.sp, fontWeight: FontWeight.w400),
    GstModel(name: '2', color: Colors.black, fontSize: 25.sp, fontWeight: FontWeight.w400),
    GstModel(name: '3', color: Colors.black, fontSize: 25.sp, fontWeight: FontWeight.w400),
    GstModel(name: '+', color: Colors.green.shade800, fontSize: 25.sp, fontWeight: FontWeight.w500),
    GstModel(name: '00', color: Colors.black, fontSize: 25.sp, fontWeight: FontWeight.w400),
    GstModel(name: '0', color: Colors.black, fontSize: 25.sp, fontWeight: FontWeight.w400),
    GstModel(name: '.', color: Colors.black, fontSize: 25.sp, fontWeight: FontWeight.w400),
    GstModel(name: '=', color: Colors.white, fontSize: 30.sp, fontWeight: FontWeight.w500),
  ];
  final List<GstModel> gst = [
    GstModel(name: '3%', color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w400),
    GstModel(name: '5%', color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w400),
    GstModel(name: '12%', color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w400),
    GstModel(name: '18%', color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w400),
    GstModel(name: '28%', color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w400),
    GstModel(name: '-3%', color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w400),
    GstModel(name: '-5%', color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w400),
    GstModel(name: '-12%', color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w400),
    GstModel(name: '-18%', color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w400),
    GstModel(name: '-28%', color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w400),
  ];

  final String addValue;
  final String totalValue;
  final String csGst;
  final String csGstPer;
  final String iGstPer;
  final String iGst;
  final String totalWithGst;
  final bool button;
  final bool islastEqul;
  final int cursorPos;
  final TextEditingController textEditingController;

  GstCalculatorLoadedState({
    required this.addValue,
    required this.totalValue,
    required this.csGst,
    required this.csGstPer,
    required this.iGstPer,
    required this.iGst,
    required this.totalWithGst,
    required this.button,
    required this.islastEqul,
    required this.textEditingController,
    required this.cursorPos,
  });

  GstCalculatorLoadedState copywith(
      {String? addValue,
      String? totalValue,
      String? csGst,
      String? csGstPer,
      String? iGstPer,
      String? iGst,
      String? totalWithGst,
      bool? button,
      bool? islastEqul,
      TextEditingController? textEditingController,
      int? cursorPos}) {
    return GstCalculatorLoadedState(
      addValue: addValue ?? this.addValue,
      totalValue: totalValue ?? this.totalValue,
      csGst: csGst ?? this.csGst,
      csGstPer: csGstPer ?? this.csGstPer,
      iGstPer: iGstPer ?? this.iGstPer,
      iGst: iGst ?? this.iGst,
      totalWithGst: totalWithGst ?? this.totalWithGst,
      button: button ?? this.button,
      islastEqul: islastEqul ?? this.islastEqul,
      textEditingController: textEditingController ?? this.textEditingController,
      cursorPos: cursorPos ?? this.cursorPos,
    );
  }

  @override
  List<Object> get props => [addValue, totalValue, csGst, csGstPer, button, islastEqul];
}

class GstCalculatorErrorState extends GstCalculatorState {
  final String erroMessage;

  const GstCalculatorErrorState({required this.erroMessage});

  @override
  List<Object> get props => [erroMessage];
}
