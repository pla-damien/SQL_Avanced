--Créer une vue adaptée à ce besoin, puis l’utiliser pour lister l’ensemble du catalogue de manière ordonnée.
CREATE OR REPLACE VIEW v_order_catalogue AS 
SELECT track_id,duration_s,t.artist_id,title 
FROM tracks t
INNER JOIN artists a ON a.artist_id = t.artist_id
order by title;

--Créer une vue filtrée permettant d’identifier ces utilisateurs, puis l’utiliser pour obtenir une liste ordonnée.
CREATE OR REPLACE VIEW v_order_user AS 
SELECT * FROM users 
WHERE country = 'France' AND subscription = 'Premium';

--Créer cette vue consolidée en utilisant les relations entre les tables, puis l’interroger pour extraire uniquement les écoutes réalisées par des utilisateurs français.
CREATE OR REPLACE VIEW v_listen AS 
	SELECT u.user_id,u.username,u.country,t.title,a.name,l.listened_at,l.seconds_played FROM listenings l
	INNER JOIN tracks t ON t.track_id = l.track_id
	INNER JOIN users u ON u.user_id = l.user_id
	INNER JOIN artists a ON a.artist_id = t.artist_id;

SELECT * FROM v_listen 
WHERE country = 'France'


--le nombre total d’écoutes,
--le nombre total de secondes écoutées,
--la durée moyenne écoutée par écoute.
--Créer cette vue matérialisée, puis l’utiliser pour identifier les artistes les plus écoutés selon différents critères (par exemple ceux qui ont un nombre d’écoutes élevé, ou un volume total de lecture important
--).
CREATE MATERIALIZED VIEW mv_stat_listen AS 
SELECT a.artist_id,a.name,count(*) as nb_listen,AVG(l.seconds_played) as nb_second FROM artists a
INNER JOIN tracks t ON t.artist_id = a.artist_id
INNER JOIN listenings l ON l.track_id = t.track_id
group by a.name,a.artist_id;

SELECT * from mv_stat_listen
where count > 3
ORDER by nb_second;

--À partir des statistiques d’écoute par artiste, analyser maintenant la performance :
--par pays d’artiste,
--en regroupant l’ensemble des artistes du même pays.
SELECT a.country,count(*),SUM(s.nb_second) FROM mv_stat_listen s
INNER JOIN artists a ON a.artist_id = s.artist_id
group by a.country
ORDER BY s.nb_second DESC;

--Produire une requête donnant, pour chaque pays :

--le volume total d’écoute cumulé,
--le nombre d’artistes concernés,

--Certaines colonnes de ces vues matérialisées seront utilisées très souvent dans des filtres et tris (par exemple le total de secondes ou la moyenne par écoute).
--Identifier les colonnes les plus pertinentes à indexer, et proposer les index adaptés pour optimiser ces usages.
CREATE INDEX IF NOT EXISTS [nom de la contrainte] ON [nom de la table(columnA)]


