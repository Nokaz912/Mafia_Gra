package pl.mafia.backend.models.db;

import jakarta.persistence.*;
import lombok.Data;
import lombok.ToString;

@Entity
@IdClass(RoundMiniGameIdentifier.class)
@Table(name = "RoundMiniGame")
@Data
public class RoundMiniGame {
    @Id
    @ToString.Exclude
    @ManyToOne
    @JoinColumn(name = "id_round")
    private Round round;

    @Id
    @ToString.Exclude
    @ManyToOne
    @JoinColumn(name = "id_minigame")
    private Minigame minigame;

    @ToString.Exclude
    @ManyToOne
    @JoinColumn(name = "id_account")
    private Account account;
}
