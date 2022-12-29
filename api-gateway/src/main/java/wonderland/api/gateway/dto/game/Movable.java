package wonderland.api.gateway.dto.game;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class Movable {
    private String id;
    private double positionX;
    private double positionY;
    private double velocityX;
    private double velocityY;
    private double angel;
}
