package pl.mafia.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import pl.mafia.backend.models.db.RoomSettings;

public interface RoomSettingsRepository extends JpaRepository<RoomSettings, Long> {
}
