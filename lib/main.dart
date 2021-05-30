import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nextflow_covid_today/covid_today_result.dart';
import 'package:nextflow_covid_today/stat_box.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nextflow COVID-19 Today',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'Nextflow COVID-19 Today'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CovidTodayResult _dataFromWebAPI;

  @override
  void initState() {
    super.initState();

    print('init state');
    getData();
  }

  Future<CovidTodayResult> getData() async {
    print('get data');
    var url = Uri.parse('https://covid19.th-stat.com/api/open/today');
    var response = await http.get(url);
    print(response.body);

    var result = covidTodayResultFromJson(response.body);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    print('build');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: getData(),
        builder:
            (BuildContext context, AsyncSnapshot<CovidTodayResult> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var result = snapshot.data;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  StatBox(
                    title: 'ติดเชื้อสะสม',
                    total: result.confirmed,
                    backgroundColor: Color(0xFF77007C),
                  ),
                  SizedBox(height: 10,),
                  StatBox(
                    title: 'รักษาหาย',
                    total: result.recovered,
                    backgroundColor: Color(0xFFA01010),
                  ),
                  SizedBox(height: 10,),
                  StatBox(
                    title: 'รักษาอยู่ใน รพ.',
                    total: result.hospitalized,
                    backgroundColor: Color(0xFF036233),
                  ),
                  SizedBox(height: 10,),
                  StatBox(
                    title: 'เสียชีวิต',
                    total: result.deaths,
                    backgroundColor: Color(0xFFD902F4),
                  ),
                ],
              ),
            );
          }
          return LinearProgressIndicator();
        },
      ),
      // body: Column(
      //   children: [
      //     indicator ?? Container(),
      //     Expanded(
      //       child: ListView(
      //         children: <Widget>[
      //           ListTile(
      //             title: Text('ผู้ติดเชื่อสะสม'),
      //             subtitle: Text('${_dataFromWebAPI?.confirmed ?? "..."}'),
      //           ),
      //           ListTile(
      //             title: Text('ผู้รักษาหายแล้ว'),
      //             subtitle: Text('${_dataFromWebAPI?.recovered ?? "..."}'),
      //           ),
      //           ListTile(
      //             title: Text('ผู้รักษาอยู่ในโรงพยาบาล'),
      //             subtitle: Text('${_dataFromWebAPI?.hospitalized ?? "..."}'),
      //           ),
      //           ListTile(
      //             title: Text('ผู้เสียชีวิต'),
      //             subtitle: Text('${_dataFromWebAPI?.deaths ?? "..."}'),
      //           ),
      //         ],
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}
