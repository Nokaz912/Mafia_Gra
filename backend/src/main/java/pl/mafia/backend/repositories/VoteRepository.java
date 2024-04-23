package pl.mafia.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import pl.mafia.backend.models.db.Vote;

public interface VoteRepository extends JpaRepository<Vote, Long> {
}
