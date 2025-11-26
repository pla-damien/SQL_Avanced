CREATE TABLE clients(
   id_client INT,
   client_nom VARCHAR(50) NOT NULL,
   client_prenom VARCHAR(50) NOT NULL,
   client_mail VARCHAR(50) NOT NULL,
   client_date_creation DATE NOT NULL,
   PRIMARY KEY(id_client),
   UNIQUE(client_mail)
);

CREATE TABLE categorie(
   id_categorie INT,
   categorie_description VARCHAR(50) NOT NULL,
   PRIMARY KEY(id_categorie)
);

CREATE TABLE commandes(
   id_commande INT,
   commande_date DATE NOT NULL,
   commande_status VARCHAR(50),
   id_client INT NOT NULL,
   PRIMARY KEY(id_commande),
   CONSTRAINT fk_id_client FOREIGN KEY(id_client) REFERENCES clients(id_client)
);

CREATE TABLE produits(
   id_produit INT,
   produit_nom VARCHAR(50) NOT NULL,
   produit_prix DECIMAL(15,2) NOT NULL,
   produit_stock INT,
   id_categorie INT NOT NULL,
   PRIMARY KEY(id_produit),
   CONSTRAINT fk_id_categorie FOREIGN KEY(id_categorie) REFERENCES categorie(id_categorie)
);

CREATE TABLE lignes_commandes(
   id_ligne INT,
   ligne_quantité INT,
   ligne_prix CURRENCY,
   id_commande INT NOT NULL,
   id_produit INT NOT NULL,
   PRIMARY KEY(id_ligne),
   CONSTRAINT fk_id_commande FOREIGN KEY(id_commande) REFERENCES commandes(id_commande),
   CONSTRAINT fk_id_produit FOREIGN KEY(id_produit) REFERENCES produits(id_produit)
);
