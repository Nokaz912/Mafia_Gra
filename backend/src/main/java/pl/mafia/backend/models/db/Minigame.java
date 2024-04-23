package pl.mafia.backend.models.db;

import jakarta.persistence.*;
import lombok.Data;
import lombok.ToString;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "Minigame")
@Data
public class Minigame {
    @Id
    @ToString.Exclude
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "minigame_sequence")
    @SequenceGenerator(name = "minigame_sequence", sequenceName = "MINIGAME_SEQ", allocationSize = 1)
    private Long id;

    @Column(nullable = false)
    private String title;

    @ToString.Exclude
    @OneToMany(mappedBy = "minigame")
    private List<RoundMiniGame> roundMiniGames = new ArrayList<>();
}
