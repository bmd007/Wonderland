package wonderland.webauthn.webauthnserver.dto;

import lombok.Value;

@Value
public class StartAuthenticationActions {
    String finish = "https://wonderland.wonder/register/finish";
}
