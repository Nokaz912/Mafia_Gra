package pl.mafia.backend.models.db;

import jakarta.persistence.*;
import lombok.Data;
import lombok.ToString;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "Reward")
@Data
public class Reward {
    @Id
    @ToString.Exclude
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "reward_sequence")
    @SequenceGenerator(name = "reward_sequence", sequenceName = "REWARD_SEQ", allocationSize = 1)
    private Long id;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false)
    private String acquiring_method;

    @ToString.Exclude
    @OneToMany(mappedBy = "reward")
    private List<Round> rounds = new ArrayList<>();
}
