package wonderland.wonder.matcher.serialization;

import wonderland.wonder.matcher.domain.WonderSeeker;
import wonderland.wonder.matcher.domain.WonderSeekerLikeHistory;
import wonderland.wonder.matcher.domain.WonderSeekerMatchHistory;
import wonderland.wonder.matcher.event.DancePartnerSeekerHasLikedAnotherDancerEvent;
import wonderland.wonder.matcher.event.DancePartnerSeekerIsLikedByAnotherDancerEvent;
import wonderland.wonder.matcher.event.DancerIsLookingForPartnerUpdate;

public class CustomSerdes {

    public static final JsonSerde<WonderSeeker> WONDER_SEEKER_JSON_SERDE = new JsonSerde<>(WonderSeeker.class);
    public static final JsonSerde<WonderSeekerLikeHistory> WONDER_SEEKER_LIKE_HISTORY_JSON_SERDE = new JsonSerde<>(WonderSeekerLikeHistory.class);
    public static final JsonSerde<WonderSeekerMatchHistory> WONDER_SEEKER_MATCH_HISTORY_JSON_SERDE = new JsonSerde<>(WonderSeekerMatchHistory.class);
    public static final JsonSerde<DancerIsLookingForPartnerUpdate> DANCER_SEEKING_PARTNER_JSON_SERDE = new JsonSerde<>(DancerIsLookingForPartnerUpdate.class);
    public static final JsonSerde<DancePartnerSeekerHasLikedAnotherDancerEvent> LIKERS_EVENT_JSON_SERDE = new JsonSerde<>(DancePartnerSeekerHasLikedAnotherDancerEvent.class);
    public static final JsonSerde<DancePartnerSeekerIsLikedByAnotherDancerEvent> LIKEES_EVENT_JSON_SERDE = new JsonSerde<>(DancePartnerSeekerIsLikedByAnotherDancerEvent.class);

}
