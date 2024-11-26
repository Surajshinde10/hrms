// import 'dart:math';
// import 'dart:typed_data';
// import 'dart:ui';
// import 'package:get/get.dart';
// import 'package:hrms/DB/DatabaseHelper.dart';
// import 'package:hrms/modules/recognition/controller/recognition_controller.dart';
// import 'package:hrms/modules/recognition/model/embedding_model.dart';
// import 'package:hrms/services/api_services.dart';
// import 'package:hrms/services/api_url.dart';
// import 'package:hrms/utilities/variable_utilities.dart';
// import 'package:hrms/widgets/common_snackbar.dart';
// import 'package:image/image.dart' as img;
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'Recognition.dart';
//
// class Recognizer {
//
//   Interpreter? interpreter;
//   late InterpreterOptions _interpreterOptions;
//   static const int WIDTH = 112;
//   static const int HEIGHT = 112;
//   final dbHelper = DatabaseHelper();
//   Map<String,Recognition> registered = Map();
//   RxBool isLoading = false.obs;
//   RxList<EmbeddingData> embeddingData = <EmbeddingData>[].obs;
//   RxList<EmbeddingData> embedding = <EmbeddingData>[].obs;
//   @override
//   String get modelName => 'assets/mobile_face_net.tflite';
//
//
//   Recognizer({int? numThreads}) {
//     _interpreterOptions = InterpreterOptions();
//     if (numThreads != null) {
//       _interpreterOptions.threads = numThreads;
//     }
//     loadModel();
//     initDB();
//   }
//
//   initDB() async {
//    await dbHelper.init();
//    await getEmbedding();
//    loadRegisteredFaces();
//   }
//
//   Future<void> getEmbedding() async {
//     embeddingData.clear();
//     final response = await API.callAPI(
//         url: ApiUrlUtilities.getEmbeddings,
//         type: APIType.tGet,
//         header: {
//           "authKey": VariableUtilities.storage.read(KeyUtilities.userToken)
//         });
//     print("Response :$response");
//
//     if (response != null) {
//       if (response.runtimeType == String && response.contains("error_")) {
//         if (response.replaceFirst("error_", "") ==
//             "Your account is inactive, please contact admin") {
//           AppSnackBar.customSnackBar(
//               message: response.replaceFirst("error_", ""), isError: true);
//           isLoading.value = false;
//         } else {
//           isLoading.value = false;
//           AppSnackBar.customSnackBar(
//               message: response.replaceFirst("error_", ""), isError: true);
//         }
//       } else {
//         response.forEach((element) {
//           embeddingData.add(EmbeddingData.fromJson(element));
//         });
//
//         embeddingData.forEach((element) {
//           if(element.faceRecogId!.isNotEmpty){
//             embedding.add(element);
//           }
//         });
//
//       }
//     }
//   }
//
//   void loadRegisteredFaces() async {
//     // final allRows = await dbHelper.queryAllRows();
//     //
//     // for (final row in allRows) {
//     //   print(row[DatabaseHelper.columnName]);
//     //   String name = row[DatabaseHelper.columnName];
//     //   List<double> embd = row[DatabaseHelper.columnEmbedding].split(',').map((e) => double.parse(e)).toList().cast<double>();
//     //   Recognition recognition = Recognition(row[DatabaseHelper.columnName],Rect.zero,embd,0);
//     //   registered.putIfAbsent(name, () => recognition);
//     // }
//
//     // for (final row in allRows) {
//     //   print(row[DatabaseHelper.columnName]);
//     //   String name = row[DatabaseHelper.columnName];
//     //   List<double> embd = row[DatabaseHelper.columnEmbedding].split(',').map((e) => double.parse(e)).toList().cast<double>();
//     //   Recognition recognition = Recognition(row[DatabaseHelper.columnName],Rect.zero,embd,0);
//     //   registered.putIfAbsent(name, () => recognition);
//     // }
//
//
//     for(final row in embedding){
//       String name = row.employeeHashCode ?? "";
//       String id = row.name ?? "";
//         List<double>  embd = row.faceRecogId!.split(",").map((e) => double.parse(e)).toList().cast<double>() ?? [];
//         Recognition recognition = Recognition(name,Rect.zero,embd,0,id);
//         print("recognition model ::${embd}");
//         registered.putIfAbsent(name, () => recognition);
//     }
//   }
//
//   void registerFaceInDB(String name, List<double> embedding) async {
//     // row to insert
//     Map<String, dynamic> row = {
//       DatabaseHelper.columnName: name,
//       DatabaseHelper.columnEmbedding: embedding.join(",")
//     };
//     final id = await dbHelper.insert(row);
//     print('inserted row id: $id');
//   }
//
//   Future<void> loadModel() async {
//     try {
//       interpreter = await Interpreter.fromAsset(modelName);
//     } catch (e) {
//       print('Unable to create interpreter, Caught Exception: ${e.toString()}');
//     }
//   }
//
//   List<dynamic> imageToArray(img.Image inputImage){
//     img.Image resizedImage = img.copyResize(inputImage, width: WIDTH, height: HEIGHT);
//     List<double> flattenedList = resizedImage.data!.expand((channel) => [channel.r, channel.g, channel.b]).map((value) => value.toDouble()).toList();
//     Float32List float32Array = Float32List.fromList(flattenedList);
//     int channels = 3;
//     int height = HEIGHT;
//     int width = WIDTH;
//     Float32List reshapedArray = Float32List(1 * height * width * channels);
//     for (int c = 0; c < channels; c++) {
//       for (int h = 0; h < height; h++) {
//         for (int w = 0; w < width; w++) {
//           int index = c * height * width + h * width + w;
//           reshapedArray[index] = (float32Array[c * height * width + h * width + w]-127.5)/127.5;
//         }
//       }
//     }
//     return reshapedArray.reshape([1,112,112,3]);
//   }
//
//   Recognition recognize(img.Image image,Rect location) {
//
//     //TODO crop face from image resize it and convert it to float array
//
//     var input = imageToArray(image);
//
//     print(input.shape.toString());
//     //TODO output array
//     List output = List.filled(1*192, 0).reshape([1,192]);
//
//     //TODO performs inference
//
//     final runs = DateTime.now().millisecondsSinceEpoch;
//     interpreter?.run(input, output);
//     final run = DateTime.now().millisecondsSinceEpoch - runs;
//     print('Time to run inference: $run ms$output');
//
//     //TODO convert dynamic list to double list
//     List<double> outputArray = output.first.cast<double>();
//
//     //TODO looks for the nearest embeeding in the databas
//     // e and returns the pair
//     Pair pair = findNearest(outputArray);
//     print("distance= ${pair.distance}");
//     return Recognition(pair.name,location,outputArray,pair.distance,pair.id);
//   }
//
//   //TODO  looks for the nearest embeeding in the database and returns the pair which contain information of registered face with which face is most similar
//   findNearest(List<double> emb){
//     Pair pair = Pair("Unknown", -1.25, "XYZ");
//     print("BEF ::${registered.entries}");
//     for (MapEntry<String, Recognition> item in registered.entries) {
//       final String name = item.key;
//       final String id = item.value.id;
//       List<double> knownEmb = item.value.embeddings;
//       print(knownEmb.length);
//       print(emb.length);
//       double distance = 0;
//       for (int i = 0; i < emb.length; i++) {
//         double diff = emb[i] -
//             knownEmb[i];
//         distance += diff*diff;
//       }
//       distance = sqrt(distance);
//       print("Hello :${distance}");
//       if (pair.distance == -1.25 || distance < pair.distance) {
//         pair.distance = distance;
//         pair.name = name;
//         pair.id = id;
//         print("DIASTAASS ::${pair.distance}");
//         print("ID :::${pair.id}");
//         print("name :::: ${pair.name}");
//       }
//     }
//     return pair;
//   }
//
//   void close() {
//     interpreter?.close();
//   }
//
// }
//
// class Pair{
//   String name;
//   double distance;
//   String id;
//   Pair(this.name,this.distance,this.id);
// }