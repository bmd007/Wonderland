package wonderland.webauthn.webauthnserver.dto;

import lombok.Value;

@Value
public class StartRegistrationActions {
    String finish = "http://localhost:9568/register/finish";
}