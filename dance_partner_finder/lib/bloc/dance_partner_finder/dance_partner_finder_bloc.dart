import 'package:bloc/bloc.dart';
import 'package:dance_partner_finder/client/api_gateway_rsocket_client.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

part 'dance_partner_finder_event.dart';
part 'dance_partner_finder_state.dart';


Future<LocationData> getLocation() async {
  Location location = Location();

  if (!await location.serviceEnabled() && !await location.requestService()) {
    return Future.error(Error());
  }
  if (await location.hasPermission() == PermissionStatus.denied &&
      await location.requestPermission() != PermissionStatus.granted) {
    return Future.error(Error());
  }
  return await location.getLocation();
}

class DancePartnerBloc extends Bloc<DancePartnerEvent, DancePartnerState> {

  final ApiGatewayRSocketClient client = ApiGatewayRSocketClient();

  DancePartnerBloc() : super(DancePartnerState.empty()) {
    on<ThisDancerChoseNameEvent>((event, emit) {
      emit(state.withThisDancerName(event.thisDancerName));

      getLocation()
      .asStream()
      .doOnData((location) => client.addName(state.thisDancerName, location.latitude!, location.longitude! ))
      .asyncExpand((location) => client.fetchNames(state.thisDancerName, location.latitude!, location.longitude!))
      .forEach((potentialDancePartner) => add(PotentialDancerPartnerFoundEvent(potentialDancePartner!)));
    });
    on<DancersLoadedEvent>((event, emit) {
      emit(state.loaded(event.loadedDancerNames));
    });
    on<PotentialDancerPartnerFoundEvent>((event, emit) {
      emit(state.addPotentialDancer(event.potentialDancePartnerName));
    });
    on<DancerLikedEvent>((event, emit) {
      client.likeADancer(state.thisDancerName, event.dancerName);
      emit(state.moveToNextDancer());
    });
    on<DancerDislikedEvent>((event, emit) {
      client.disLikeADancer(state.thisDancerName, event.dancerName);
      emit(state.moveToNextDancer());
    });
  }
}
