package wonderland.authentication.event.internal;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;

public class CounterRestartedEvent implements Event {

    private String sender;

    @JsonCreator
    public CounterRestartedEvent(@JsonProperty("sender") String sender) {
        this.sender = sender;
    }

    public String getSender() {
        return sender;
    }

    public void setSender(String sender) {
        this.sender = sender;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        CounterRestartedEvent that = (CounterRestartedEvent) o;
        return Objects.equal(sender, that.sender);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(sender);
    }

    @Override
    public String toString() {
        return MoreObjects.toStringHelper(this)
                .add("sender", sender)
                .toString();
    }

    @Override
    public String getKey() {
        return sender;
    }
}
