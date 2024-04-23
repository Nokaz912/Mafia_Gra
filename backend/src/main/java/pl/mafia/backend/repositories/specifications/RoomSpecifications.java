package pl.mafia.backend.repositories.specifications;

import jakarta.persistence.criteria.Join;
import org.springframework.data.jpa.domain.Specification;
import pl.mafia.backend.models.db.Room;
import pl.mafia.backend.models.db.RoomSettings;

public class RoomSpecifications {
    public static Specification<Room> isRoomPublic() {
        return (root, query, criteriaBuilder) -> {
            Join<Room, RoomSettings> roomSettingsJoin = root.join("roomSettings");
            return criteriaBuilder.equal(roomSettingsJoin.get("isPublic"), true);
        };
    }
}