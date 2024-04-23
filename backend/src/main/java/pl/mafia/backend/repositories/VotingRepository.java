package pl.mafia.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import pl.mafia.backend.models.db.Voting;

public interface VotingRepository extends JpaRepository<Voting, Long> {
}
