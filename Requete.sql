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


--Afficher le détail complet de chaque commande avec :
	--date de commande,
	--nom du client,
	--liste des produits,
	--quantité,
	--prix unitaire facturé,
	--montant total de la ligne (quantité × prix unitaire).
SELECT c.commande_date,cl.client_nom,STRING_AGG(p.produit_nom || ' (' || l.ligne_quantité || ' x ' || l.ligne_prix || '€ = ' || (l.ligne_quantité * l.ligne_prix) || '€)', ', '
    ) AS produits_detail,
    SUM(l.ligne_quantité * l.ligne_prix) AS total_commande
FROM commandes c
INNER JOIN clients cl ON c.id_client = cl.id_client
INNER JOIN lignes_commandes l ON l.id_commande = c.id_commande
INNER JOIN produits p ON l.id_produit = p.id_produit
GROUP BY c.id_commande, c.commande_date, cl.client_nom
ORDER BY c.commande_date;

--Calculer le montant total de chaque commande et afficher uniquement :
	--l’ID de la commande,
	--le nom du client,
	--le montant total de la commande.
SELECT c.id_commande,cl.client_nom,SUM(l.ligne_quantité * l.ligne_prix) FROM commandes c
INNER JOIN clients cl ON c.id_client = cl.id_client
INNER JOIN lignes_commandes l on c.id_commande = l.id_commande
GROUP BY c.id_commande,cl.client_nom

--Afficher les commandes dont le montant total dépasse 100 €.
SELECT * FROM commandes c
WHERE 100 < (SELECT SUM(l.ligne_quantité * l.ligne_prix) from lignes_commandes l
WHERE c.id_commande = l.id_commande)

--Lister les catégories avec leur chiffre d’affaires total (somme du montant des lignes sur tous les produits de cette catégorie).
SELECT c.categorie_nom,SUM(p.produit_prix) FROM lignes_commandes l
INNER JOIN produits p ON l.id_produit = p.id_produit
INNER JOIN categories c ON p.id_categorie = c.id_categorie
GROUP BY p.id_categorie,c.categorie_nom

--Lister les produits qui ont été vendus au moins une fois.
SELECT * FROM produits p 
WHERE p.id_produit IN (SELECT l.id_produit FROM lignes_commandes l)

--Lister les produits qui n’ont jamais été vendus.
SELECT * FROM produits p 
WHERE p.id_produit NOT IN (SELECT l.id_produit FROM lignes_commandes l)

--Trouver le client qui a dépensé le plus (TOP 1 en chiffre d’affaires cumulé).
SELECT cl.client_nom,SUM(l.ligne_quantité * l.ligne_prix) FROM commandes c
INNER JOIN clients cl ON c.id_client = cl.id_client
INNER JOIN lignes_commandes l on c.id_commande = l.id_commande
GROUP BY cl.client_nom
ORDER BY SUM(l.ligne_quantité * l.ligne_prix) DESC
FETCH FIRST 1 ROW ONLY

--Afficher les 3 produits les plus vendus en termes de quantité totale.
SELECT * FROM produits p
INNER JOIN lignes_commandes l ON l.id_produit = p.id_produit
GROUP BY p.id_produit,l.id_ligne
ORDER BY SUM(l.ligne_quantité) DESC
FETCH FIRST 3 ROW ONLY;

--Lister les commandes dont le montant total est strictement supérieur à la moyenne de toutes les commandes.SELECT * FROM commandes c
SELECT c1.id_commande,SUM(l.ligne_prix) FROM commandes c1
INNER JOIN lignes_commandes l ON c1.id_commande = l.id_commande
GROUP BY c1.id_commande
HAVING SUM(l.ligne_prix) > (SELECT AVG(ligne_prix) from lignes_commandes);

--Calculer le chiffre d’affaires total (toutes commandes confondues, hors commandes annulées si souhaité).
SELECT sum(l.ligne_prix * l.ligne_quantité) FROM lignes_commandes l
INNER JOIN commandes c on c.id_commande = l.id_commande  
WHERE c.commande_status <> 'CANCELLED'

--Calculer le panier moyen (montant moyen par commande).
SELECT AVG(l.ligne_prix * l.ligne_quantité) from lignes_commandes l


--Calculer la quantité totale vendue par catégorie.
SELECT c.categorie_nom ,SUM(l.ligne_quantité) FROM lignes_commandes l
INNER JOIN produits p  ON p.id_produit = l.id_produit
INNER JOIN categories c ON c.id_categorie = p.id_categorie
GROUP BY  c.categorie_nom

--Calculer le chiffre d’affaires par mois (au moins sur les données fournies).
SELECT DATE_PART('month',c.commande_date),SUM(l.ligne_quantité * l.ligne_prix) FROM commandes c 
INNER JOIN lignes_commandes l ON l.id_commande = c.id_commande
GROUP BY DATE_PART('month',c.commande_date)

--Formater les montants pour n’afficher que deux décimales.