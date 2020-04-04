DROP TABLE books;
DROP TABLE pubishers;

CREATE TABLE publishers (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) not null,
  active BOOLEAN
);

CREATE TABLE books (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255),
  publisher_id INT REFERENCES publishers(id),
  cost_price FLOAT,
  selling_price FLOAT,
  stock_level INT
);