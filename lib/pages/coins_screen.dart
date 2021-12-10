
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

import '../priceticker.dart';


class CoinsScreenPage extends StatefulWidget{
  CoinsScreenPageState createState()=> CoinsScreenPageState();

}
class CoinsScreenPageState extends State<CoinsScreenPage>{
  int currentIndex=0;

   final channel =  IOWebSocketChannel.connect(
   "ws://prereg.ex.api.ampiy.com/prices",

  );

  priceData()   {
    channel.sink.add(
        jsonEncode({
          "method": "SUBSCRIBE",
          "params": [
            "all@ticker"
          ],
          "cid": 1
        }),


    );
    // return Priceticker.fromJson(jsonDecode());




 // channel.stream.listen((priceData) {
 //      print(priceData);
 //      });
  }




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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            currentIndex=0;
          });
    },

    ),
        bottomNavigationBar: BottomAppBar(
        child: Container(
        height: 65,
        child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
        FlatButton(onPressed: (){

    },
    padding: EdgeInsets.all(10.0),

    child: Column(
    children: [
    Icon(Icons.home,color:  currentIndex == 0 ?Color(0xfffc0366): Colors.grey,),
    Text("Home",style: TextStyle(color: currentIndex == 0 ?Color(0xfffc0366): Colors.grey,),)
    ],
    )),
    FlatButton(onPressed: (){
    setState(() {
    currentIndex= 1;
    });

    },
    padding: EdgeInsets.only(right: 14,top: 10),

    child: Column(
    children: [
    Icon(CupertinoIcons.money_dollar_circle,color: currentIndex == 1 ?Color(0xfffc0366): Colors.grey,),
    Text("Coins",style: TextStyle(color: currentIndex == 1 ?Color(0xfffc0366): Colors.grey,),)
    ],
    )),
    FlatButton(onPressed: (){
    setState(() {
    currentIndex=2;
    });
    },

    padding: EdgeInsets.only(left: 24,top: 10),
    child: Column(
    children: [
    Icon(CupertinoIcons.rectangle_stack,color: currentIndex == 2 ?Color(0xfffc0366): Colors.grey,),
    Text("Wallet",style: TextStyle(color: currentIndex == 2 ?Color(0xfffc0366): Colors.grey,),)
    ],
    )),
    FlatButton(onPressed: (){
    setState(() {
    currentIndex= 3;
    });
    },
    padding: EdgeInsets.all(10.0),

    child: Column(
    children: [
    Icon(Icons.person,color: currentIndex == 3 ? Color(0xfffc0366): Colors.grey,),
    Text("You",style: TextStyle(color: currentIndex == 3 ?Color(0xfffc0366): Colors.grey,),)
    ],
    )),

    ],


    ),
    ),
        ),
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
                  builder: (context,AsyncSnapshot<dynamic> snap){
                    return
                      FutureBuilder(
                      future: priceData(),
                        builder: (context,AsyncSnapshot<dynamic>snapshot){
                        return
                        Flexible(
                         child: ListView.separated(
                              separatorBuilder: (BuildContext context,int index){
                                return Divider(
                                  thickness: 2,
                                );
                              },
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: Priceticker.fromJson(jsonDecode(snap.data)).data.length,
                              itemBuilder: (context,index){
                                return Container(
                                  child: ListTile(
                                    leading: Image.network("https://icons.iconarchive.com/icons/cjdowner/cryptocurrency/128/Bitcoin-icon.png",
                                      width: 50,),
                                    title: Text("BTC",style: TextStyle(fontWeight: FontWeight.w700),),
                                    subtitle: Text("Bitcoin"),
                                    trailing: Wrap(
                                      children: [
                                        Text(Priceticker.fromJson(jsonDecode(snap.data)).data[index].c,style: TextStyle(fontWeight: FontWeight.w500),),
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
                                              child: Text("${Priceticker.fromJson(jsonDecode(snap.data)).data[index].p}%",style: TextStyle(fontSize: 12,color: Colors.green)),
                                            )
                                        )


                                      ],
                                    ),


                                  ),

                                );
                              })
                        );


                    });
              }),



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