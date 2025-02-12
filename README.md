# Vue App Template

This template is for a full-stack Vue app.

## Tech Stack

This template leverages the following tech stack:

- **Frontend**
    - _Framework:_ Vue
    - _State Management:_ Pinia
    - _Component Library:_ PrimeVue Components
    - _Styling:_ SASS
    - _Bundler:_ Vite
- **Backend**
    - _Runtime_: Bun
    - _Server_: Fastify
    - _ORM_: Prisma
- **Infrastructure**
    - _Containerization (Optional)_: Docker
    - _Monorepo_: Bun Workspaces

## Getting Started

Lots of the boilerplate has already been provided. You will need to do the following things in order to get this all set up:

1. Generate a repository off of this template.
2. Add `.npmrc` in order to download `@nickjmoss` packages.
3. Install all dependencies
    ```bash
    bun install
    ```
4. Replace all instances of `vue-app-template` with your app name.

## Important

If you are not running this within a Docker container, make sure to run your frontend dev server and your backend server in separate terminal instances. If you run them in the same terminal, then when you close the terminal, it will not kill the server process and your process will be hanging.
