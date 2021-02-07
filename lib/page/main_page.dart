import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:auto_complete_search_app/model/mcu_phase_4.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/services.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Phase4 phase4 = Phase4();
  TextEditingController _searchController = TextEditingController();

  Future<String> loadJson() async {
    return rootBundle.loadString("assets/mcu_phase_4.json");
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildTextField(List phase4) {
    return TypeAheadFormField(
        textFieldConfiguration: TextFieldConfiguration(
          autofocus: false,
          controller: _searchController,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18.0,
          ),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: "Search title here:",
            labelStyle: TextStyle(color: Colors.black38),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
          ),
        ),
        onSuggestionSelected: (Phase4 phase4) {
          setState(() {
            this.phase4 = phase4;
          });
          _searchController.text = phase4.title;
        },
        noItemsFoundBuilder: (BuildContext context) {
          return ListTile(
            title: Text("Title not found!"),
          );
        },
        itemBuilder: (BuildContext context, Phase4 phase4) {
          return ListTile(
            title: Text(phase4.title),
            subtitle: Container(
              margin: EdgeInsets.only(top: 4),
              child: Text(
                "Year : ${phase4.year}",
                style: TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic),
              ),
            ),
          );
        },
        suggestionsCallback: (String query) {
          return getPhase4Suggestions(query, phase4);
        });
  }

  Widget _buildOutput() {
    return Column(
      children: [
        Container(
          width: 300,
          child: (phase4.url != null) ? Image.network(phase4.url) : Container(),
        ),
        SizedBox(height: 12),
        Container(
          child: (phase4.title != null && phase4.year != null)
              ? Text(
            "${phase4.title} (${phase4.year})",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          )
              : Text(""),
        ),
      ],
    );
  }

  Widget _buildContainer(List<Phase4> phase4) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          children: [
            _buildTextField(phase4),
            SizedBox(
              height: 16,
            ),
            _buildOutput(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Auto Complete Search"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<String>(
          future: loadJson(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final mcuPhase4 = McuPhase4.fromJson(json.decode(snapshot.data));
              return _buildContainer(mcuPhase4.phase4);
            } else {
              return Center(
                child: Text("Error load data"),
              );
            }
          },
        ),
      ),
    );
  }
}
