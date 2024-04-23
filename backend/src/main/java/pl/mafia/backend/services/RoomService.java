package pl.mafia.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.user.SimpUser;
import org.springframework.messaging.simp.user.SimpUserRegistry;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import pl.mafia.backend.models.db.Account;
import pl.mafia.backend.models.db.Room;
import pl.mafia.backend.models.dto.RoomDTO;
import pl.mafia.backend.repositories.AccountRepository;
import pl.mafia.backend.models.db.RoomSettings;
import pl.mafia.backend.repositories.RoomRepository;
import pl.mafia.backend.repositories.RoomSettingsRepository;

import java.util.List;
import java.util.Optional;

import static pl.mafia.backend.repositories.specifications.RoomSpecifications.isRoomPublic;

@Component
public class RoomService {
    @Autowired
    private AccountRepository accountRepository;
    @Autowired
    private RoomRepository roomRepository;
    @Autowired
    private RoomSettingsRepository roomSettingsRepository;
    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    public List<RoomDTO> getPublicRooms() {
        return roomRepository.findAll(isRoomPublic())
                .stream()
                .map(RoomDTO::new)
                .toList();
    }

    @Transactional
    public RoomDTO joinRoomByAccessCode(String accessCode, String username) throws IllegalAccessException {
        Optional<Room> fetchedRoom = roomRepository.findByAccessCode(accessCode);
        if (fetchedRoom.isEmpty())
            throw new IllegalArgumentException("Room does not exists.");

        Optional<Account> fetchedAccount = accountRepository.findByUsername(username);
        if (fetchedAccount.isEmpty())
            throw new IllegalAccessException("Account does not exists.");

        Account updatedAccount = fetchedAccount.get();
        Room updatedRoom = fetchedRoom.get();

        updatedAccount.setRoom(updatedRoom);
        updatedRoom.getAccounts().add(updatedAccount);
        accountRepository.save(updatedAccount);
        updatedRoom = roomRepository.save(updatedRoom);

        return new RoomDTO(updatedRoom);
    }

    @Transactional
    public RoomDTO joinRoomById(Long id, String username) throws IllegalAccessException {
        Optional<Room> fetchedRoom = roomRepository.findById(id);
        if (fetchedRoom.isEmpty())
            throw new IllegalArgumentException("Room does not exists.");

        Optional<Account> fetchedAccount = accountRepository.findByUsername(username);
        if (fetchedAccount.isEmpty())
            throw new IllegalAccessException("Account does not exists.");

        Account updatedAccount = fetchedAccount.get();
        Room updatedRoom = fetchedRoom.get();

        updatedAccount.setRoom(updatedRoom);
        updatedRoom.getAccounts().add(updatedAccount);
        accountRepository.save(updatedAccount);
        updatedRoom = roomRepository.save(updatedRoom);

        return new RoomDTO(updatedRoom);
    }

    @Transactional
    public void leaveRoom(String username) throws IllegalAccessException {
        Optional<Account> fetchedAccount = accountRepository.findByUsername(username);
        if(fetchedAccount.isEmpty())
            throw new IllegalAccessException("Account does not exists.");

        Account updatedAccount = fetchedAccount.get();
        if(updatedAccount.getRoom() == null)
            throw new IllegalAccessException("Account is not in any room.");

        Room room = updatedAccount.getRoom();
        if(room.getAccounts().size() == 1) {
            updatedAccount.setRoom(null);
            roomSettingsRepository.delete(room.getRoomSettings());
            roomRepository.delete(room);
            accountRepository.save(updatedAccount);
            return;
        }

        updatedAccount.setRoom(null);
        room.getAccounts().remove(updatedAccount);
        if(room.getHost().equals(updatedAccount)) {
            room.setHost(room.getAccounts().get(0));
        }
        roomRepository.save(room);
        accountRepository.save(updatedAccount);

        RoomDTO roomDTO = new RoomDTO(room);
        messagingTemplate.convertAndSend("/topic/" + roomDTO.getId() + "/room", roomDTO);
    }

    @Transactional
    public RoomDTO createRoom(String hostUsername) {
        Optional<Account> host = accountRepository.findByUsername(hostUsername);
        if(host.isEmpty())
            throw new IllegalArgumentException("Account doesn't exists.");

        Optional<Room> roomByHost = roomRepository.findByHost(host.get());
        if (roomByHost.isPresent())
            throw new IllegalArgumentException("Room already exists.");

        Room createdRoom = new Room();
        Account updatedHost = host.get();

        createdRoom.setHost(host.get());
        createdRoom.getAccounts().add(host.get());
        createdRoom.setAccessCode("");

        RoomSettings createdRoomSettings = new RoomSettings();
        createdRoomSettings.setRoom(createdRoom);
        createdRoomSettings.setPublic(true);
        createdRoomSettings.setNumberOfPlayers(10);
        createdRoomSettings = roomSettingsRepository.save(createdRoomSettings);

        createdRoom.setRoomSettings(createdRoomSettings);
        createdRoom = roomRepository.save(createdRoom);

        updatedHost.setRoom(createdRoom);
        accountRepository.save(updatedHost);

        int codeLength = 7;
        String base26String = Long.toString(createdRoom.getId(), 26).toUpperCase();
        base26String = String.format("%" + codeLength + "s", base26String).replace(' ', '0');
        base26String = base26String.substring(Math.max(0, base26String.length() - codeLength));

        createdRoom.setAccessCode(base26String);
        createdRoom = roomRepository.save(createdRoom);

        return new RoomDTO(createdRoom);
    }

    @Transactional
    public RoomDTO updateProperties(RoomSettings roomSettings, Long roomId) {
        Optional<Room> room = roomRepository.findById(roomId);

        if (room.isEmpty())
            throw new IllegalArgumentException("Room does not exists.");

        Room updatedRoom = room.get();
        updatedRoom.setRoomSettings(roomSettings);

        return new RoomDTO(roomRepository.save(updatedRoom));
    }
}
