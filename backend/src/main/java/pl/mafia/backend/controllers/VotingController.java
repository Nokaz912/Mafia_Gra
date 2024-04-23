package pl.mafia.backend.controllers;

import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import pl.mafia.backend.models.dto.AccountDetails;
import pl.mafia.backend.services.GameService;
import pl.mafia.backend.services.VotingService;

@RestController
@RequestMapping("/voting")
public class VotingController {
    @Autowired
    private SimpMessagingTemplate messagingTemplate;
    @Autowired
    private VotingService votingService;
    @Autowired
    private GameService gameService;

    @PostMapping("/{votingId}/vote")
    public ResponseEntity<?> saveVote(
            @PathVariable Long votingId,
            @AuthenticationPrincipal AccountDetails accountDetails,
            @RequestBody VoteRequest voteRequest
    ) {
        try {
            String voterUsername = accountDetails.getUsername();
            boolean lastVote = votingService.saveVote(votingId, voterUsername, voteRequest.votedUsername);
            if(lastVote)
                votingService.endVoting(votingId);
            return ResponseEntity.noContent().build();
        } catch(IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
        } catch(Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(ex.getMessage());
        }
    }

    @Data
    static class VoteRequest {
        private String votedUsername;
    }
}
