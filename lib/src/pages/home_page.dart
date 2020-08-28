

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;


import 'mapas_page.dart';
import 'direcciones_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 
 
  final scansBloc= new ScansBloc();
   int currentIndex= 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text('Qr Scanner'),
        actions: <Widget>[
          IconButton(
            icon:Icon(Icons.delete_forever),
             onPressed: scansBloc.borrarScansTODOS,
          )          
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigatorBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed:() =>_scanQr(context),
        backgroundColor: Theme.of(context).primaryColor,),                  
    );
  }

  _scanQr(BuildContext context) async {
 // https://www.dofus-touch.com/
 // geo:4.434929511116871,-75.20693835601118

    dynamic futureString =' ';
 
    try {
      futureString = await BarcodeScanner.scan();
   }catch(e){
     futureString= e.toString();
    }
  
 
  
  if(futureString != null){
    final scan= ScanModel(valor: futureString);
    scansBloc.agregarScans(scan);
      

  if  ( Platform.isIOS ){
    Future.delayed(Duration(milliseconds: 750),(){
      utils.abrirScan(context,scan);
    }
    );
  }else {
     utils.abrirScan(context,scan);
  }
  }
 
  }



  Widget _callPage(int paginaActual){

     switch (paginaActual) {
      case 0 : return MapasPage();
      case 1 : return DireccionesPage();
        
       
      default: return MapasPage();
    }
  }

Widget _crearBottomNavigatorBar (){
 return BottomNavigationBar(
   currentIndex:currentIndex,
   onTap: (index){
     setState(() {
        currentIndex = index;
     });
    
   },
   items: [
     BottomNavigationBarItem(
       icon:Icon(Icons.map),
       title: Text('Maps')
     ),
      BottomNavigationBarItem(
       icon:Icon(Icons.surround_sound),
       title: Text('Direcciones')
      )
   ]);
}
}
