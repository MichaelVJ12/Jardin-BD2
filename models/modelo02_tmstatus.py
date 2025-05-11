from   flask   import   Blueprint,   render_template,   flash,   redirect,   url_for,   request,   Flask
from   flask   import   session 
from   psycopg2   import   connect

from   models.modelo00_bd   import   cadenaConexion

def   get_all_status():
    conexion   =   cadenaConexion() 
    cursor   =   conexion.cursor()

    sql = "SELECT * FROM tmstatus;"
 
    cursor.execute(sql,  )
    resultado   =   cursor.fetchall()
    codigo_conexion   =   conexion.commit() 
    cursor.close()
    conexion.close()

    return   resultado 