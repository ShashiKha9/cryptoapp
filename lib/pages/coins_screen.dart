
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class CoinsScreenPage extends StatefulWidget{
  CoinsScreenPageState createState()=> CoinsScreenPageState();

}
class CoinsScreenPageState extends State<CoinsScreenPage>{

  final channel = IOWebSocketChannel.connect(
    Uri.parse("ws://prereg.ex.api.ampiy.com/prices")

  );



  Icon searchicon = Icon(CupertinoIcons.search);
  final searchController= TextEditingController();
  void searchPressed(){
    setState(() {
      if(this.searchicon== CupertinoIcons.search){
        this.searchicon== new Icon(CupertinoIcons.clear);
        TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Search",
            prefixIcon: Icon(CupertinoIcons.search)),
          );

      } else{
        this.searchicon= Icon(CupertinoIcons.search);
        Text("Enter text");

      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: 20,left: 20,bottom: 3),
          child:Text("COINS",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
              ),
              Padding(padding: EdgeInsets.only(left: 20,right: 20,bottom: 10),
             child: TextField(
               keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: "Search",
              suffixIcon: Icon(CupertinoIcons.search,color: Colors.black,),

                  contentPadding: EdgeInsets.all(10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(width: 1.0,color: Colors.black)
                  )
                  
                ),

              ),
              ),
              StreamBuilder(
                stream: channel.stream,
                  builder: (context,AsyncSnapshot snap){
                    return Text(snap.hasData ? '${snap.data}' : '');
              }),

              ListView.separated(
                separatorBuilder: (context,index){
                  return Divider(
                    thickness: 2,


                  );
                },
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: 7,
                  itemBuilder: (context,index){
                return Container(
                  child: ListTile(
                    leading: Image.network("https://icons.iconarchive.com/icons/cjdowner/cryptocurrency/128/Bitcoin-icon.png",
                    width: 50,),
                    title: Text("BTC",style: TextStyle(fontWeight: FontWeight.w700),),
                    subtitle: Text("Bitcoin"),
                    trailing: Wrap(
                      children: [
                        Text("49,94,000",style: TextStyle(fontWeight: FontWeight.w500),),
                        SizedBox(
                         width: 20,
                        ),
                        Container(
                          height: 28,
                          width: 55,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12)
                      ),
                          child:Center(
                            child: Text("+1.75%",style: TextStyle(fontSize: 12,color: Colors.green)),
                          )
                        )


                      ],
                    ),

                      
                  ),

                );
              }),

            ],
          ),

    ));


  }
 data(){
    channel.sink.add(
    jsonEncode({
  "method": "SUBSCRIBE",
  "params": [
  "all@ticker"
  ],
  "cid": 1
  })
    );
    channel.stream.listen((data) {
      print(data);
    });
  }

  @override
  void dispose(){
    channel.sink.close();
    super.dispose();
  }



}