// import 'package:equatable/equatable.dart';
// import 'package:hydrated_bloc/hydrated_bloc.dart';

// class OnboardCubit extends HydratedCubit<OnboardState> {
//   OnboardCubit() : super(const OnboardState());

//   void setAlready() {
//     emit(state.copyWith(isAlready: true));
//   }

//   @override
//   fromJson(Map<String, dynamic> json) => OnboardState(
//         isAlready: json['isAlready'] as bool,
//       );

//   @override
//   Map<String, dynamic>? toJson(state) => {
//         "isAlready": state.isAlready.toString(),
//       };
// }

// class OnboardState extends Equatable {
//   const OnboardState({
//     this.isAlready = false,
//   });

//   final bool isAlready;

//   OnboardState copyWith({
//     bool? isAlready,
//   }) {
//     return OnboardState(
//       isAlready: isAlready ?? this.isAlready,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         isAlready,
//       ];
// }
