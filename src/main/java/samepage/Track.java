package samepage;

public class Track {

    private int mediaId;
    private int ownerId;

    private String title;
    private String mediaType;

    private String status;

    private int currentSeason;
    private int currentUnit;

    // getters/setters
    public int getMediaId(){return mediaId;}
    public void setMediaId(int inputId) {mediaId = inputId;}
    
    public int getOwnerId() {return ownerId;}
    public void setOwnerId(int inputId) {ownerId = inputId;}
    
    public String getTitle() {return title;}
    public void setTitle(String inputTitle) {title = inputTitle;}
    
    public String getMediaType() {return mediaType;}
    public void setMediaType(String inputType) { mediaType = inputType;}
    
    public String getStatus() {return status;}
    public void setStatus(String inputStatus) {status = inputStatus;}
    
    public int getCurrentSeason() {return currentSeason;}
    public void setCurrentSeason(int inputSeason) {currentSeason = inputSeason;}
    
    public int getCurrentUnit() {return currentUnit;}
    public void setCurrentUnit(int inputUnit) {currentUnit = inputUnit;}
}
