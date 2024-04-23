package pl.mafia.backend.models.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NonNull;
import pl.mafia.backend.models.db.Account;
import pl.mafia.backend.models.db.Room;

import java.util.List;

@Data
public class RoomDTO {
    @NonNull private Long id;
    @NonNull private List<String> accountUsernames;
    @NonNull private String hostUsername;
    @NonNull private String accessCode;
    @NonNull private RoomSettingsDTO roomSettings;

    public RoomDTO(Room room) {
        this.id = room.getId();
        this.accountUsernames = room.getAccounts()
                .stream()
                .map(Account::getUsername)
                .toList();
        this.hostUsername = room.getHost().getUsername();
        this.accessCode = room.getAccessCode();
        this.roomSettings = new RoomSettingsDTO(room.getRoomSettings());
    }
}