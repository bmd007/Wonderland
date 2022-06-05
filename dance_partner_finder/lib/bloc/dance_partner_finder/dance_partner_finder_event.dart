part of 'dance_partner_finder_bloc.dart';

abstract class DancePartnerEvent extends Equatable {
  const DancePartnerEvent();
}

class DancerLikedEvent extends DancePartnerEvent {
  final String dancerName;

  const DancerLikedEvent(this.dancerName);

  @override
  List<Object?> get props => [dancerName];
}

class DancerDislikedEvent extends DancePartnerEvent {
  final String dancerName;

  const DancerDislikedEvent(this.dancerName);

  @override
  List<Object?> get props => [dancerName];
}

class ThisDancerChoseNameEvent extends DancePartnerEvent {
  final String thisDancerName;

  const ThisDancerChoseNameEvent(this.thisDancerName);

  @override
  List<Object?> get props => [thisDancerName];
}

class DancersLoadedEvent extends DancePartnerEvent {
  final List<String> loadedDancerNames;

  const DancersLoadedEvent(this.loadedDancerNames);

  @override
  List<Object?> get props => [loadedDancerNames];
}

class PotentialDancerPartnerFoundEvent extends DancePartnerEvent {
  final String potentialDancePartnerName;

  const PotentialDancerPartnerFoundEvent(this.potentialDancePartnerName);

  @override
  List<Object?> get props => [potentialDancePartnerName];
}
