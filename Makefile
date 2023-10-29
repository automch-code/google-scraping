start:
	cp frontend/environments/development frontend/.env
	docker compose up -d

stop:
	docker compose down

restart:
	make stop
	make start

rebuild:
	docker compose up --build -d backend sidekiq

migrate:
	docker compose exec backend rails db:migrate

reset-db:
	docker compose exec backend rails db:drop db:create db:migrate db:seed