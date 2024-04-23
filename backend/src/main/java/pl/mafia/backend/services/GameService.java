package pl.mafia.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import pl.mafia.backend.models.db.*;
import pl.mafia.backend.models.dto.RoundDTO;
import pl.mafia.backend.repositories.*;
import pl.mafia.backend.websockets.WebSocketListener;
import pl.mafia.backend.models.dto.GameStartDTO;

import java.sql.Timestamp;
import java.time.Instant;
import java.util.Objects;
import java.util.Optional;
import java.util.Random;

@Component
public class GameService {
    @Autowired
    private AccountRepository accountRepository;
    @Autowired
    private RoomRepository roomRepository;
    @Autowired
    private GameRepository gameRepository;
    @Autowired
    private RoundRepository roundRepository;
    @Autowired
    private VotingRepository votingRepository;
    @Autowired
    private WebSocketListener webSocketListener;
    @Autowired
    private SimpMessagingTemplate simpMessagingTemplate;

    private String getRandomRole() {
        String[] roles = new String[]{"citizen", "mafia"};
        return roles[new Random().nextInt(roles.length)];
    }

    @Transactional
    public long startGame(String username, Long roomId) throws IllegalAccessException {
        Optional<Room> fetchedRoom = roomRepository.findById(roomId);
        if (fetchedRoom.isEmpty())
            throw new IllegalArgumentException("Room does not exists.");

        Optional<Account> fetchedAccount = accountRepository.findByUsername(username);
        if (fetchedAccount.isEmpty())
            throw new IllegalAccessException("Account does not exists.");

        Room room = fetchedRoom.get();

        if(!Objects.equals(room.getHost().getUsername(), username))
            throw new IllegalAccessException("Account is not a host");

        Game createdGame = new Game();
        createdGame.setCreateTimestamp(Timestamp.from(Instant.now()));
        for(Account account : room.getAccounts()) createdGame.getAccounts().add(account);
        createdGame.setRoom(room);
        createdGame = gameRepository.save(createdGame);

        room.setGame(createdGame);
        roomRepository.save(room);

        String destination = "/queue/game-start";
        for(String user : webSocketListener.getSubscriptions(roomId)) {
            GameStartDTO gameStartDTO = new GameStartDTO(
                    createdGame.getId(),
                    getRandomRole()
            );
            simpMessagingTemplate.convertAndSendToUser(user, destination, gameStartDTO);
        }

        return createdGame.getId();
    }

    @Transactional
    public void endGame(Long gameId) {

        Optional<Game> fetchedGame = gameRepository.findById(gameId);
        if (fetchedGame.isEmpty())
            throw new IllegalArgumentException("Game does not exist.");

        Game game = fetchedGame.get();

        Optional<Room> fetchedRoom = roomRepository.findByGameId(gameId);
        if (fetchedRoom.isEmpty())
            throw new IllegalArgumentException("Room does not exist.");

        Room room = fetchedRoom.get();

        room.setGame(null);
        roomRepository.save(room);
    }

    @Transactional
    public long startRound(Long gameId) throws IllegalAccessException {
        Optional<Game> fetchedGame = gameRepository.findById(gameId);
        if (fetchedGame.isEmpty())
            throw new IllegalAccessException("Game does not exist.");

        Game game = fetchedGame.get();

        Round createdRound = new Round();
        createdRound.setGame(game);
        createdRound = roundRepository.save(createdRound);

        game.getRounds().add(createdRound);
        gameRepository.save(game);

        return createdRound.getId();
    }

    @Transactional
    public void createVoting(Long roundId) throws IllegalAccessException
    {
        Optional<Round> fetchedRound = roundRepository.findById(roundId);
        if (fetchedRound.isEmpty())
            throw new IllegalAccessException("Round does not exist.");

        Round round = fetchedRound.get();

        Voting createdVoting = new Voting();
        createdVoting.setType("city");
        createdVoting.setRound(round);
        round.setVoting(createdVoting);

        createdVoting = votingRepository.save(createdVoting);
        round = roundRepository.save(round);

        Room room = round.getGame().getRoom();
        simpMessagingTemplate.convertAndSend("/topic/" + room.getId() + "/round-start", new RoundDTO(round));
    }
}
