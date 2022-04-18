import 'dart:io';

import 'package:band_names/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Band> bands = [];

  @override
  void initState() {
    final socketServices = Provider.of<SocketServices>(context, listen: false);

    socketServices.socket.on('active-bands', _handlerActiveBands);    

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final socketServices = Provider.of<SocketServices>(context);
    
    return Scaffold(
      appBar: AppBar( 
        title: const Text(' Band Names', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.only( right: 10),
            child: socketServices.serverStatus == ServerStatus.online ?
                  Icon( Icons.check_circle, color: Colors.blue[300]) :
                  const Icon( Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: ( _ , index)  => _BandTile(band: bands[index])
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon( Icons.add ),
        onPressed: _addNewBand,
      ),
   );
  }

  _handlerActiveBands( dynamic payload ){
    bands = (payload as List)
        .map( (band) => Band.fromMap(band) )
        .toList();

    setState(() {});
  }

  _addNewBand(){

    final textController = TextEditingController();

    if( Platform.isAndroid ){
      return showDialog( 
        context: context,
        builder: ( _ ) => AlertDialog(
          title: const Text('New band name:'),
          content: TextField(
            controller: textController,
          ),
          actions: [
            MaterialButton(
              child: const Text('Add'),
              elevation: 5,
              textColor: Colors.blue,
              onPressed: () => _addBandToList( textController.text ),
            )
          ],
        )
      );
    }else{
      showCupertinoDialog(
        context: context, 
        builder: ( _ ) => CupertinoAlertDialog(
          title: const Text('New band name:'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Add'),
              onPressed: () => _addBandToList( textController.text ),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Dismiss'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
    }
  }

  _addBandToList(String bandName){
    final socketServices = Provider.of<SocketServices>(context, listen: false);

    print(bandName);
    if( bandName.length > 1 ){
      socketServices.emit('emitir-new-band', { 'name': bandName });
    }

    Navigator.pop(context);
  }

}

class _BackgroundDeleteBand extends StatelessWidget {
  const _BackgroundDeleteBand({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container( 
      padding: const EdgeInsets.only( left: 8.0),
      color: Colors.red, 
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: const [
            Icon( Icons.delete, color: Colors.white,),
            Text(' Delete Band', style: TextStyle(color: Colors.white, fontSize: 20),),
          ],
        )
      ), 
    );
  }
}

class _BandTile extends StatelessWidget {

  final Band band; 

  const _BandTile({
    Key? key,
    required this.band,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final socketServices = Provider.of<SocketServices>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      background: Container( 
        padding: const EdgeInsets.only( left: 8.0),
        color: Colors.red, 
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: const [
              Icon( Icons.delete, color: Colors.white,),
              Text(' Delete Band', style: TextStyle(color: Colors.white, fontSize: 20),),
            ],
          )
        ), 
      ),
      direction: DismissDirection.startToEnd,
      onDismissed: ( _ ) => socketServices.emit('emitir-delete', { 'id': band.id }),
      child: ListTile(
        leading: CircleAvatar(
          child: Text( band.name.substring(0,2) ),
          backgroundColor: Colors.blue[100],
          // child: Text( "$index"),
        ),
        title: Text( band.name),
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20),),
        onTap: () => socketServices.emit('emitir-votes', { 'id': band.id })
      ),
    );
  }
}