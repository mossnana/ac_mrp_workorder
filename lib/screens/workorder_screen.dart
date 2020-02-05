import 'package:ac_mrp_workorder/blocs/fetch_data/fetch_data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ac_mrp_workorder/blocs/fetch_data/fetch_data_bloc.dart';
import 'package:ac_mrp_workorder/blocs/fetch_data/fetch_data_event.dart';
import 'package:ac_mrp_workorder/screens/workorder_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:odoo_api/odoo_api_connector.dart';
import 'package:odoo_api/odoo_user_response.dart';
import '../blocs/authentication/authentication_bloc.dart';

class WorkOrderScreen extends StatefulWidget {
  State<WorkOrderScreen> createState() => _WorkOrderScreen();
}

class _WorkOrderScreen extends State<WorkOrderScreen> {
  var list = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    Widget _userInfo = BlocBuilder<FetchUserBloc, FetchDataState>(
      bloc: BlocProvider.of<FetchUserBloc>(context),
      builder: (context, state) {
        if (state is FetchUserSuccess) {
          return Container(
              child: StreamBuilder(
            stream: state.info(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('SnapShot Error');
              } else if (snapshot.hasData) {
                print(snapshot.data);
                return Text(snapshot.data['name']);
              } else {
                return Text("Loading ... in Stream Builder");
              }
            },
          ));
        } else {
          return Container(child: Text('#####'));
        }
      },
    );

    Widget _workOrders = BlocBuilder<FetchWorkOrderBloc, FetchDataState>(
      bloc: BlocProvider.of<FetchWorkOrderBloc>(context),
      builder: (context, state) {
        if (state is FetchWorkOrderSuccess) {
          return StreamBuilder(
            stream: state.readAll(),
            builder: (context, snapshot) {
              print(snapshot.connectionState);
              if (snapshot.hasError) {
                return Text('Error to fetching data from server');
              } else {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    {
                      return CustomScrollView(slivers: <Widget>[
                        SliverAppBar(
                          pinned: true,
                          expandedHeight: 150.0,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Image.network(
                                'http://naraipak.com/uploads/about/TKy31M7S05PEsStaPKamS1YjGVpCsZLt.png',
                                fit: BoxFit.cover),
                            title: Text('Work Orders'),
                          ),
                        ),
                        SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 300.0,
                            mainAxisSpacing: 20.0,
                            crossAxisSpacing: 20.0,
                            childAspectRatio: 1.0,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Container(
                                alignment: Alignment.center,
                                color: Colors.grey,
                                child: Text(snapshot.data[index]['name']),
                              );
                            },
                            childCount: snapshot.data.length,
                          ),
                        )
                      ]);
                    }
                    break;
                  default:
                    {
                      return Text('Loading ...');
                    }
                }
              }
            },
          );
        } else {
          return Text('Loading ...');
        }
      },
    );

    return Scaffold(
      /*body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: 150.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.network(
                'http://naraipak.com/uploads/about/TKy31M7S05PEsStaPKamS1YjGVpCsZLt.png',
                fit: BoxFit.cover),
            title: Text('Work Orders'),
          ),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300.0,
            mainAxisSpacing: 20.0,
            crossAxisSpacing: 20.0,
            childAspectRatio: 1.0,
          ),
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.teal[100 * (index % 9)],
                child: Text('Grid Item $index'),
              );
            },
            childCount: 10,
          ),
        )
      ]),*/
      body: _workOrders,
      drawer: Container(
        width: 300.0,
        color: Colors.purpleAccent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: deviceSize.height / 4.2,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      child: Image.network(
                        'http://naraipak.com/uploads/product/2Jmiq9Fh3r2c8xOsqGkPpBp8WTpU8TuV.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      child: _userInfo,
                    ),
//                    _workOrders
                  ],
                ),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(
                  Icons.cloud_done,
                  color: Colors.white,
                ),
                title: Text(
                  'Word Centers',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(
                  Icons.image,
                  color: Colors.white,
                ),
                title: Text(
                  'Work Orders',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.graphic_eq,
                  color: Colors.white,
                ),
                title: Text(
                  'Manufactoring Orders',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.graphic_eq,
                  color: Colors.white,
                ),
                title: Text(
                  'Log out',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
