# Documentación técnica de Dinerop

Basada en `src/main/java`, `src/main/resources`, `pom.xml`, `schema.sql` y el snapshot Graphify `graphify-out/`. El grafo indica commit `39c30a4f`, coincidente con HEAD al documentar. Ante discrepancias prevalece el código.

- [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md): stack y alcance.
- [ARCHITECTURE.md](ARCHITECTURE.md): capas y dependencias.
- [MODULES.md](MODULES.md): dominios principales.
- [DATABASE.md](DATABASE.md): entidades y persistencia.
- [API_ENDPOINTS.md](API_ENDPOINTS.md): rutas desde controladores.
- [AUTHENTICATION.md](AUTHENTICATION.md): JWT y autorización.
- [BUSINESS_LOGIC.md](BUSINESS_LOGIC.md): flujos principales.
- [DEVELOPMENT_GUIDE.md](DEVELOPMENT_GUIDE.md): trabajo local.

El grafo es un índice derivado. Verificar siempre en el código vigente y no copiar secretos ni valores de entorno a documentación.
