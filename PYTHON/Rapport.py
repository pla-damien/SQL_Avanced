import psycopg

DNS = "dbname=postgres user=postgres password=secret host=localhost port=5432"

def write_rapport(chaine):
    with open("rapport.txt","a") as f:
        f.write(chaine+"/n")
    f.close()

#Chiffre d’affaires total.
#Panier moyen.
#Article le plus commandé (en quantité totale).
#Top 3 clients par montant dépensé.
#Chiffre d’affaires par catégorie.

def queury_CA_total():
    try:
        with psycopg.connect(DNS) as connec:
            with connec.cursor() as cur:
                cur.execute("")
    except psycopg.errors.SyntaxError as e: 
        print ("Erreur SQL : ", e)
    except psycopg.errors.UniqueViolation as e:
        print ("Violation Unique : ", e)
    except psycopg.OperationalError as e:
        print ("Problème de connection :" , e)
    except Exception as e:
        print ("Autre erreurs : ", e)