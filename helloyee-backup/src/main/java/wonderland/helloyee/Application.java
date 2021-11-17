package wonderland.helloyee;

import com.jayway.jsonpath.JsonPath;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.net.InetAddress;
import java.util.List;
import java.util.Random;

@SpringBootApplication
public class Application implements CommandLineRunner {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    private static final Logger LOGGER = LoggerFactory.getLogger(Application.class);

    @Autowired
    @Qualifier("loadBalancedClient")
    WebClient.Builder loadBalancedWebClientBuilder;

    @Autowired
    @Qualifier("notLoadBalancedClient")
    WebClient.Builder notLoadBalancedWebClientBuilder;

    @Override
    public void run(String... args) throws Exception {
        InetAddress inetAddress = InetAddress.getLocalHost();
        System.out.println("IP Address:- " + inetAddress.getHostAddress());
        System.out.println("Host Name:- " + inetAddress.getHostName());

        safeSleep(80000);
        people.stream().forEach(this::requestQueueFor);
        for (int i = 0; i < 3000; i++) {
            safeSleep(1000);
            var from = aRandomPerson();
            var to = aRandomPerson();
            advice().subscribe(text -> {
                LOGGER.info("Sending {} from {} to {}", text, from, to);
                sendMessage(from, to, text);
            });
        }
    }

    private void safeSleep(int time) {
        try {
            Thread.sleep(time);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    List<String> people = List.of("Mahdi", "Rabia", "Chintal", "Set", "Bjorn", "Adeel", "Johan", "Felix");

    private String aRandomPerson() {
        int nextIndex = Math.abs(new Random().nextInt()) % people.size();
        return people.get(nextIndex);
    }

    private Mono<String> advice() {
        return notLoadBalancedWebClientBuilder.build()
                .get()
                .uri("https://api.adviceslip.com/advice")
                .retrieve()
                .bodyToMono(String.class)
                .map(JsonPath::parse)
                .map(documentContext -> documentContext.read("$.slip.advice"))
                .map(String::valueOf)
                .doOnError(throwable -> LOGGER.error("error:{} from NOT load balanced client", throwable.getMessage()));
    }

    private void requestQueueFor(String email) {
        LOGGER.info("requesting creation of queue with name {}", email);
        loadBalancedWebClientBuilder.build()
                .post()
                .uri("http://messenger/create/queue/for/" + email)
                .retrieve()
                .bodyToMono(String.class)
                .retry(Long.MAX_VALUE)
                .doOnError(throwable -> LOGGER.error("error:{} from load balanced client", throwable.getMessage()))
                .subscribe(s -> System.out.println("Answer got by loadBalancedClient from messenger : " + s));
    }

    private void sendMessage(String from, String to, String message) {
        loadBalancedWebClientBuilder.build()
                .post()
                .uri("http://messenger/send/message/" + from + "/" + to)
                .bodyValue(message)
                .retrieve()
                .bodyToMono(String.class)
                .retry(Long.MAX_VALUE)
                .doOnError(throwable -> LOGGER.error("error:{} from load balanced client", throwable.getMessage()))
                .subscribe(s -> System.out.println("Answer got by loadBalancedClient from messenger : " + s));
    }
}
