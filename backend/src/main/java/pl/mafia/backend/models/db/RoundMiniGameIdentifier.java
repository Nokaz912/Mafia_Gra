package pl.mafia.backend.models.db;

import lombok.Data;
import lombok.ToString;

@Data
public class RoundMiniGameIdentifier {
    @ToString.Exclude
    private Round round;

    @ToString.Exclude
    private Minigame minigame;

    public RoundMiniGameIdentifier(Round round, Minigame minigame) {
        this.round = round;
        this.minigame = minigame;
    }
}
