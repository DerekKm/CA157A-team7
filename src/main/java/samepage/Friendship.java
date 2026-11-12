package samepage;

import java.sql.Timestamp;

public class Friendship {

    private int requesterId;
    private int addresseeId;
    private String status;
    private String username;
    private Timestamp requestedAt;
    private Timestamp respondedAt;

    public int getRequesterId() {
        return requesterId;
    }

    public void setRequesterId(int requesterId) {
        this.requesterId = requesterId;
    }

    public int getAddresseeId() {
        return addresseeId;
    }

    public void setAddresseeId(int addresseeId) {
        this.addresseeId = addresseeId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getUsername() {
        return username;
    }
    public void setUsername(String username) {
        this.username = username;
    }

    public Timestamp getRequestedAt() {
        return requestedAt;
    }

    public void setRequestedAt(Timestamp requestedAt) {
        this.requestedAt = requestedAt;
    }

    public Timestamp getRespondedAt() {
        return respondedAt;
    }

    public void setRespondedAt(Timestamp respondedAt) {
        this.respondedAt = respondedAt;
    }
}