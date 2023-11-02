**Google-Scraping** 💻 

- requirements
  - ruby version 
    - 3.2.2
  - node version 
    - 18.16.0
  - make command
    - ubuntu
      - (https://linuxhint.com/install-make-ubuntu/)
    - mac
      - ```brew install make```
  - docker
    - installation (https://docs.docker.com/engine/install/#desktop)
---

how to start project ?
  1. to start project run
    - ```make start```
    this command will start up all services in docker-compose.yml
  2. reset the database first to generate user
    - ```make reset-db```
    with this step you will get (admin_user, user)
    I add an admin_user for user management in the future...
  3. from previous step, you'll get 2 users
    - ```email: admin@example.com password: password```
    - ```email: user@example.com password: password```
    - or **sign_up** by yourself
  4. **sign_in** and enjoy kub !! 😁

---

Make command
- start project
  - ```make start```
- stop project
  - ```make stop```
- restart project
  - ```make restart```
- rebuild project
  - ```make rebuild```
- to reset database to first state (2 users, without keywords)
  - ```make reset-db```

---

I make some csv for you to upload too
- `./test.csv`

---
