package pl.mafia.backend.models.db;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "Room")
@Data
public class Room {
    @Id
    @ToString.Exclude
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "room_sequence")
    @SequenceGenerator(name = "room_sequence", sequenceName = "ROOM_SEQ", allocationSize = 1)
    private Long id;

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_host")
    private Account host;

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_game", unique = true)
    private Game game;

    @Column(name = "access_code", nullable = false)
    private String accessCode;

    @OneToOne(mappedBy = "room", fetch = FetchType.LAZY)
    private RoomSettings roomSettings;

    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @OneToMany(mappedBy = "room", fetch = FetchType.LAZY)
    private List<Account> accounts = new ArrayList<>();
}
