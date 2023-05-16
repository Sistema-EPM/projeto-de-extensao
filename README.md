# Container básico para Rails 7.

* Ruby 3
* Rails 7
* Postgres
* Docker
* Docker Compose

Iniciando a aplicação

* Clone o repositório;
* Realize a build do container: `sudo docker compose build`;
* Inicialize o container: `sudo docker compose up`;
* Abra o bash da aplicação: `docker exec -it projeto-de-extensao-web-1 /bin/bash`;
* Crie o banco de dados: `rails db:create`;
* Abra a aplicação na web: `localhost:3000`.
