package pl.mafia.backend.models.db;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "Game")
@Data
public class Game {
    @Id
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "game_sequence")
    @SequenceGenerator(name = "game_sequence", sequenceName = "GAME_SEQ", allocationSize = 1)
    private Long id;

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @OneToOne(mappedBy = "game", fetch = FetchType.LAZY)
    private Room room;

    @Column(nullable = false)
    private Timestamp createTimestamp;

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @ManyToMany(mappedBy = "games")
    private List<Account> accounts = new ArrayList<>();

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @OneToMany(mappedBy = "game")
    private List<Round> rounds = new ArrayList<>();
}
