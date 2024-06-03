import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:olly_chat/screens/discover/components/writers_container.dart';

class WriterList extends StatelessWidget {
  const WriterList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyUserBloc, MyUserState>(
      builder: (context, state) {
        if(state.status == MyUserStatus.success){
          print(state.users?.last.name);
        return SizedBox(
          height: MediaQuery.of(context).size.height / 2 - 260,
          child: ListView.builder(
            cacheExtent: 1000,
            scrollDirection: Axis.horizontal,
            itemCount: state.users?.length,
            itemBuilder: (context, index) {
              return const WritersContainer();
            },
          ),
        );}
        
         else{
          return Text("data");
        }
      },
    );
  }
}
