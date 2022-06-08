package wonderland.wonder.matcher.event;

import javax.validation.constraints.NotBlank;

public record DancePartnerSeekerIsLikedByAnotherDancerEvent(@NotBlank String liker, @NotBlank String likee) implements Event {

    @Override
    public String key() {
        return likee;
    }
}
