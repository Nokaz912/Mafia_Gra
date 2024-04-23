package pl.mafia.backend.websockets;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.SimpAttributesContextHolder;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.user.SimpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.*;
import pl.mafia.backend.models.dto.AccountDetails;
import pl.mafia.backend.services.RoomService;

import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
public class WebSocketListener {
    @Autowired
    private RoomService roomService;

    private final Map<Long, List<String>> activeSubscriptions;

    private Long getRoomId(String destination) throws NumberFormatException {
        String[] destinationParts = destination.split("/");
        return Long.valueOf(destinationParts[2]);
    }

    public WebSocketListener() {
        activeSubscriptions = new HashMap<>();
    }

    @EventListener
    public void handleConnectEvent(SessionConnectEvent event) {
        System.out.println("New connection: " + SimpAttributesContextHolder.currentAttributes().getSessionId());
    }

    @EventListener
    public void handleConnectedEvent(SessionConnectedEvent event) {
        System.out.println("Conntected: " + SimpAttributesContextHolder.currentAttributes().getSessionId());
    }

    @EventListener
    public void handleDisconnectEvent(SessionDisconnectEvent event) {
        if(event.getUser() == null) return;

        try {
            roomService.leaveRoom(event.getUser().getName());
            System.out.println("Disconnected: " + SimpAttributesContextHolder.currentAttributes().getSessionId());
        } catch(Exception ex) {
            ex.printStackTrace();
        }
    }

    @EventListener
    public void handleSubscribeEvent(SessionSubscribeEvent event) {
        if(event.getUser() == null) return;

        String destination = (String)event.getMessage().getHeaders().get("simpDestination");
        if(destination == null) return;

        try {
            Long roomId = getRoomId(destination);
            if(!activeSubscriptions.containsKey(roomId)) activeSubscriptions.put(roomId, new ArrayList<>());
            if(activeSubscriptions.get(roomId).contains(event.getUser().getName())) return;
            activeSubscriptions.get(roomId).add(event.getUser().getName());

            System.out.println("Subscribed: " + roomId);
        } catch(Exception ex) {
            ex.printStackTrace();
        }
    }

    @EventListener
    public void handleUnsubscribeEvent(SessionUnsubscribeEvent event) {
        if(event.getUser() == null) return;

        String destination = (String)event.getMessage().getHeaders().get("simpDestination");
        if(destination == null) return;

        try {
            Long roomId = getRoomId(destination);
            if(!activeSubscriptions.containsKey(roomId)) return;
            if(!activeSubscriptions.get(roomId).contains(event.getUser().getName())) return;

            activeSubscriptions.get(roomId).remove(event.getUser().getName());
            if(activeSubscriptions.get(roomId).size() == 0) activeSubscriptions.remove(roomId);

            System.out.println("Unsubscribed: " + roomId);
        } catch(Exception ex) {
            ex.printStackTrace();
        }
    }

    public List<String> getSubscriptions(Long roomId) {
        if(!activeSubscriptions.containsKey(roomId)) return new ArrayList<>();
        return activeSubscriptions.get(roomId);
    }
}
