import os
from flask import Flask, url_for, render_template, session, redirect, request
from psycopg2 import connect
from models.modelo00_bd import cadenaConexion

from blueprints.bp01_login import obj_login
#from blueprints.bp02_tmcargos import obj_tmcargos

mi_app = Flask(__name__)

mi_app.secret_key="anything"

@mi_app.route('/')
@mi_app.route('/index')
@mi_app.route('/main')
def start():
	return render_template('m01_sitio/main.html')

@mi_app.route('/productos')
def productos():
	return render_template('m01_sitio/p02_productos.html')

@mi_app.route('/cursos')
def cursos():
	return render_template('m01_sitio/p03_cursos.html')

@mi_app.route('/galeria')
def galeria():
	return render_template('m01_sitio/p04_galeria.html')

mi_app.register_blueprint(obj_login, url_prefix='/login')
mi_app.register_blueprint(obj_tmcargos, url_prefix='/tmcargos')  

if __name__=='__main__':
	mi_app.run(host="127.0.0.1", port = 5000, debug=True)
