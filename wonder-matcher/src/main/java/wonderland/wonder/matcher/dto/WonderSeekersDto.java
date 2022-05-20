package wonderland.wonder.matcher.dto;

import java.util.List;

public record WonderSeekersDto(List<WonderSeekerDto> results) {
    public static WonderSeekersDto empty() {
        return new WonderSeekersDto(List.of());
    }
}
