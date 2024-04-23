package pl.mafia.backend.models.db;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "Account")
@Data
public class Account {
    @Id
    @Column(unique = true, nullable = false)
    private String username;

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @Column(nullable = false)
    private String password;

    @Column(unique = true, nullable = false)
    private String email;

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_room")
    private Room room;

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "GameAccount", joinColumns = @JoinColumn(name = "id_account"), inverseJoinColumns = @JoinColumn(name = "id_game"))
    private List<Game> games = new ArrayList<>();

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @OneToMany(mappedBy = "account", fetch = FetchType.LAZY)
    private List<RoundMiniGame> roundMiniGames = new ArrayList<>();

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @OneToMany(mappedBy = "account", fetch = FetchType.LAZY)
    private List<Voting> votings = new ArrayList<>();

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @OneToMany(mappedBy = "voter", fetch = FetchType.LAZY)
    private List<Vote> votesAsVoter = new ArrayList<>();

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @OneToMany(mappedBy = "voted", fetch = FetchType.LAZY)
    private List<Vote> votesAsVoted = new ArrayList<>();
}
