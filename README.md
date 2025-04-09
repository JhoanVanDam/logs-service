# 📄 Logs Service

**Logs Service** is a lightweight web application for viewing a Tomcat server's `catalina.out` file in real time, using WebSockets. Its design minimizes the impact on server performance, allowing administrators and developers to access logs without requiring access to the operating system.

---

## 🚀 Features

- 🔥 Real-time streaming of the `catalina.out` file
- 🔐 Token authentication using WebSocket
- ​​🧠 Efficient synchronization without blocking server processes
- 📦 Simple integration with Tomcat

---

## 🛠️ Installation

### 1. Configure the context in Tomcat's `server.xml`

Add the following block inside the `<Host>` in the `conf/server.xml` file:

```xml
<!-- HOME CONTEXT SERVICE LOGS JH -->
<Context path="/logs-service" docBase="${catalina.home}/webapps/logs-service" reloadable="true"/>
<!-- END CONTEXT SERVICE LOGS JH -->
```
The following shows an overview of how the system in action:

![image](https://github.com/user-attachments/assets/0866c5ce-e9e3-4e30-9b50-bbd457850971)


![image](https://github.com/user-attachments/assets/422052fd-f575-498b-ba3e-afb4db036320)
