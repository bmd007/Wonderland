import 'package:dance_partner_finder/bloc/dance_partner_match/dance_partner_match_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/dance_partner_match/dance_partner_match_state.dart';

class DancePartnerMatchesWidget extends StatelessWidget {
  final String thisDancerName;

  const DancePartnerMatchesWidget({super.key, required this.thisDancerName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DancePartnerMatchBloc(thisDancerName),
      child: BlocBuilder<DancePartnerMatchBloc, DancePartnerMatchState>(
        builder: (context, state) {
          return state.isLoading
              ? Image.asset('images/wait.png')
              : ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  children: state.matchedDancerNames
                      .map((name) => DancePartnerMatchWidget(dancerName: name))
                      .toList());
        },
      ),
    );
  }
}

class DancePartnerMatchWidget extends StatelessWidget {
  final String dancerName;

  const DancePartnerMatchWidget({super.key, required this.dancerName});

  TextStyle? _getTextStyle(bool newMessageAvailable) {
    if (newMessageAvailable) {
      return const TextStyle(
        color: Colors.redAccent,
        decoration: TextDecoration.underline,
      );
    }
    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onLongPress: () {},
        onTap: () {},
        leading: CircleAvatar(
            backgroundImage: AssetImage('images/${dancerName}.png')),
        title: Text(dancerName, style: _getTextStyle(true)),
      ),
    );
  }
}

