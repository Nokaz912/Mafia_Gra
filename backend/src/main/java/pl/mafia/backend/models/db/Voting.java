package pl.mafia.backend.models.db;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "Voting")
@Data
public class Voting {
    @Id
    @ToString.Exclude
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "voting_sequence")
    @SequenceGenerator(name = "voting_sequence", sequenceName = "VOTING_SEQ", allocationSize = 1)
    private Long id;

    @Column(nullable = false)
    private String type;

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_round", unique = true)
    private Round round;

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_account")
    private Account account;

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @OneToMany(mappedBy = "voting", fetch = FetchType.LAZY)
    private List<Vote> votes = new ArrayList<>();
}
