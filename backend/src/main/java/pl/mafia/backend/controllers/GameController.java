package pl.mafia.backend.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pl.mafia.backend.models.dto.AccountDetails;
import pl.mafia.backend.models.dto.RoomDTO;
import pl.mafia.backend.services.GameService;

@RestController
@RequestMapping("/game")
public class GameController {
    @Autowired
    private GameService gameService;

    @PostMapping("/start/{roomId}")
    public ResponseEntity<?> startGame(@PathVariable Long roomId, @AuthenticationPrincipal AccountDetails accountDetails) {
        try {
            String username = accountDetails.getUsername();
            long gameId = gameService.startGame(username, roomId);
            long roundId = gameService.startRound(gameId);
            gameService.createVoting(roundId);
            return ResponseEntity.noContent().build();
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
        } catch (IllegalAccessException ex) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ex.getMessage());
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(ex.getMessage());
        }
    }

    @PostMapping("/end/{gameId}")
    public ResponseEntity<?> endGame(@PathVariable Long gameId, @AuthenticationPrincipal AccountDetails accountDetails) {
        try {
            gameService.endGame(gameId);
            return ResponseEntity.noContent().build();
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(ex.getMessage());
        }
    }
}
