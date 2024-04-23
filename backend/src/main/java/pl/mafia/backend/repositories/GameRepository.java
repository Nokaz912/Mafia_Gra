package pl.mafia.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import pl.mafia.backend.models.db.Account;
import pl.mafia.backend.models.db.Game;
import pl.mafia.backend.models.db.Room;

import java.util.Optional;

public interface GameRepository extends JpaRepository<Game, Long> {
}
