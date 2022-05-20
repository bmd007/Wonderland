package statefull.geofencing.faas.location.aggregate;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.kafka.test.context.EmbeddedKafka;
import org.springframework.test.annotation.DirtiesContext;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import statefull.geofencing.faas.common.repository.MoverJdbcRepository;
import statefull.geofencing.faas.location.aggregate.config.Stores;
import statefull.geofencing.faas.location.aggregate.util.KafkaStreamsAwait;

import static java.util.concurrent.TimeUnit.SECONDS;
import static org.awaitility.Awaitility.await;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

@ExtendWith(SpringExtension.class)
@SpringBootTest
@ActiveProfiles("test")
@EmbeddedKafka(partitions = 1, topics = {
        "mover-position-updates",
        Stores.MOVER_IN_MEMORY_STATE_STORE + "-" + "stateful-geofencing-faas-changelog",
        "event_log"
})
@DirtiesContext
@Disabled("Test works locally however fails in Jenkins.")
// The reason of failure is:
// StreamsException: Could not lock global state directory. This could happen if multiple KafkaStreams instances are running on the same host using the same state directory.
class StreamsIntegrationTest {

    @Autowired
    KafkaStreamsAwait await;

    @Autowired
    MoverJdbcRepository repository;

    @Autowired
    UpdateProducer producer;

    @BeforeEach
    void setUp() throws Exception {
        await.await();
    }

    @Test
    void test() throws Exception {
        var empty = repository.getAll();
        assertTrue(empty.isEmpty());
        for (var i = 0; i < 100; i++) {
            producer.producePositionUpdate(String.format("ABC%03d", i), 10.1, 20.2);
        }
        await().atMost(100, SECONDS).until(() -> repository.count() > 0);
        var all = repository.getAll();
        assertFalse(all.isEmpty());
        all.forEach(v -> Assertions.assertEquals(10.1, v.getLastLocation().getLatitude()));
        all.forEach(v -> Assertions.assertEquals(20.2, v.getLastLocation().getLongitude()));
    }

}
