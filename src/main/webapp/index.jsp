<%@ page contentType="text/html;charset=UTF-8"%> 
<% 
String urlBase = "wss://" + request.getServerName() + ":" + request.getServerPort();
System.out.println("URLBase: " + urlBase); 
%>

<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Logs en Tiempo Real</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="icon" href="icono-logs.png" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/brands.min.css" integrity="sha512-58P9Hy7II0YeXLv+iFiLCv1rtLW47xmiRpC1oFafeKNShp8V5bKV/ciVtYqbk2YfxXQMt58DjNfkXFOn62xE+g==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/fontawesome.min.css" integrity="sha512-v8QQ0YQ3H4K6Ic3PJkym91KoeNT5S3PnDKvqnwqFD1oiqIl653crGZplPdU5KKtHjO0QKcQ2aUlQZYjHczkmGw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/regular.min.css" integrity="sha512-8hM9a+2hrLBhOuB3uiy+QIXBsu6Qk+snsP1CboFQW6pdt/yYz0IcDp/+CGv5m39r9doGUc/zw6aBpyLF6XFgzg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/solid.min.css" integrity="sha512-DzC7h7+bDlpXPDQsX/0fShhf1dLxXlHuhPBkBo/5wJWRoTU6YL7moeiNoej6q3wh5ti78C57Tu1JwTNlcgHSjg==" crossorigin="anonymous" referrerpolicy="no-referrer" />

  </head>
  <body
    class="bg-gray-900 text-white flex flex-col items-center justify-center min-h-screen p-4"
  >
    <div
      class="bg-gray-800 rounded-lg shadow-lg p-6 overflow-auto w-full h-[80dvh]"
      style="
        resize: both;
        min-width: 300px;
        min-height: 200px;
        max-width: 1860px;
        max-height: 1000px;
      "
    >
      <h1 class="text-2xl font-bold text-center mb-4">Logs en Tiempo Real</h1>


      <div class="flex items-center gap-3 mb-4 flex-wrap">
            <input id="search-logs" class="w-1/2 p-2 border border-gray-600 rounded-lg bg-gray-700 text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" type="text" placeholder="Buscar en logs..." />
            <i id="prevBtn" class="fa-solid fa-arrow-up cursor-pointer"></i>
            <i id="nextBtn" class="fa-solid fa-arrow-down cursor-pointer"></i>
            <span class="text-gray-500">
            <span id="searchIndex">0</span>
            <span> of </span>
            <span id="searchLenght">0</span>
            </span>
      </div>

      <div class="flex items-center gap-3 mb-4 flex-wrap">
        <button
          id="connectBtn"
          class="bg-green-500 hover:bg-green-600 text-white px-4 py-2 rounded-lg"
        >
          Conectar
        </button>
        <button
          id="copyBtn"
          class="bg-orange-500 hover:bg-purple-600 text-white px-4 py-2 rounded-lg"
        >
          Copiar
        </button>

        <button
          id="donwnloadBtn"
          class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-lg"
        >
          Descargar
        </button>

        <button 
        id="pauseStartBtn"
        class="bg-yellow-500 hover:bg-yellow-600 text-white px-4 py-2 rounded-lg"
        >
          Pausar
        </button>

        <input
          id="token-logs"
          class="w-1/2 p-2 border border-gray-600 rounded-lg bg-gray-700 text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          type="text"
          placeholder="Ingresa tu token aquí..."
        />

        <button
          id="clearBtn"
          class="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg"
        >
          Limpiar
        </button>
      </div>
      <div
        id="logContainer"
        class="h-96 overflow-auto bg-black p-4 rounded-lg text-green-400 font-mono border border-gray-700 lg:h-[80%]"
      >
        <p class="text-gray-500">Esperando conexión...</p>
      </div>
    </div>

    <div class="flex items-center justify-center m-5">
      Hecho por Jhoan Hernández
    </div>

    <script>
      const logContainer = document.getElementById("logContainer");
      const connectBtn = document.getElementById("connectBtn");
      const copyBtn = document.getElementById("copyBtn");
      const clearBtn = document.getElementById("clearBtn");
      const tokenInput = document.getElementById("token-logs");
      const searchInput = document.getElementById("search-logs");
      const nextBtn = document.getElementById("nextBtn");
      const prevBtn = document.getElementById("prevBtn");
      const indexContainer = document.getElementById("searchIndex");
      const lengthContainer = document.getElementById("searchLenght");
      const donwnloadBtn = document.getElementById("donwnloadBtn");
      const pauseStartBtn = document.getElementById("pauseStartBtn");

      let searchTimeout;
      let searchResults = [];
      let currentIndex = -1;
      let socket;
      let paused = false;

      

        function searchLogs() {
            const query = searchInput.value.trim().toLowerCase();
            searchResults = [];
            currentIndex = -1;
            
            document.querySelectorAll("#logContainer p").forEach((log, index) => {
                log.classList.remove("bg-yellow-500", "text-black");
                if (query && log.textContent.toLowerCase().includes(query)) {
                    searchResults.push({ element: log, index });
                }
            });
            
            if (searchResults.length > 0) {
                currentIndex = 0;
                highlightCurrent();
            }

            updateIndex();

        }
        
        function highlightCurrent() {
            if (searchResults.length > 0) {
                logContainer.scrollTop = searchResults[currentIndex].element.offsetTop - logContainer.offsetTop;
                searchResults.forEach(log => log.element.classList.remove("bg-yellow-500", "text-black"));
                searchResults[currentIndex].element.classList.add("bg-yellow-500", "text-black");
            }
        }

        function updateIndex() {
            if(indexContainer && searchResults.length > 0) {
                indexContainer.textContent = currentIndex + 1;
            }

            if(lengthContainer && searchResults) {
                lengthContainer.textContent = searchResults.length;
            }

            if(searchResults.length === 0) {
                indexContainer.textContent = 0;
                lengthContainer.textContent = 0;
            }

            if(searchInput.value === "") {
                indexContainer.textContent = 0;
                lengthContainer.textContent = 0;
            }
        }


        function saveFile(nombre, contenido) {
          const blob = new Blob([contenido], { type: "text/plain" }); 
          const url = URL.createObjectURL(blob);

          const a = document.createElement("a");
          a.href = url;
          a.download = nombre; 
          document.body.appendChild(a);
          a.click();
          document.body.removeChild(a);
          URL.revokeObjectURL(url); 
        }


        function loadToken() {
        const token = localStorage.getItem("token-logs");
        if (token) {
          tokenInput.value = token;
        }
      }


    

      copyBtn.addEventListener("click", () => {
        const textToCopy = logContainer.innerText.trim();

        if (!textToCopy) {
          Swal.fire({
            icon: "warning",
            title: "Nada para copiar",
            text: "El log está vacío.",
            confirmButtonColor: "#3085d6",
          });
          return;
        }

      navigator.clipboard
          .writeText(textToCopy)
          .then(() => {
            Swal.fire({
              icon: "success",
              title: "Logs copiados",
              text: "El contenido ha sido copiado al portapapeles.",
              confirmButtonColor: "#3085d6",
            });
          })
          .catch((err) => {
            console.error("Error al copiar:", err);
            Swal.fire({
              icon: "error",
              title: "Error",
              text: "No se pudo copiar el contenido.",
              confirmButtonColor: "#d33",
            });
          });
      });

      connectBtn.addEventListener("click", () => {
        const token = tokenInput.value.trim();

        if (!token) {
          Swal.fire({
            icon: "warning",
            title: "Token requerido",
            text: "Por favor, ingresa un token antes de conectarte.",
            confirmButtonColor: "#3085d6",
          });
          return;
        }

        if (socket && socket.readyState === WebSocket.OPEN) {
          socket.close();
          connectBtn.textContent = "Conectar";
          return;
        }

        const url = '<%= urlBase %>';

        socket = new WebSocket( url+`/logs-service/logs?token=` + encodeURIComponent(token));

        socket.onopen = () => {
          logContainer.innerHTML =
            "<p class='text-blue-400'>Conectado al servidor de logs...</p>";
          connectBtn.textContent = "Desconectar";
          localStorage.setItem("token-logs", token);
        };


        socket.onmessage = (event) => {
          const logLine = document.createElement("p");
          logLine.textContent = event.data;

          if(paused){
            return;
          }

          logContainer.appendChild(logLine);
       
          if(!searchInput.value){
            logContainer.scrollTop = logContainer.scrollHeight;
          }

          clearTimeout(searchTimeout);
          searchTimeout = setTimeout(() => {
            searchLogs();
          }, 300); 
        };


        socket.onclose = (event) => {
          logContainer.innerHTML +=
            "<p class='text-red-400'>Conexión cerrada.</p>";
          connectBtn.textContent = "Conectar";

          if (event.code === 1008) {
            Swal.fire({
              icon: "error",
              title: "Error de conexión",
              text: "No se pudo conectar al servidor. Verifica tu token.",
              confirmButtonColor: "#d33",
            });
          }
        };

        socket.onerror = () => {
          Swal.fire({
            icon: "error",
            title: "Error",
            text: "Hubo un problema con la conexión WebSocket.",
            confirmButtonColor: "#d33",
          });
        };
      });




      clearBtn.addEventListener("click", () => {
        logContainer.innerHTML = "";
      });


      nextBtn.addEventListener("click", () => {
          if (searchResults.length > 0) {
              currentIndex = (currentIndex + 1) % searchResults.length;
              highlightCurrent();
              updateIndex();

          }
      });
      
      prevBtn.addEventListener("click", () => {
          if (searchResults.length > 0) {
              currentIndex = (currentIndex - 1 + searchResults.length) % searchResults.length;
              highlightCurrent();
              updateIndex();

          }
      });

      donwnloadBtn.addEventListener("click", () => {
          const textToDownload = logContainer.innerText.trim();
          const fileName = "logs.out";

          if (!textToDownload) {
              Swal.fire({
                  icon: "warning",
                  title: "Nada para descargar",
                  text: "El log está vacío.",
                  confirmButtonColor: "#3085d6",
              });
              return;
          }

          saveFile(fileName, textToDownload);

          Swal.fire({
              icon: "success",
              title: "Logs descargados",
              text: "El archivo se ha descargado correctamente.",
              confirmButtonColor: "#3085d6",
          });
      });

      pauseStartBtn.addEventListener("click", () => {
          paused = !paused;
          pauseStartBtn.textContent = paused ? "Reanudar" : "Pausar";
      });


      //LOADING EVENTS
      loadToken();
      searchInput.addEventListener("input", searchLogs);





    </script>
  </body>
</html>
