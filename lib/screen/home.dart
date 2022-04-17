import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Queen', votes: 1),
    Band(id: '3', name: 'Bon Jovi', votes: 5),
    Band(id: '4', name: 'Heroes del Silencio', votes: 2)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: const Text(' Band Names', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: ( _ , index)  =>
          Dismissible(
            key: UniqueKey(),
            background: const _BackgroundDeleteBand(),
            direction: DismissDirection.startToEnd,
            onDismissed: ( direction ) {
              print('direction: $direction, id:${bands[index].id}, name:${bands[index].name}');
              setState(() => bands.removeAt(index) );
              //TODO: llamar el borrado en el server
            },
            child: _BandTile(band: bands[index],)
          )
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon( Icons.add ),
        onPressed: _addNewBand,
        ),
   );
  }

  _addNewBand(){

    final textController = TextEditingController();

    if( Platform.isAndroid ){
      return showDialog( 
        context: context,
        builder: (context) {
          return AlertDialog(
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
          );
        }
      );
    }else{
      showCupertinoDialog(
        context: context, 
        builder: (context) {
          return CupertinoAlertDialog(
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
          );
        }
      );
    }
  }

  _addBandToList(String text){
    print(text);
    if( text.length > 1 ){
      setState(() => bands.add( Band(id: DateTime.now().toString(), name: text, votes: 5) ));
      //TODO: send to server
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
    required this.band
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      onDismissed: ( direction ) {
        print('direction: $direction, id:${band.id}, name:${band.name}');
        //TODO: llamar el borrado en el server
      },
      child: ListTile(
        leading: CircleAvatar(
          child: Text( band.name.substring(0,2) ),
          backgroundColor: Colors.blue[100],
          // child: Text( "$index"),
        ),
        title: Text( band.name),
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20),),
      ),
    );
  }
}