start:
	cp frontend/environments/development frontend/.env
	cd frontend/ && pnpm install && cd -
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

link_email:
	docker logs google-scraping-backend | grep 'http://localhost:3000/redirect'