-- all the sql programming for record

CREATE DATABASE cocktail_master;

CREATE TABLE drinks (
  id SERIAL PRIMARY KEY,
  idDrink VARCHAR(255),
  creater_id INTEGER,
  strDrink VARCHAR(255),
  strAlcoholic VARCHAR(255),
  strGlass VARCHAR(255),
  strInstructions VARCHAR(1000),
  strDrinkThumb VARCHAR(1000),
  strIngr1 VARCHAR(255),
  strIngr2 VARCHAR(255),
  strIngr3 VARCHAR(255),
  strIngr4 VARCHAR(255),
  strIngr5 VARCHAR(255),
  strIngr6 VARCHAR(255),
  strIngr7 VARCHAR(255),
  strIngr8 VARCHAR(255),
  strIngr9 VARCHAR(255),
  strIngr10 VARCHAR(255),
  strMeas1 VARCHAR(255),
  strMeas2 VARCHAR(255),
  strMeas3 VARCHAR(255),
  strMeas4 VARCHAR(255),
  strMeas5 VARCHAR(255),
  strMeas6 VARCHAR(255),
  strMeas7 VARCHAR(255),
  strMeas8 VARCHAR(255),
  strMeas9 VARCHAR(255),
  strMeas10 VARCHAR(255),
  dateModified VARCHAR(255),
  FOREIGN KEY (creater_id) REFERENCES users(id) ON DELETE RESTRICT
);

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  nickname VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password_digest VARCHAR(400)
);

-- reserved as a bonus part
-- CREATE TABLE comments (
--   id SERIAL PRIMARY KEY,
--   body VARCHAR(1000) NOT NULL,
--   user_id INTEGER NOT NULL,
--   drink_id INTEGER NOT NULL,
--   FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
--   FOREIGN KEY (drink_id) REFERENCES mydrinks(id) ON DELETE RESTRICT
-- );

CREATE TABLE mydrinks (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  drink_id INTEGER NOT NULL,
  note_body VARCHAR(1000) NOT NULL,
  rating INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
  FOREIGN KEY (drink_id) REFERENCES drinks(id) ON DELETE RESTRICT
);