import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  bool preseed = false;
  List<dynamic> _dataProv = List();
  List<dynamic> _dataKota = List();
  List<dynamic> _dataKec = List();
  String _getProv;

  String _nameProv;
  String _getKota;

  String _nameKota;
  String _getKec;

  String _nameKec;

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

  void getKota() async {
    final respose = await http.get(
        Uri.encodeFull(
            "https://dev.farizdotid.com/api/daerahindonesia/kota?id_provinsi=" +
                _getProv +
                ""),
        headers: {"Accept": "application/json"});
    var listData = jsonDecode(respose.body)["kota_kabupaten"];
    setState(() {
      _dataKota = listData;
    });
    print("data : $listData");
  }

  void getDetailKota() async {
    final respose = await http.get(
        Uri.encodeFull("https://dev.farizdotid.com/api/daerahindonesia/kota/" +
            _getKota +
            ""),
        headers: {"Accept": "application/json"});
    var listData = jsonDecode(respose.body);
    setState(() {
      _nameKota = listData['nama'];
    });
  }

  void getKec() async {
    final respose = await http.get(
        Uri.encodeFull(
            "http://dev.farizdotid.com/api/daerahindonesia/kecamatan?id_kota=" +
                _getKota),
        headers: {"Accept": "application/json"});
    var listData = jsonDecode(respose.body)["kecamatan"];
    setState(() {
      _dataKec = listData;
    });
    print("data : $listData");
  }

  void getDetailKec() async {
    final respose = await http.get(
        Uri.encodeFull(
            "https://dev.farizdotid.com/api/daerahindonesia/kecamatan/" +
                _getKec +
                ""),
        headers: {"Accept": "application/json"});
    var listData = jsonDecode(respose.body);
    setState(() {
      _nameKec = listData['nama'];
    });
  }

  @override
  void initState() {
    setState(() {
      getProv();
    });
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
              _kabKota(),
              SizedBox(height: 20),
              _kecamatan(),
              SizedBox(height: 40),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(_nameProv ?? "")),
              SizedBox(height: 10),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(_nameKota ?? "")),
              SizedBox(height: 10),
              Align(
                  alignment: Alignment.centerLeft, child: Text(_nameKec ?? "")),
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
            // width: SizeConfig.defaultSize * 40,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5)),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
              hint: Text("Pilih Provinsi"),
              value: _getProv,
              items: _dataProv.map((item) {
                return DropdownMenuItem(
                  child: Text(item['nama']),
                  value: item['id'].toString(),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _nameKota = null;
                  _nameKec = null;
                  _getKota = null;
                  _getKec = null;
                  _getProv = value;
                  getDetailProv();
                  getKota();
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _kabKota() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: DropdownButtonHideUnderline(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            // width: SizeConfig.defaultSize * 40,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5)),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
              hint: Text("Pilih Kabupaten/Kota"),
              value: _getKota,
              items: _dataKota.map((item) {
                return DropdownMenuItem(
                  child: Text(item['nama']),
                  value: item['id'].toString(),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _nameKec = null;
                  _getKec = null;
                  _getKota = value;
                  getDetailKota();
                  getKec();
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _kecamatan() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: DropdownButtonHideUnderline(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            // width: 400,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5)),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
              hint: Text("Pilih Kecamatan"),
              value: _getKec,
              items: _dataKec.map((item) {
                return DropdownMenuItem(
                  child: Text(item['nama']),
                  value: item['id'].toString(),
                );
              }).toList(),
              onChanged: (value) {
                _getKec = value;
                setState(() {
                  getDetailKec();
                });
              },
              validator: (value) =>
                  value == null ? 'Silahkan Pilih Kecamatan' : null,
            ),
          ),
        ),
      ),
    );
  }
}
