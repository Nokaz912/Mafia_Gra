package pl.mafia.backend.models.db;

import jakarta.persistence.*;
import lombok.Data;
import lombok.ToString;

@Entity
@Table(name = "RoomSettings")
@Data
public class RoomSettings {
    @Id
    @ToString.Exclude
    private Long id;

    @OneToOne
    @JoinColumn(name = "id")
    @MapsId
    private Room room;

    @Column(name = "is_public", nullable = false)
    private boolean isPublic;

    @Column(name = "number_of_players", nullable = false)
    private int numberOfPlayers;
}