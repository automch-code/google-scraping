c:
	docker compose exec backend rails c

reset-db:
	docker compose exec backend rails db:drop db:create db:migrate db:seed

rebuild:
	docker compose up --build -d backend

seed:
	docker compose exec backend rails db:seed

migrate:
	docker compose exec backend rails db:migrate