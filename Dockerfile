# ==============================================================================
# Dockerfile - Alternativa B: Aplicación Contenerizada con SWI-Prolog Oficial
# Proyecto: PetMatch - Sistema Experto para la Elección y Adopción de Mascotas
# ==============================================================================
FROM swipl:stable

WORKDIR /app

# Copiar base de conocimientos y servidor HTTP Prolog
COPY prolog/ ./prolog/

# Copiar interfaz gráfica web
COPY frontend/ ./frontend/

# Copiar batería de casos de prueba documentados
COPY tests/ ./tests/

# Puerto configurable por plataforma de despliegue (Render, Railway, Fly.io)
ENV PORT=8080
EXPOSE 8080

# Comando de inicio del servidor HTTP nativo de SWI-Prolog
CMD ["swipl", "-s", "prolog/server.pl", "-g", "iniciar_servidor"]
