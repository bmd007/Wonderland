package wonderland.api.gateway.dto;

import javax.validation.constraints.NotBlank;

public record DancerIsLookingForPartnerEvent(
        @NotBlank String dancerName,
        Location location

) implements DancePartnerEvent {
    @Override
    public String dancerName() {
        return dancerName;
    }

    @Override
    public String key() {
        return dancerName();
    }
}
