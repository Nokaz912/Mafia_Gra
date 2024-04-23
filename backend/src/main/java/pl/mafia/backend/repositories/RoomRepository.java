package pl.mafia.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import pl.mafia.backend.models.db.Account;
import pl.mafia.backend.models.db.Room;

import java.util.List;
import java.util.Optional;

public interface RoomRepository extends JpaRepository<Room, Long>, JpaSpecificationExecutor<Room> {
    Optional<Room> findByHost(Account host);
    Optional<Room> findByAccessCode(String accessCode);
    Optional<Room> findByGameId(Long gameId);
}
