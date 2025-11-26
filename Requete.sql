--Lister tous les clients triés par date de création de compte (plus anciens → plus récents).
SELECT * FROM clients
ORDER BY client_date_creation DESC;
--Lister tous les produits (nom + prix) triés par prix décroissant.
SELECT produit_nom,produit_prix from produits 
ORDER BY produit_prix DESC;
--Lister les commandes passées entre deux dates (par exemple entre le 1er et le 15 mars 2024).
SELECT * FROM commandes
WHERE commande_date BETWEEN '2024-03-01' AND '2024-03-15';
--Lister les produits dont le prix est strictement supérieur à 50 €.
SELECT * FROM produits
WHERE produit_prix > 50;
--Lister tous les produits d’une catégorie donnée (par exemple “Électronique”).
SELECT * FROM produits 
WHERE id_categorie = (SELECT id_categorie FROM categories WHERE categorie_nom = 'Électronique');



--Lister tous les produits avec le nom de leur catégorie.
SELECT * FROM produits p
INNER JOIN categories c ON p.id_categorie = c.id_categorie;
--Lister toutes les commandes avec le nom complet du client (prénom + nom).
SELECT id_commande,commande_date,commande_status,CONCAT(cl.client_nom, ' ', cl.client_prenom) FROM commandes c
INNER JOIN clients cl ON c.id_client=cl.id_client;
--Lister toutes les lignes de commande avec :
	--le nom du client,
	--le nom du produit,
	--la quantité,
	--le prix unitaire facturé.
SELECT cl.client_nom,p.produit_nom,l.ligne_quantité,l.ligne_prix FROM lignes_commandes l
INNER JOIN commandes c ON l.id_commande = c.id_commande
INNER JOIN clients cl ON c.id_client = cl.id_client
INNER JOIN produits p ON l.id_produit = l.id_produit;

--Lister toutes les commandes dont le statut est PAID ou SHIPPED.
SELECT * FROM commandes
WHERE commande_status IN ('PAID','SHIPPED')