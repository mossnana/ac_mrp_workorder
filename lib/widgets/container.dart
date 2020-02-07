import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ac_mrp_workorder/blocs/fetch_data/fetch_data_bloc.dart';
import 'package:ac_mrp_workorder/blocs/fetch_data/fetch_data_state.dart';

class ContainerX extends StatefulWidget {
  @override
  State<ContainerX> createState() => _ContainerX();
}

class _ContainerX extends State<ContainerX> {

  @override
  Widget build(BuildContext context) {

    Widget _Container = BlocBuilder<FetchUserBloc, FetchDataState>(
      bloc: BlocProvider.of<FetchUserBloc>(context),
      builder: (context, state) {
        if(state is FetchUserSuccess) {
          return Container(
              child: StreamBuilder(
                stream: state.info(),
                builder: (context, snapshot) {
                  if(snapshot.hasError) {
                    return Text('SnapShot Error');
                  } else if(snapshot.hasData) {
                    return Text(snapshot.data['name']);
                  } else {
                    return Text("Loading ... in Stream Builder");
                  }
                },
              )
          );
        } else if(state is FetchUserFailed) {
          return Container(
              child: Text('Failed')
          );
        } else {
          return Container(
              child: Text('Loading ...')
          );
        }
      },
    );

    return _Container;
  }
}
