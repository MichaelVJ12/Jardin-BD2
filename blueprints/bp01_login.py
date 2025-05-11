from flask import Blueprint, render_template, redirect, url_for, request, Flask
from flask import session
from psycopg2 import connect

from models.modelo00_bd import cadenaConexion

from models.modelo01_login import get_usuario

obj_login = Blueprint('login', __name__)

@obj_login.route('/entrar')
def login_formulario():
    xmensaje = ""
    return render_template('m02_login/p01_login.html', mensaje = xmensaje)

@obj_login.route('/entrar', methods=['POST', 'GET'])
def login_validar():
    xusuario = request.form['txt_usuario'].upper()
    xclave = request.form['txt_clave']

    resultado = get_usuario(xusuario, xclave)

    if bool(resultado):
        session["xlogin"] = True
        session["xnombre"] = resultado[1]
        session["xusuario"] = resultado[2]
        session["xnivel"] = resultado[4]
        session["xstatus"] = resultado[5]
        xmensaje = ""
        
        return render_template('m02_login/p02_login.html')
    else:
        xmensaje = "¡¡¡ Acceso Denegado !!!"
        return render_template('m02_login/p01_login.html', mensaje = xmensaje)

@obj_login.route('/salir')
def login_salir():
    session.clear()
    return redirect('/')

@obj_login.route('/admin')
def admin():
    if(session['xlogin'] and not (session['xnivel'] == 0)):
        return render_template('m02_login/p03_admin.html')
    else:
        session.clear()
        return redirect('/inicio')
