c:
	docker compose exec backend rails c

reset-db:
	docker compose exec backend rails db:drop db:create db:migrate db:seed

rebuild:
	docker compose up --build -d backend sidekiq

seed:
	docker compose exec backend rails db:seed

migrate:
	docker compose exec backend rails db:migrate

reset-test:
	rails db:environment:set RAILS_ENV=test db:drop db:create db:migrate