import psycopg
import os

os.remove("rapport.Txt")
DNS = "dbname=postgres user=postgres password=secret host=localhost port=5432"

def write_rapport(chaine):
    with open("rapport.txt","a") as f:
        f.write(chaine)
    f.close()

#Chiffre d’affaires total.
#Panier moyen.
#Article le plus commandé (en quantité totale).
#Top 3 clients par montant dépensé.
#Chiffre d’affaires par catégorie.

def query_CA_total():
    try:
        with psycopg.connect(DNS) as connec:
            with connec.cursor() as cur:
                cur.execute("SELECT SUM(l.ligne_prix * l.ligne_quantité) FROM lignes_commandes l")
                result = cur.fetchall()
                chaine = f"Le chiffre d'affaire total est de {result[0][0]} \n"
                return chaine
    except psycopg.errors.SyntaxError as e: 
        print ("Erreur SQL : ", e)
    except psycopg.errors.UniqueViolation as e:
        print ("Violation Unique : ", e)
    except psycopg.OperationalError as e:
        print ("Problème de connection :" , e)
    except Exception as e:
        print ("Autre erreurs : ", e)

def query_panier_moyen():
    try:
        with psycopg.connect(DNS) as connec:
            with connec.cursor() as cur:
                cur.execute("SELECT AVG(l.ligne_prix * l.ligne_quantité) from lignes_commandes l")
                result = cur.fetchall()
                chaine = f"Le panier moyen est de {result[0][0]} \n"
                return chaine
    except psycopg.errors.SyntaxError as e: 
        print ("Erreur SQL : ", e)
    except psycopg.errors.UniqueViolation as e:
        print ("Violation Unique : ", e)
    except psycopg.OperationalError as e:
        print ("Problème de connection :" , e)
    except Exception as e:
        print ("Autre erreurs : ", e)

def query_article_plus_commande():
    try:
        with psycopg.connect(DNS) as connec:
            with connec.cursor() as cur:
                cur.execute(""" SELECT p.produit_nom,SUM(l.ligne_quantité) FROM produits p
                                INNER JOIN lignes_commandes l ON l.id_produit = p.id_produit
                                GROUP BY p.id_produit,l.id_ligne
                                ORDER BY SUM(l.ligne_quantité) DESC
                                FETCH FIRST 1 ROW ONLY;""")
                result = cur.fetchall()
                chaine = f"L'article le plus commandé est :' {result[0][0]} ({result[0][1]} fois) \n"
                return chaine
    except psycopg.errors.SyntaxError as e: 
        print ("Erreur SQL : ", e)
    except psycopg.errors.UniqueViolation as e:
        print ("Violation Unique : ", e)
    except psycopg.OperationalError as e:
        print ("Problème de connection :" , e)
    except Exception as e:
        print ("Autre erreurs : ", e)

def query_top_client():
    try:
        with psycopg.connect(DNS) as connec:
            with connec.cursor() as cur:
                cur.execute(""" SELECT cl.client_nom FROM commandes c
                                INNER JOIN clients cl ON c.id_client = cl.id_client
                                INNER JOIN lignes_commandes l on c.id_commande = l.id_commande
                                GROUP BY cl.client_nom
                                ORDER BY SUM(l.ligne_quantité * l.ligne_prix) DESC
                                FETCH FIRST 3 ROW ONLY;""")
                result = cur.fetchall()
                chaine = f"Le top 3 clients est : \n {result[0][0]} \n {result[1][0]} \n {result[2][0]} \n"
                return chaine
    except psycopg.errors.SyntaxError as e: 
        print ("Erreur SQL : ", e)
    except psycopg.errors.UniqueViolation as e:
        print ("Violation Unique : ", e)
    except psycopg.OperationalError as e:
        print ("Problème de connection :" , e)
    except Exception as e:
        print ("Autre erreurs : ", e)

def query_CA_categorie():
    try:
        with psycopg.connect(DNS) as connec:
            with connec.cursor() as cur:
                cur.execute(""" SELECT c.categorie_nom ,SUM(l.ligne_quantité*l.ligne_prix) FROM lignes_commandes l
                                INNER JOIN produits p  ON p.id_produit = l.id_produit
                                INNER JOIN categories c ON c.id_categorie = p.id_categorie
                                GROUP BY  c.categorie_nom""")
                result = cur.fetchall()
                chaine = "Le chiffre d'affaire par catégorie est : \n "
                for ligne in result:
                    chaine += f"{ligne[0]} : {ligne[1]} \n"                                       
                
                return chaine
    except psycopg.errors.SyntaxError as e: 
        print ("Erreur SQL : ", e)
    except psycopg.errors.UniqueViolation as e:
        print ("Violation Unique : ", e)
    except psycopg.OperationalError as e:
        print ("Problème de connection :" , e)
    except Exception as e:
        print ("Autre erreurs : ", e)


write_rapport(query_CA_total())
write_rapport(query_panier_moyen())
write_rapport(query_article_plus_commande())
write_rapport(query_top_client())
write_rapport(query_CA_categorie())