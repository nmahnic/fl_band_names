import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class StatusScreen extends StatelessWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final socketServices = Provider.of<SocketServices>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Server Status: ${socketServices.serverStatus}'),
            // Text('Server Payload: ${socketServices.serverPayload}')
          ]
        ),
     ),
     floatingActionButton: FloatingActionButton(
       child: const Icon( Icons.message),
       onPressed: (){
        print('press floatingButton');
        socketServices.emit('emitir-mensaje', {
          'user': 'Nico', 
          'mensaje': 'Hola mundo!'
        });
       },
     ),
   );
  }
}