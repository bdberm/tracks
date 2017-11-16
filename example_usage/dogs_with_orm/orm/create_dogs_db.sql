CREATE TABLE dogs (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  breed_id INTEGER NOT NULL,
  owner_id INTEGER NOT NULL,

  FOREIGN KEY(breed_id) REFERENCES breed(id),
  FOREIGN KEY(owner_id) REFERENCES owner(id)
);

CREATE TABLE owners (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE breeds (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

INSERT INTO
  dogs (id, name, breed_id, owner_id)
VALUES
  (1, "Billie", 1, 1),
  (2, "Alfred", 2, 1),
  (3, "Harvey", 8, 2),
  (4, "Betsy", 6, 3),
  (5, "Freya", 13, 4),
  (6, "Max", 14, 5),
  (7, "Teller", 15, 5),
  (8, "Toni", 20, 6);


INSERT INTO
  breeds (id, name)
VALUES
  (1, "Corgi"),
  (2, "Basset Hound"),
  (3, "Dachshund"),
  (4, "English Bulldog"),
  (5, "French Bulldog"),
  (6, "Huskey"),
  (7, "Poodle"),
  (8, "Beagle"),
  (9, "German Shepher"),
  (10, "Labrador Retriever"),
  (11, "Rottweiler"),
  (12, "Golden Retriever"),
  (13, "Great Dane"),
  (14, "Boxer"),
  (15, "Pug"),
  (16, "Chow Chow"),
  (17, "Vizsla"),
  (18, "Greyhound"),
  (19, "Shih Tzu"),
  (20, "Yorkshire Terrier");


INSERT INTO
  owners (id, name)
VALUES
  (1, "Mike"),
  (2, "Will"),
  (3, "Eleven"),
  (4, "Lucas"),
  (5, "Dustin"),
  (6, "Neil"),
  (7, "Jonathan"),
  (8, "Nancy"),
  (9, "Steve"),
  (10, "Joyce");
