import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  List<dynamic> _dataProv = List();
  List<dynamic> _dataDist = List();
  List<dynamic> _dataSubDist = List();
  String _getProv;
  String _nameProv;
  String _getDist;
  String _nameDist;
  String _getSubDist;
  String _nameSubDist;
  bool disableSubDist = false; // for enable or disable sub-district's dropdown

  // get all province
  void getProv() async {
    final respose = await http.get(
        Uri.encodeFull(
            "https://dev.farizdotid.com/api/daerahindonesia/provinsi"),
        headers: {"Accept": "application/json"});
    var listData = jsonDecode(respose.body)["provinsi"];
    setState(() {
      _dataProv = listData;
    });
    print("data : $listData");
  }

  // get detail of province that we choose
  void getDetailProv() async {
    final respose = await http.get(
        Uri.encodeFull(
            "https://dev.farizdotid.com/api/daerahindonesia/provinsi/" +
                _getProv +
                ""),
        headers: {"Accept": "application/json"});
    var listData = jsonDecode(respose.body);
    setState(() {
      _nameProv = listData['nama'];
    });
  }

  // get all district base on province
  void getDistrict() async {
    final respose = await http.get(
        Uri.encodeFull(
            "https://dev.farizdotid.com/api/daerahindonesia/kota?id_provinsi=" +
                _getProv +
                ""),
        headers: {"Accept": "application/json"});
    var listData = jsonDecode(respose.body)["kota_kabupaten"];
    setState(() {
      _dataDist = listData;
    });
    print("data : $listData");
  }

  // get detail of city/district that we choose
  void getDetailDistrict() async {
    final respose = await http.get(
        Uri.encodeFull("https://dev.farizdotid.com/api/daerahindonesia/kota/" +
            _getDist +
            ""),
        headers: {"Accept": "application/json"});
    var listData = jsonDecode(respose.body);
    setState(() {
      _nameDist = listData['nama'];
    });
  }

  // get all sub-district base on city/district
  void getSubDistrict() async {
    final respose = await http.get(
        Uri.encodeFull(
            "http://dev.farizdotid.com/api/daerahindonesia/kecamatan?id_kota=" +
                _getDist),
        headers: {"Accept": "application/json"});
    var listData = jsonDecode(respose.body)["kecamatan"];
    setState(() {
      _dataSubDist = listData;
    });
    print("data : $listData");
  }

  // get detail of sub-district that we choose
  void getDetailSubDistrict() async {
    final respose = await http.get(
        Uri.encodeFull(
            "https://dev.farizdotid.com/api/daerahindonesia/kecamatan/" +
                _getSubDist +
                ""),
        headers: {"Accept": "application/json"});
    var listData = jsonDecode(respose.body);
    setState(() {
      _nameSubDist = listData['nama'];
    });
  }

  @override
  void initState() {
    getProv();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dependent Dropdown'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text('API from https://dev.farizdotid.com'),
              SizedBox(height: 40),
              _provinsi(),
              SizedBox(height: 20),
              _district(),
              SizedBox(height: 20),
              _subDistrict(disableSubDist),
              SizedBox(height: 40),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(_nameProv ?? "")),
              SizedBox(height: 10),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(_nameDist ?? "")),
              SizedBox(height: 10),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(_nameSubDist ?? "")),
            ],
          ),
        ),
      ),
    );
  }

  Widget _provinsi() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: DropdownButtonHideUnderline(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5)),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
              hint: Text("Choose Province"),
              value: _getProv,
              items: _dataProv.map((item) {
                return DropdownMenuItem(
                  child: Text(item['nama']),
                  value: item['id'].toString(),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  disableSubDist = true;
                  _nameDist = null;
                  _nameSubDist = null;
                  _getDist = null;
                  _getSubDist = null;
                  _getProv = value;
                  getDetailProv();
                  getDistrict();
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _district() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: DropdownButtonHideUnderline(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5)),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
              hint: Text("Choose District"),
              value: _getDist,
              items: _dataDist.map((item) {
                return DropdownMenuItem(
                  child: Text(item['nama']),
                  value: item['id'].toString(),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  disableSubDist = false;
                  _nameSubDist = null;
                  _getSubDist = null;
                  _getDist = value;
                  getDetailDistrict();
                  getSubDistrict();
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _subDistrict(enableSubDist) {
    return IgnorePointer(
      ignoring: enableSubDist,
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Align(
          alignment: Alignment.centerLeft,
          child: DropdownButtonHideUnderline(
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5)),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
                hint: Text("Choose Sub-District"),
                value: _getSubDist,
                items: _dataSubDist.map((item) {
                  return DropdownMenuItem(
                    child: Text(item['nama']),
                    value: item['id'].toString(),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _getSubDist = value;
                    getDetailSubDistrict();
                  });
                },
                validator: (value) =>
                    value == null ? 'Silahkan Pilih Kecamatan' : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
