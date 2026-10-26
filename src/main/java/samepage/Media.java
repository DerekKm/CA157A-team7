package samepage;

public class Media {

    private int mediaId;
    private String title;
    private String mediaType;
    private String creator;
    private String series;
    private String description;
    private String releaseYear;
    private String coverImageUrl;
    private int totalSeasons;

    public Media() {
    }

    public Media(int mediaId, String title, String mediaType,
                 String creator, String series, String description,
                 String releaseYear, String coverImageUrl,
                 int totalSeasons) {

        this.mediaId = mediaId;
        this.title = title;
        this.mediaType = mediaType;
        this.creator = creator;
        this.series = series;
        this.description = description;
        this.releaseYear = releaseYear;
        this.coverImageUrl = coverImageUrl;
        this.totalSeasons = totalSeasons;
    }

    public int getMediaId() {
        return mediaId;
    }

    public void setMediaId(int mediaId) {
        this.mediaId = mediaId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMediaType() {
        return mediaType;
    }

    public void setMediaType(String mediaType) {
        this.mediaType = mediaType;
    }

    public String getCreator() {
        return creator;
    }

    public void setCreator(String creator) {
        this.creator = creator;
    }

    public String getSeries() {
        return series;
    }

    public void setSeries(String series) {
        this.series = series;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getReleaseYear() {
        return releaseYear;
    }

    public void setReleaseYear(String releaseYear) {
        this.releaseYear = releaseYear;
    }

    public String getCoverImageUrl() {
        return coverImageUrl;
    }

    public void setCoverImageUrl(String coverImageUrl) {
        this.coverImageUrl = coverImageUrl;
    }

    public int getTotalSeasons() {
        return totalSeasons;
    }

    public void setTotalSeasons(int totalSeasons) {
        this.totalSeasons = totalSeasons;
    }
}