package pl.mafia.backend.models.dto;

import lombok.Data;
import lombok.NonNull;
import pl.mafia.backend.models.db.Room;
import pl.mafia.backend.models.db.RoomSettings;

@Data
public class RoomSettingsDTO {
    @NonNull private Boolean isPublic;
    @NonNull private Integer numberOfPlayers;

    public RoomSettingsDTO(RoomSettings roomSettings) {
        this.isPublic = roomSettings.isPublic();
        this.numberOfPlayers = roomSettings.getNumberOfPlayers();
    }
}
