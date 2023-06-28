# Inicia o docker
docker:
	sudo docker compose up

# Necessario quando precisar rodar algum comando no servidor
bash:
	sudo docker exec -it projeto-de-extensao-web-1 /bin/bash

# Faz o build do docker
build:
	sudo docker compose build

# Abre o rails c
rails:
	sudo docker exec -it projeto-de-extensao-web-1 /bin/bash -c "rails c"