# Projet OpenAPI - Gestion des groupes d'utilisateurs

Ce repository contient un projet **Node.js** basé sur **OpenAPI 3** pour définir un contrat d'interface de gestion des groupes d'utilisateurs, puis générer une base d'API **Spring Boot**.

Le contrat couvre les endpoints suivants :
- `GET /api/v1/user-groups`
- `POST /api/v1/user-groups`
- `GET /api/v1/user-groups/{groupId}`
- `PATCH /api/v1/user-groups/{groupId}`
- `DELETE /api/v1/user-groups/{groupId}`

---

## 1) Structure du projet

```text
.
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

Les schémas sont classés par domaine fonctionnel (`user-groups`) et par type (`requests`, `responses`).

---

## 2) Prérequis

- Node.js 18+
- npm 9+
- Docker + Docker Compose

---

## 3) Installation

```bash
npm install
```

---

## 4) Validation et bundling du contrat OpenAPI

Le projet utilise `swagger-cli` pour valider et produire un fichier unique dans `dist/`.

### Valider la spec
```bash
npm run lint
```

### Générer le YAML consolidé
```bash
npm run bundle
```

### Générer la version JSON consolidée
```bash
npm run bundle:json
```

---

## 5) Visualiser le Swagger en HTML sur localhost

### Option A — rendu HTML local via Node.js (commande demandée)
```bash
npm run docs:serve
```

Puis ouvrir :
- `http://localhost:8080/openapi.yaml`

> Cette commande sert le contrat bundle. Vous pouvez ensuite le charger dans Swagger Editor/UI.

### Option B — rendu Swagger UI via Docker
1. Bundle du contrat :
```bash
npm run bundle
```
2. Démarrage des conteneurs :
```bash
npm run docker:up
```

Puis ouvrir :
- **Swagger Editor** : `http://localhost:8080`
- **Swagger UI** : `http://localhost:8081`

Arrêt des conteneurs :
```bash
npm run docker:down
```

---

## 6) Générer un contrat Spring Boot (interfaces/controllers)

Exemple avec `openapi-generator-cli` via Docker :

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
- Le contrat/les interfaces Spring seront générés dans `generated/spring-contract`.

---

## 7) Workflow recommandé

1. Modifier la spec modulaire dans `openapi/`
2. Lancer `npm run lint`
3. Lancer `npm run bundle`
4. Visualiser dans Swagger Editor/UI
5. Générer les interfaces Spring Boot avec OpenAPI Generator

---

## 8) Scripts npm disponibles

- `npm run lint` : validation OpenAPI
- `npm run bundle` : bundle YAML dans `dist/openapi.yaml`
- `npm run bundle:json` : bundle JSON dans `dist/openapi.json`
- `npm run docs:serve` : serveur local sur le port 8080
- `npm run docker:up` : démarre Swagger Editor + Swagger UI
- `npm run docker:down` : arrête les conteneurs
- `npm run docker:logs` : suit les logs Docker

