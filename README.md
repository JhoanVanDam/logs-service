# 📄 Logs Service

**Logs Service** es una aplicación web ligera para visualizar el archivo `catalina.out` de un servidor Tomcat en tiempo real, utilizando WebSockets. Su diseño minimiza el impacto en el rendimiento del servidor, permitiendo a administradores y desarrolladores acceder a los logs sin necesidad de acceso al sistema operativo.

---

## 🚀 Características

- 🔥 Transmisión en tiempo real del archivo `catalina.out`
- 🔐 Autenticación por token mediante WebSocket
- 🧠 Sincronización eficiente sin bloquear procesos del servidor
- 📦 Integración simple con Tomcat

---

## 🛠️ Instalación

### 1. Configura el contexto en `server.xml` de Tomcat

Agrega el siguiente bloque dentro del `<Host>` en el archivo `conf/server.xml`:

```xml
<!-- INICIO CONTEXTO SERVICE LOGS JH -->
<Context path="/logs-service" docBase="${catalina.home}/webapps/logs-service" reloadable="true"/>
<!-- FIN CONTEXTO SERVICE LOGS JH -->
