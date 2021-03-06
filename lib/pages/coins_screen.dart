
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

import '../priceticker.dart';


class CoinsScreenPage extends StatefulWidget{
  CoinsScreenPageState createState()=> CoinsScreenPageState();

}
class CoinsScreenPageState extends State<CoinsScreenPage>{

  final channel =  IOWebSocketChannel.connect(
   "ws://prereg.ex.api.ampiy.com/prices",
  );


 priceData()  async {
    channel.sink.add(
        jsonEncode({
          "method": "SUBSCRIBE",
          "params": [
            "all@ticker"
          ],
          "cid": 1
        }),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body:
           Column(
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
               // onChanged: searchOperation,
              ),
              ),
              StreamBuilder (
                stream: channel.stream,
                  builder: (context,AsyncSnapshot<dynamic> snap) {
                    return
                       FutureBuilder<dynamic>(
                          future: priceData(),
                          builder: (context, AsyncSnapshot<dynamic>snapshot){
                              return
                                Flexible(
                                    child: ListView.separated(
                                        separatorBuilder: (BuildContext context,
                                            int index) {
                                          return Divider(
                                            thickness: 2,
                                          );
                                        },
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount:(snap.data==null)?0:Priceticker.fromJson(jsonDecode(snap.data)).data?.length??0,
                                        itemBuilder: (context, index) {

                                          return Container(
                                            child: ListTile(
                                              leading: Image.network(
                                                "https://icons.iconarchive.com/icons/cjdowner/cryptocurrency/128/Bitcoin-icon.png",
                                                width: 50,),
                                              title: Text(
                                                Priceticker.fromJson(
                                                  jsonDecode(snap.data))
                                                .data![index].s.replaceAll("INR","" ).toString(), style: TextStyle(
                                                  fontWeight: FontWeight
                                                      .w700),),
                                              trailing: Wrap(
                                                children: [
                                                  Text("???${Priceticker
                                                      .fromJson(
                                                      jsonDecode(snap.data))
                                                      .data![index].c.toString()}",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight
                                                            .w500),),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Container(
                                                      height: 28,
                                                      width: 95,
                                                      decoration: BoxDecoration(
                                                          border: Border
                                                              .all(
                                                              color: Colors
                                                                  .black12)
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                            "${Priceticker
                                                                .fromJson(
                                                                jsonDecode(
                                                                    snap
                                                                        .data))
                                                                .data![index]
                                                                .p.toString()
                                                            }%",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .green)),
                                                      )
                                                  )

                                                ],
                                              ),
                                            ),

                                          );
                                        })
                                );
                          }
                      );
                  }
                  ),
            ],
          ),
    ));
  }

  @override
  void dispose(){
    channel.sink.close();
    super.dispose();
  }



}