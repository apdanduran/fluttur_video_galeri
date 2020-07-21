import 'package:flutter/material.dart';

class VideoSettingsPage extends StatefulWidget {
  final String videoPath;
  const VideoSettingsPage({Key key, this.videoPath}) : super(key: key);

  @override
  _VideoSettingsPageState createState() => _VideoSettingsPageState(videoPath);
}

class _VideoSettingsPageState extends State<VideoSettingsPage> {
  String videoPath;
  bool yorumIzin = false;
  bool duetIzin = false;
  bool cihazaKayit = false;
  _VideoSettingsPageState(this.videoPath);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
            child: new Text("Yayınla",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center)),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(left: 5.0, top: 5, right: 5),
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        width: width * 0.6,
                        height: 150,
                        child: TextField(
                          decoration: new InputDecoration(
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(left: 15, top: 11, right: 15),
                              hintText: "Videonuzu açıklayın"),
                          expands: false,
                          keyboardType: TextInputType.multiline,
                          minLines: 1, //Normal textInputField will be displayed
                          maxLines:
                              5, // when user presses enter it will adapt to it
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Container(
                          child: Image.network(
                            'https://picsum.photos/250?image=9',
                            height: height * 0.21,
                            width: width * 0.32,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text("#Etiketler"),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("@Arkadaşlar"),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10),
                child: Divider(),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.lock_open,
                          color: Colors.grey,
                          size: width / 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text("Bu videoyu kimler görüntüleyebilir"),
                        )
                      ],
                    ),
                    FlatButton(
                      onPressed: () => {},
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[Icon(Icons.keyboard_arrow_right)],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.comment,
                          color: Colors.grey,
                          size: width / 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text("Yorumlara izin ver"),
                        )
                      ],
                    ),
                    Switch(
                      value: yorumIzin,
                      onChanged: (value) {
                        setState(() {
                          yorumIzin = value;
                          print("yorumIzin " + yorumIzin.toString());
                        });
                      },
                      activeTrackColor: Colors.lightBlueAccent,
                      activeColor: Colors.blue,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.video_call,
                          color: Colors.grey,
                          size: width / 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text("Düet ve Tepkilere izin ver"),
                        )
                      ],
                    ),
                    Switch(
                      value: duetIzin,
                      onChanged: (value) {
                        setState(() {
                          duetIzin = value;
                          print("Düet ve tepkilere izin" + duetIzin.toString());
                        });
                      },
                      activeTrackColor: Colors.lightBlueAccent,
                      activeColor: Colors.blue,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.save_alt,
                          color: Colors.grey,
                          size: width / 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text("Cihazına kaydet"),
                        )
                      ],
                    ),
                    Switch(
                      value: cihazaKayit,
                      onChanged: (value) {
                        setState(() {
                          cihazaKayit = value;
                          print("Cihazına kaydet izni :" +
                              cihazaKayit.toString());
                        });
                      },
                      activeTrackColor: Colors.lightBlueAccent,
                      activeColor: Colors.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => VideoSettingsPage(
                videoPath: videoPath,
              ),
            ),
          );
        },
        child: Icon(
          Icons.done,
          size: 30,
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
