# Retrofit For Dart

retrofit.dart is an [dio](https://github.com/flutterchina/dio/) client generator using [source_gen](https://github.com/dart-lang/source_gen) and inspired by [Chopper](https://github.com/lejard-h/chopper).

## Usage

### Generator

Add the generator to your dev dependencies

```yaml
dependencies:
  retrofit:

dev_dependencies:
  retrofit_generator:
  build_runner:
```

### Define and Generate your API

```dart
import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';

part 'demo.retrofit.dart';

@RestApi(baseUrl: "https://httpbin.org/")
abstract class RestClient {
  static final RestClient instance = _RestClient();

  @GET("/get")
  @Headers({
    "Header-One": " header 1",
  })
  Future<Response<String>> ip(@Query('query1') String query,
      {@QueryMap() Map<String, dynamic> queryies,
      @Header("Header-Two") String header});

  @GET("/profile/{id}")
  Future<Response<String>> profile(@Path("id") String id,
      {@Query("role") String role = "user",
      @QueryMap() Map<String, dynamic> map = const {},
      @Body() Map<String, dynamic> map2});

  @POST("/post")
  @Headers({
    "Accept": "application/json",
  })
  Future<Response<String>> createProfile(@Query('query2') String query,
      {@QueryMap() Map<String, dynamic> queryies,
      @Header("Header-One") String header,
      @Body() Map<String, dynamic> map2,
      @Field() int field,
      @Field("field-g") String ffff});

  @PUT("/put")
  Future<Response<String>> updateProfile2(@Query('query3') String query,
      {@QueryMap() Map<String, dynamic> queryies,
      @Header("Header-One") String header,
      @Field() int field,
      @Field("field-g") String ffff});

  @PATCH("/patch")
  Future<Response<String>> updateProfile(@Query('query4') String query,
      {@QueryMap() Map<String, dynamic> queryies,
      @Field() int field,
      @Field("field-g") String ffff});
}
```

then run the generator

```sh
pub run build_runner build

#flutter
flutter packages pub run build_runner build
```

### Use it

```dart
import 'package:retrofit_example/demo.dart';

main(List<String> args) {
  final client = RestClient.instance;

  client.ip("trevor").then((it) => print(it));
}

```