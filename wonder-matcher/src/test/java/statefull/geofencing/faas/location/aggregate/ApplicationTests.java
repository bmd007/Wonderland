package statefull.geofencing.faas.location.aggregate;


import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.kafka.test.context.EmbeddedKafka;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import statefull.geofencing.faas.location.aggregate.config.Stores;

@ExtendWith(SpringExtension.class)
@SpringBootTest
@ActiveProfiles("test")
@EmbeddedKafka(partitions = 1, topics = {
        "mover-position-updates",
//todo?!        "${spring.application.name}"+"-changelog-"+Stores.MOVER_IN_MEMORY_STATE_STORE
        Stores.MOVER_IN_MEMORY_STATE_STORE + "-" + "stateful-geofencing-faas-changelog",
        "event_log"
})
public class ApplicationTests {

    @Test
    public void contextLoads() {
    }

}
