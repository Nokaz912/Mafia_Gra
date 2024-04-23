package pl.mafia.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import pl.mafia.backend.models.db.Account;
import pl.mafia.backend.models.db.Room;
import pl.mafia.backend.models.db.Round;

import java.util.Optional;

public interface RoundRepository extends JpaRepository<Round, Long> {
}
