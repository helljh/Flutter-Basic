import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;

  static final LatLng companyLatLng = LatLng(
      37.5233273,
      126.921252,
  );

  static final Marker marker = Marker(
    markerId: MarkerId('company'),
    position: companyLatLng,
  );

  static final Circle circle = Circle(
    circleId: CircleId('choolCheckCircle'),
    center: companyLatLng,
    fillColor: Colors.blue.withOpacity(0.5),
    radius: 100,
    strokeColor: Colors.blue,
    strokeWidth: 1,
  );

  void _onMapCreated(GoogleMapController controller){
    mapController = controller;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body: FutureBuilder<String>(
        future: checkPermission(),
        builder: (context, snapshot){
          print(snapshot.data);
          if(!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting){
            return Center(
                child: CircularProgressIndicator(),
            );
          }else if(snapshot.data != '허가'){
            return Center(
              child: Text(
                snapshot.data.toString(),
              ),
            );
          }else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 3,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: companyLatLng,
                      zoom: 16.0,
                    ),
                    myLocationEnabled: true,
                    markers: Set.from([marker]),
                    circles: Set.from([circle]),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timelapse_outlined,
                        color: Colors.blue,
                        size: 50,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: ()async{
                          final curPosition = await Geolocator.getCurrentPosition(); // 현재 위치
                          final distance = Geolocator.distanceBetween(
                              curPosition.latitude,
                              curPosition.longitude,
                              companyLatLng.latitude,
                              companyLatLng.longitude,
                          );

                          bool canCheck = distance < 500;

                          // ignore: use_build_context_synchronously
                          showDialog(
                              context: context,
                              builder: (_){
                                return AlertDialog(
                                  title: Text('출근하기'),
                                  content: Text(
                                    canCheck ? '출근을 하시겠습니까?' : '출근할 수 없는 위치입니다.',
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('취소'),
                                    ),
                                    if(canCheck)
                                      TextButton(
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('출근하기'),
                                      ),
                                  ],
                                );
                              },
                          );
                        },
                        child: Text('출근하기!'),
                      )
                    ],
                  ),
                )
              ],
            );
          }
        }
      )
    );
  }

  AppBar renderAppBar(){
    return AppBar(
      title: Text('오늘도 출근',
      style: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.w700,
      ),),
      centerTitle: true,
      backgroundColor: Colors.white,
    );
  }

  Future<String> checkPermission() async{
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled(); // 위치 서비스 활성화 여부 확인

    if(!isLocationEnabled){ // 위치 서비스 활성화 안 됐을때
      return '위치 서비스를 활성화해주세요.';
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission();

    if(checkedPermission == LocationPermission.denied){ // 위치 권한 거절됨
      // 위치 권한 요청하기
      checkedPermission = await Geolocator.requestPermission();

      return '위치 권한을 허가해주세요.';
    }

    // 위치 권한 거절됨(앱에서 재요청 불가)
    if(checkedPermission == LocationPermission.deniedForever){
      return '앱의 위치 권한을 설정에서 허가해주세요.';
    }

    // 위 모든 조건이 통과되면 위치 권한 허가 완료
    return '허가';
  }
}

