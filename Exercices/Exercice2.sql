

SELECT track_id,duration_s,t.artist_id,title 
FROM tracks t
INNER JOIN artists a ON a.artist_id = t.artist_id
order by title;

--L’équipe métier souhaite disposer d’une vue qui centralise, pour chaque commande :
--les informations de base de la commande (client, date, statut),
--le montant total de la commande.

--Mettre en place une vue adaptée à ce besoin à partir des tables existantes.
CREATE OR REPLACE VIEW v_orders AS 
SELECT c.order_id ,c.order_date,c.status,cu.full_name,sum(o.unit_price * o.quantity) as CA FROM orders c
INNER JOIN order_items o ON o.order_id = c.order_id
INNER JOIN customers cu ON cu.customer_id = c.customer_id
group by c.order_id,cu.full_name;

--Exploiter cette vue pour obtenir la liste des commandes complétées, avec leurs montants, classées par date puis par identifiant de commande.
SELECT * FROM v_orders 
WHERE status = 'COMPLETED'
ORDER BY order_date,order_id

--2. Statistiques de ventes par jour
--Le service de reporting a besoin d’un tableau de bord quotidien indiquant, pour chaque jour :
--le nombre de commandes complétées,
--le chiffre d’affaires total de ces commandes.
--Mettre en place une vue matérialisée qui fournit ces statistiques quotidiennes.
CREATE MATERIALIZED VIEW mv_dashboard AS
SELECT count(o.order_id),SUM(CA),o.order_date FROM v_orders o
WHERE o.status = 'COMPLETED'
GROUP BY o.order_date;

--Interroger cette vue pour afficher la totalité des jours connus, classés par date.
SELECT DISTINCT(order_date) from mv_dashboard
order by order_date;

--Interroger cette même vue pour obtenir uniquement les jours dont le chiffre d’affaires est supérieur ou égal à 200.
SELECT * FROM mv_dashboard 
WHERE sum > 200

--Pour chaque client, on veut connaître :
--le nombre de commandes complétées,
--le chiffre d’affaires total associé.
--Mettre en place une vue matérialisée qui regroupe ces informations par client.
CREATE MATERIALIZED VIEW mv_customers_order AS
SELECT c.customer_id,count(o.order_id),SUM(v.CA) FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN v_orders v ON o.order_id = v.order_id
group by c.customer_id;

--Exploiter cette vue pour afficher la liste des clients, classés du plus gros chiffre d’affaires au plus faible.
SELECT * FROM mv_customers_order
ORDER BY sum;

--Exploiter cette vue pour afficher uniquement les clients ayant passé au moins deux commandes complétées.
SELECT * FROM mv_customers_order
WHERE count >= 2


--4. Optimisation via index
--Certaines requêtes sont particulièrement fréquentes :
--filtrer ou trier les statistiques par date,
--interroger souvent les clients par chiffre d’affaires total.
--Proposer un ou plusieurs index pertinents sur les vues matérialisées précédentes afin d’optimiser ces usages.
--Justifier brièvement, pour chaque index, le type de requête qu’il permet d’accélérer.

--index sur orders(order_date)

--5. Données à jour vs vues matérialisées
--On simule maintenant l’arrivée de nouvelles données dans le système :
--Une nouvelle commande complétée est enregistrée pour le client 2 :

INSERT INTO orders (order_id, customer_id, order_date, status)
VALUES (7, 2, DATE '2024-05-04', 'COMPLETED');

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES
    (8, 7, 3, 1, 89.00),
    (9, 7, 4, 1, 19.90);
--Vérifier, à l’aide de la vue classique mise en place à la question 1, que cette nouvelle commande est bien prise en compte.
SELECT * FROM v_orders where order_id = 7 --à jour
--Vérifier, à l’aide de la vue matérialisée de statistiques quotidiennes, si les données reflètent ou non cette nouvelle commande.
SELECT * FROM mv_dashboard; --Pas à jout
--Mettre à jour la vue matérialisée de statistiques quotidiennes pour qu’elle reflète l’état actuel des données.
REFRESH MATERIALIZED VIEW mv_dashboard;
--Refaire la vérification et expliquer (en quelques mots, par commentaire ou à l’oral) la différence de comportement entre la vue classique et la vue matérialisée.
SELECT * FROM mv_dashboard; -- OK, La vue matérialisé est un snapshot d'un moment donnée alors que que la vue classique est en temps réel.
