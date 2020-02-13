import 'package:ac_mrp_workorder/blocs/fetch_data/fetch_data_state.dart';
import 'package:ac_mrp_workorder/models/navigate_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ac_mrp_workorder/blocs/fetch_data/fetch_data_bloc.dart';
import '../blocs/authentication/authentication_bloc.dart';

class WorkOrderScreen extends StatefulWidget {
  State<WorkOrderScreen> createState() => _WorkOrderScreen();
}

class _WorkOrderScreen extends State<WorkOrderScreen> {

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
          return StreamBuilder<dynamic>(
            stream: state.readAll(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
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
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 500.0,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 2.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container(
                          alignment: Alignment.center,
                          color: Colors.grey,
                          child: CircularProgressIndicator(),
                        );
                      },
                      childCount: 1,
                    ),
                  )
                ]);
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
                            maxCrossAxisExtent: 500.0,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                            childAspectRatio: 2.0,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return GestureDetector(
                                child: Container(
                                  margin: EdgeInsets.all(10.0),
                                  padding: EdgeInsets.all(10.0),
                                  key: Key(
                                      snapshot.data.datas[index].id.toString()),
                                  alignment: Alignment.center,
                                  color: snapshot.data.datas[index].stateColor,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data.datas[index].name,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20
                                            ),
                                          ),
                                          Text(
                                            snapshot.data.datas[index].manufacturingOrderName,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/workOrderItem',
                                    arguments: WorkOrderArgument(
                                      id: snapshot.data.datas[index].id,
                                      name: snapshot.data.datas[index].name,
                                      activeMoveLineIds: snapshot.data.datas[index].activeMoveLineIds
                                    )
                                  );
                                },
                              );
                            },
                            // childCount: snapshot.data.length,
                            childCount: snapshot.data.datas.length,
                          ),
                        )
                      ]);
                    }
                    break;
                  default:
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
                                maxCrossAxisExtent: 500.0,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0,
                                childAspectRatio: 2.0,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Container(
                                alignment: Alignment.center,
                                color: Colors.grey,
                                child: CircularProgressIndicator(),
                              );
                            },
                            childCount: 1,
                          ),
                        )
                      ]);
                    }
                }
              }
            },
          );
        } else {
          return Container(
            child: Text('Loading ...'),
          );
        }
      },
    );

    return Scaffold(
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
