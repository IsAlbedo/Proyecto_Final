import 'package:flutter/material.dart';
import 'package:artesana/models/cliente_model.dart';
import 'package:artesana/pages/clientes/cliente_item.dart';
import 'package:artesana/services/api_cliente.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class ClientesList extends StatefulWidget {
  const ClientesList({Key? key}) : super(key: key);

  @override
  _ClientesListState createState() => _ClientesListState();
}

class _ClientesListState extends State<ClientesList> {
  bool isApiCallProcess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ProgressHUD(
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
        key: UniqueKey(),
        child: loadClientes(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-cliente');
        },
        child: Icon(Icons.person_add),
        backgroundColor: Colors.amber,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget loadClientes() {
    return FutureBuilder(
      future: APICliente.getClientes(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<ClienteModel>?> model,
      ) {
        if (model.hasData) {
          return clienteList(model.data);
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget clienteList(List<ClienteModel>? clientes) {
    if (clientes == null || clientes.isEmpty) {
      return Center(
        child: Text('No hay clientes disponibles'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: clientes.length,
            itemBuilder: (context, index) {
              return ClienteItem(
                model: clientes[index],
                onDelete: (ClienteModel model) {
                  setState(() {
                    isApiCallProcess = true;
                  });

                  APICliente.deleteCliente(model.id).then(
                    (response) {
                      setState(() {
                        isApiCallProcess = false;
                        // Actualiza la lista de clientes eliminando el cliente borrado
                        clientes.removeAt(index);
                      });
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}




