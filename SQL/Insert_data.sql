
INSERT INTO categories(categorie_nom,categorie_description) VALUES
  ('Électronique',       'Produits high-tech et accessoires'),
  ('Maison & Cuisine',   'Électroménager et ustensiles'),
  ('Sport & Loisirs',    'Articles de sport et plein air'),
  ('Beauté & Santé',     'Produits de beauté, hygiène, bien-être'),
  ('Jeux & Jouets',      'Jouets pour enfants et adultes');


INSERT INTO produits(produit_nom, produit_prix, produit_stock, id_categorie) VALUES
  ('Casque Bluetooth X1000',        79.99,  50,  (SELECT id_categorie FROM categories WHERE categorie_nom ='Électronique')),
  ('Souris Gamer Pro RGB',          49.90, 120,  (SELECT id_categorie FROM categories WHERE categorie_nom ='Électronique')),
  ('Bouilloire Inox 1.7L',          29.99,  80,  (SELECT id_categorie FROM categories WHERE categorie_nom ='Maison & Cuisine')),
  ('Aspirateur Cyclonix 3000',     129.00,  40,  (SELECT id_categorie FROM categories WHERE categorie_nom ='Maison & Cuisine')),
  ('Tapis de Yoga Comfort+',        19.99, 150,  (SELECT id_categorie FROM categories WHERE categorie_nom ='Sport & Loisirs')),
  ('Haltères 5kg (paire)',          24.99,  70,  (SELECT id_categorie FROM categories WHERE categorie_nom ='Sport & Loisirs')),
  ('Crème hydratante BioSkin',      15.90, 200,  (SELECT id_categorie FROM categories WHERE categorie_nom ='Beauté & Santé')),
  ('Gel douche FreshEnergy',         4.99, 300,  (SELECT id_categorie FROM categories WHERE categorie_nom ='Beauté & Santé')),
  ('Puzzle 1000 pièces "Montagne"', 12.99,  95,  (SELECT id_categorie FROM categories WHERE categorie_nom ='Jeux & Jouets')),
  ('Jeu de société "Galaxy Quest"', 29.90,  60,  (SELECT id_categorie FROM categories WHERE categorie_nom ='Jeux & Jouets'));

  INSERT INTO clients(client_prenom,client_nom,client_mail,client_date_creation) VALUES
  ('Alice',  'Martin',    'alice.martin@mail.com',    '2024-01-10 14:32'),
  ('Bob',    'Dupont',    'bob.dupont@mail.com',      '2024-02-05 09:10'),
  ('Chloé',  'Bernard',   'chloe.bernard@mail.com',   '2024-03-12 17:22'),
  ('David',  'Robert',    'david.robert@mail.com',    '2024-01-29 11:45'),
  ('Emma',   'Leroy',     'emma.leroy@mail.com',      '2024-03-02 08:55'),
  ('Félix',  'Petit',     'felix.petit@mail.com',     '2024-02-18 16:40'),
  ('Hugo',   'Roussel',   'hugo.roussel@mail.com',    '2024-03-20 19:05'),
  ('Inès',   'Moreau',    'ines.moreau@mail.com',     '2024-01-17 10:15'),
  ('Julien', 'Fontaine',  'julien.fontaine@mail.com', '2024-01-23 13:55'),
  ('Katia',  'Garnier',   'katia.garnier@mail.com',   '2024-03-15 12:00');


INSERT INTO commandes(id_client,commande_date,commande_status) VALUES
  ((SELECT id_client FROM clients where client_mail = 'alice.martin@mail.com'),    '2024-03-01 10:20', 'PAID'),
  ((SELECT id_client FROM clients where client_mail = 'bob.dupont@mail.com'),      '2024-03-04 09:12', 'SHIPPED'),
  ((SELECT id_client FROM clients where client_mail = 'chloe.bernard@mail.com'),   '2024-03-08 15:02', 'PAID'),
  ((SELECT id_client FROM clients where client_mail = 'david.robert@mail.com'),    '2024-03-09 11:45', 'CANCELLED'),
  ((SELECT id_client FROM clients where client_mail = 'emma.leroy@mail.com'),      '2024-03-10 08:10', 'PAID'),
  ((SELECT id_client FROM clients where client_mail = 'felix.petit@mail.com'),     '2024-03-11 13:50', 'PENDING'),
  ((SELECT id_client FROM clients where client_mail = 'hugo.roussel@mail.com'),    '2024-03-15 19:30', 'SHIPPED'),
  ((SELECT id_client FROM clients where client_mail = 'ines.moreau@mail.com'),     '2024-03-16 10:00', 'PAID'),
  ((SELECT id_client FROM clients where client_mail = 'julien.fontaine@mail.com'), '2024-03-18 14:22', 'PAID'),
  ((SELECT id_client FROM clients where client_mail = 'katia.garnier@mail.com'),   '2024-03-20 18:00', 'PENDING');

INSERT INTO lignes_commandes(id_commande,id_produit,ligne_quantité,ligne_prix) VALUES
  ((select id_commande from commandes where id_client =(select id_client from clients where client_mail ='alice.martin@mail.com') and commande_date = '2024-03-01 10:20'), (SELECT id_produit FROM produits WHERE produit_nom ='Casque Bluetooth X1000'),         1,  79.99),
  ((select id_commande from commandes where id_client =(select id_client from clients where client_mail ='alice.martin@mail.com')   and commande_date =  '2024-03-01 10:20'), (SELECT id_produit FROM produits WHERE produit_nom ='Puzzle 1000 pièces "Montagne"'), 2,  12.99),
  ((select id_commande from commandes where id_client =(select id_client from clients where client_mail ='bob.dupont@mail.com')      and commande_date = '2024-03-04 09:12'), (SELECT id_produit FROM produits WHERE produit_nom ='Tapis de Yoga Comfort+'),        1,  19.99),
  ((select id_commande from commandes where id_client =(select id_client from clients where client_mail ='chloe.bernard@mail.com')   and commande_date ='2024-03-08 15:02'), (SELECT id_produit FROM produits WHERE produit_nom ='Bouilloire Inox 1.7L'),          1,  29.99),
  ((select id_commande from commandes where id_client =(select id_client from clients where client_mail ='chloe.bernard@mail.com')  and commande_date = '2024-03-08 15:02'), (SELECT id_produit FROM produits WHERE produit_nom ='Gel douche FreshEnergy'),        3,   4.99),
  ((select id_commande from commandes where id_client =(select id_client from clients where client_mail ='david.robert@mail.com')   and commande_date = '2024-03-09 11:45'), (SELECT id_produit FROM produits WHERE produit_nom ='Haltères 5kg (paire)'),          1,  24.99),
  ((select id_commande from commandes where id_client =(select id_client from clients where client_mail ='emma.leroy@mail.com')     and commande_date = '2024-03-10 08:10'), (SELECT id_produit FROM produits WHERE produit_nom ='Crème hydratante BioSkin'),      2,  15.90),
  ((select id_commande from commandes where id_client =(select id_client from clients where client_mail ='julien.fontaine@mail.com')  and commande_date ='2024-03-18 14:22'), (SELECT id_produit FROM produits WHERE produit_nom ='Jeu de société "Galaxy Quest"'), 1,  29.90),
  ((select id_commande from commandes where id_client =(select id_client from clients where client_mail ='katia.garnier@mail.com')   and commande_date = '2024-03-20 18:00'), (SELECT id_produit FROM produits WHERE produit_nom ='Souris Gamer Pro RGB'),          1,  49.90),
  ((select id_commande from commandes where id_client =(select id_client from clients where client_mail ='katia.garnier@mail.com')   and commande_date = '2024-03-20 18:00'), (SELECT id_produit FROM produits WHERE produit_nom ='Gel douche FreshEnergy'),        2,   4.99); 