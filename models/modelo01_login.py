from flask import Blueprint, render_template, flash, redirect, url_for, request, Flask
from flask import session
from psycopg2 import connect

from models.modelo00_bd import cadenaConexion

def get_usuario(xusuario, xclave):
    conexion = cadenaConexion()
    cursor = conexion.cursor()

    sql = "SELECT * FROM tmusuarios WHERE (usuario = %s) AND (clave = %s);"
    datos = (xusuario, xclave)

    cursor.execute(sql, datos)
    resultado = cursor.fetchone()
    codigo_conexion = conexion.commit()

    cursor.close()
    conexion.close()

    return resultado