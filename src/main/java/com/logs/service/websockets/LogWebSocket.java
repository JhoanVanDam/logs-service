package com.logs.service.websockets;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.charset.StandardCharsets;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;

@ServerEndpoint("/logs")
public class LogWebSocket {
    private static final String TOMCAT_PATH = System.getProperty("catalina.base", System.getProperty("catalina.home"));
    private static final String LOG_FILE = TOMCAT_PATH + File.separator + "logs" + File.separator + "catalina.out";
    private static final Set<Session> sessions = new CopyOnWriteArraySet<>();
    private static volatile boolean running = true;

    private static String TOKEN_KEY;

    static {
        initTokenKey();
        startLogWatcher();
    }

    @OnOpen
    public void onOpen(Session session) {
        String query = session.getQueryString();
        String token = getTokenFromQuery(query);

        if (token == null || !token.equals(TOKEN_KEY)) {
            try {
                System.out.println("Acceso denegado");
                session.close(new CloseReason(CloseReason.CloseCodes.VIOLATED_POLICY, "Acceso denegado"));

            } catch (IOException ignored) {
            }
            return;
        }

        sessions.add(session);
        System.out.println("Cliente autorizado conectado: " + session.getId());
    }


    @OnClose
    public void onClose(Session session) {
        sessions.remove(session);
        System.out.println("Cliente desconectado: " + session.getId());
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("Error en WebSocket: " + throwable.getMessage());
    }

    private static void startLogWatcher() {
        File logFile = new File(LOG_FILE);
        if (!logFile.exists() || !logFile.canRead()) {
            System.err.println("❌ ERROR: No se puede leer el archivo de logs: " + LOG_FILE);
            return;
        }

        new Thread(() -> {
            try (RandomAccessFile file = new RandomAccessFile(logFile, "r")) {
                file.seek(file.length());

                while (running) {
                    String line = file.readLine();
                    if (line != null) {
                        broadcast(new String(line.getBytes(StandardCharsets.ISO_8859_1), StandardCharsets.UTF_8));
                    } else {
                        Thread.sleep(1000);
                    }
                }
            } catch (Exception e) {
                System.err.println("❌ Error leyendo logs: " + e.getMessage());
                e.printStackTrace();
            }
        }).start();
    }

    private static void broadcast(String message) {
        for (Session session : sessions) {
            try {
                session.getBasicRemote().sendText(message);
            } catch (Exception ignored) {
            }
        }
    }

    public static void stopLogWatcher() {
        running = false;
    }

    public static void initTokenKey() {

        try {
            InitialContext context = new InitialContext();

            TOKEN_KEY = (String) context.lookup("java:comp/env/token-service-logs");


        } catch (NamingException e) {
            e.printStackTrace();
            TOKEN_KEY = "bearer xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
        }
    }

    private String getTokenFromQuery(String query) {
        if (query == null) return null;

        for (String param : query.split("&")) {
            String[] pair = param.split("=");
            if (pair.length == 2 && "token".equals(pair[0])) {
                return pair[1];
            }
        }
        return null;
    }


}
