start:
	cp frontend/environments/development frontend/.env
	docker compose up -d

stop:
	docker compose down

restart:
	make stop
	make start

rebuild:
	docker compose up --build -d backend

migrate:
	docker compose exec backend rails db:migrate