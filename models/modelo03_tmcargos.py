from   flask   import   Blueprint,   render_template,   flash,   redirect,   url_for,   request,   Flask
from   flask   import    session
from   psycopg2   import   connect 

from models.modelo00_bd import cadenaConexion

def get_all_vtmcargos(): 
    conexion = cadenaConexion()
    cursor = conexion.cursor()

    sql ="select * from vtmcargos;"

    cursor.execute(sql,  )
    resultado = cursor.fetchall()
    codigo_conexion = conexion.commit()

    cursor.close()
    conexion.close() 

    return   resultado 

def add_tmcargo(xdcargo , xsueldo):
    conexion = cadenaConexion()
    cursor = conexion.cursor() 
 
    sql = "INSERT INTO tmcargos(dcargo, sueldo) VALUES (%s, %s);"
    datos = (xdcargo, xsueldo)

    cursor.execute(sql, datos)
    codigo_conexion = conexion.commit()

    cursor.close()
    conexion.close()

    return codigo_conexion 

def get_cargo_by_codcar(xcodcar):
    conexion = cadenaConexion()
    cursor = conexion.cursor() 
    sql = "SELECT * FROM tmcargos  WHERE codcar = %s "
    datos = (xcodcar, ) 
 
    cursor.execute(sql, datos)
    resultado = cursor.fetchone()
    codigo_conexion = conexion.commit()

    cursor.close()
    conexion.close()

    return resultado 

def set_modificar_tmcargo(xcodcar, xdcaro, xsueldo, xfkcods):
    conexion = cadenaConexion()
    cursor = conexion.cursor() 

    sql = "UPDATE tmcargos SET  dcargo = %s, sueldo = %s, fkcods =  %s  WHERE codcar = %s ;" 
    datos = (xcodcar, xdcaro, xsueldo, xfkcods) 
 
    respuesta = cursor.execute(sql, datos)
    codigo_conexion = conexion.commit()

    cursor.close()
    conexion.close()

    return respuesta

def set_delete_tmcargo(xcodcar):
    conexion = cadenaConexion()
    cursor = conexion.cursor() 

    sql = "UPDATE tmcargos SET fkcods =  %s  WHERE codcar = %s ;"
    datos = ("0", xcodcar) 
 
    respuesta = cursor.execute(sql, datos)
    codigo_conexion = conexion.commit()

    cursor.close()
    conexion.close()

    return respuesta 