import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/utils/utils.dart';


class DireccionesPage extends StatelessWidget {
  

   final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {

    scansBloc.obtenerScans();
    return StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scansStreamHttp,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot){
        if ( !snapshot.hasData){
         return Center (child: CircularProgressIndicator());
                            
        }
         final scans = snapshot.data ;

        if (scans.length == 0){
         return Center (
           child:Text ('no info')
        );
      }
        
       return ListView.builder(
         itemCount: scans.length,
         itemBuilder: (context, i)=> Dismissible(
           key: UniqueKey(),
           onDismissed: (direction)=> scansBloc.borrarScans(scans[i].id),
           background:
             Container(child: Text('Eliminar'),color:Colors.red,padding: EdgeInsets.all(28.0),),                     
           child:ListTile(
           onTap:() =>abrirScan(context,scans[i]) ,
           title: Text(scans[i].valor),
           subtitle: Text('ID: ${scans[i].id}'),
           trailing: Icon(Icons.keyboard_arrow_right,color:Colors.grey),
           leading: Icon(Icons.cloud_queue,color: Theme.of(context).primaryColor),
           )
          )         
         );

      }
      
      );
  }
}