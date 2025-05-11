from psycopg2 import connect

def cadenaConexion():
    conexion = connect(
        host="localhost", 
        port = 5432, 
        dbname = "bdretardados", 
        user = "postgres",
        password = "1234567")
    
    return conexion