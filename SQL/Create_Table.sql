DROP TABLE IF EXISTS clients CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS commandes CASCADE;
DROP TABLE IF EXISTS produits CASCADE;
DROP TABLE IF EXISTS lignes_commandes CASCADE;

CREATE TABLE clients(
   id_client SERIAL PRIMARY KEY,
   client_nom VARCHAR(255) NOT NULL,
   client_prenom VARCHAR(255) NOT NULL,
   client_mail VARCHAR(255) NOT NULL UNIQUE,
   client_date_creation DATE NOT NULL
);

CREATE TABLE categories(
   id_categorie SERIAL PRIMARY KEY, 
   categorie_nom VARCHAR(255),
   categorie_description VARCHAR(255) NOT NULL
);

CREATE TABLE commandes(
   id_commande SERIAL PRIMARY KEY,
   commande_date DATE NOT NULL  ,
   commande_status VARCHAR(255) NOT NULL CHECK(commande_status IN ('PENDING','PAID','SHIPPED','CANCELLED')),
   id_client INT NOT NULL,
   CONSTRAINT fk_id_client FOREIGN KEY(id_client) REFERENCES clients(id_client)
);

CREATE TABLE produits(
   id_produit SERIAL PRIMARY KEY,
   produit_nom VARCHAR(255) NOT NULL,
   produit_prix DECIMAL(15,2) NOT NULL CHECK (produit_prix > 0),
   produit_stock INT CHECK (produit_stock >= 0),
   id_categorie INT NOT NULL,
   CONSTRAINT fk_id_categorie FOREIGN KEY(id_categorie) REFERENCES categories(id_categorie)
);

CREATE TABLE lignes_commandes(
   id_ligne SERIAL PRIMARY KEY,
   ligne_quantité INT CHECK (ligne_quantité >0),
   ligne_prix FLOAT CHECK (ligne_prix >0),
   id_commande INT NOT NULL,
   id_produit INT NOT NULL,
   CONSTRAINT fk_id_commande FOREIGN KEY(id_commande) REFERENCES commandes(id_commande),
   CONSTRAINT fk_id_produit FOREIGN KEY(id_produit) REFERENCES produits(id_produit)
);
