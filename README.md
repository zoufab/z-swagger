# Projet OpenAPI - Gestion des groupes d'utilisateurs

Ce repository contient un projet **Node.js + OpenAPI 3** pour définir un contrat d'interface de gestion des groupes d'utilisateurs et générer un contrat backend **Spring Boot**.

> ✅ Le projet est désormais **dockerisé de bout en bout** : validation, bundling et visualisation se font via **Docker Compose** (pas besoin d'installer les dépendances Node.js en local).

---

## 1) Endpoints couverts

- `GET /api/v1/user-groups`
- `POST /api/v1/user-groups`
- `GET /api/v1/user-groups/{groupId}`
- `PATCH /api/v1/user-groups/{groupId}`
- `DELETE /api/v1/user-groups/{groupId}`

---

## 2) Structure du projet

```text
.
├── .dockerignore
├── Dockerfile
├── docker-compose.yml
├── openapi
│   ├── openapi.yaml
│   ├── paths
│   │   └── user-groups
│   │       ├── user-groups.collection.yaml
│   │       └── user-groups.item.yaml
│   └── schemas
│       ├── common
│       │   ├── error-response.yaml
│       │   └── pagination-metadata.yaml
│       └── user-groups
│           ├── requests
│           │   ├── create-user-group-request.yaml
│           │   └── patch-user-group-request.yaml
│           └── responses
│               ├── user-group-list-response.yaml
│               ├── user-group-response.yaml
│               └── user-group.yaml
├── package.json
└── dist
```

Les schémas sont classés par domaine (`user-groups`) et par type (`requests`, `responses`).

---

## 3) Prérequis

- Docker
- Docker Compose

---

## 4) Dockerisation du projet

### Services définis dans `docker-compose.yml`

1. **contract-builder**
   - Build via `Dockerfile`
   - Installe les dépendances Node.js dans l'image
   - Exécute :
     - validation OpenAPI (`npm run lint`)
     - bundling YAML (`npm run bundle`)

2. **swagger-ui**
   - Affiche la version HTML du contrat bundle (`dist/openapi.yaml`)
   - URL : `http://localhost:8081`

3. **swagger-editor**
   - Permet d'éditer la spec principale (`openapi/openapi.yaml`)
   - URL : `http://localhost:8080`

4. **docs-server**
   - Sert le dossier `dist` en HTTP
   - URL : `http://localhost:8082/openapi.yaml`

---

## 5) Commandes principales (via Docker Compose)

### Construire les images
```bash
npm run docker:build
```

### Générer/valider le contrat (lint + bundle)
```bash
npm run docker:bundle
```

### Lancer Swagger Editor + Swagger UI + serveur docs
```bash
npm run docker:up
```

### Arrêter les services
```bash
npm run docker:down
```

### Voir les logs
```bash
npm run docker:logs
```

---

## 6) Commande pour visualiser le Swagger en rendu HTML localhost

Commande recommandée :

```bash
npm run docker:up
```

Puis ouvrir :
- Swagger UI (rendu HTML): **http://localhost:8081**

---

## 7) Génération du contrat Spring Boot

Exemple avec OpenAPI Generator (Docker) :

```bash
docker run --rm \
  -v "${PWD}:/local" \
  openapitools/openapi-generator-cli:v7.7.0 generate \
  -i /local/dist/openapi.yaml \
  -g spring \
  -o /local/generated/spring-contract \
  --additional-properties=interfaceOnly=true,useSpringBoot3=true,delegatePattern=true
```

Résultat :
- Interfaces/contrat Spring Boot générés dans `generated/spring-contract`.

---

## 8) Workflow recommandé

1. Modifier la spec dans `openapi/`
2. Lancer `npm run docker:bundle`
3. Lancer `npm run docker:up`
4. Vérifier le rendu dans Swagger UI et Swagger Editor
5. Générer le contrat Spring Boot
