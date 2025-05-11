from flask import Blueprint, render_template, redirect, url_for, request, Flask
from flask import session
from psycopg2 import connect

from models.modelo00_bd import cadenaConexion
from models.modelo02_tmstatus import get_allstatus
from models.modelo03_tmcargos import get_all_vtmcargos
from models.modelo03_tmcargos import add_tmcargo
from models.modelo03_tmcargos import get_cargo_by_codcar
from models.modelo03_tmcargos import set_modificar_tmcargo
from models.modelo03_tmcargos import set_delete_tmcargo

obj_tmcargos = Blueprint('tmcargos',__name__)

@obj_tmcargos.route('/inicio')
def inicio():
    return render_template('m03_tmcargos/tmcargos00_inicio.html')

@obj_tmcargos.route('/reporte')
def reporte():
    xmensaje=''
    datos = get_all_vtmcargos()
    return render_template('m03_tmcargos/tmcargos03_reporte.html',   list_cargos = datos,   mensaje = xmensaje)

@obj_tmcargos.route('/agregar')
def agregar01():
    return render_template('m03_tmcargos/tmcargos04_agregar.html')

@obj_tmcargos.route('/agregar',   methods=['GET', 'POST'])
def agregar02():
    xmensaje = " "
    if   request.method == 'POST':
        dcargo = request.form['txt_descripcion'].upper()
        sueldo = request.form['txt_sueldo']
        resultado = add_tmcargo(   dcargo ,   sueldo   )

    if   resultado is None:
        xmensaje = "¡¡¡ El " + dcargo + " fue Registrado con Éxito !!!"
    else:
        xmensaje = "¡¡¡ Error al insertar el  " + dcargo + "  !!!"
        datos = get_all_vtmcargos()
    
    return render_template('m03_tmcargos/tmcargos03_reporte.html',   list_cargos = datos,   mensaje = xmensaje)

@obj_tmcargos.route('/consultar')
def consultar01(): 
    return   render_template('m03_tmcargos/tmcargos05_consultar_modificar.html')

@obj_tmcargos.route('/consultar',   methods=['GET', 'POST'])
def consultar02():
    if   request.method == 'POST':
        xmen = " " 
        xcodcar = request.form['txt_codcar']
        xcargo = get_cargo_by_codcar(   xcodcar   )
        xtmstatus = get_all_status()
    if   xcargo:
        xmen = "!!! El Código " + str(xcodcar) + " Encontrado ¡¡¡"
    else:
        xmen = "!!! El Código " + str(xcodcar) + " No Existe ¡¡¡" 

    return render_template('m03_tmcargos/tmcargos05_consultar_modificar.html',
    cargo = xcargo,   mensaje = xmen,   tmstatus = xtmstatus)

@obj_tmcargos.route('/modificar')
def modificar01():
    return   render_template('m03_tmcargos/tmcargos05_consultar_modificar.html')

@obj_tmcargos.route('/modificar', methods=['GET', 'POST'])
def modificar02():
    if   request.method   ==   'POST':
        xmen   =   " "
        xcodcar = request.form['txt_codcar'] 
        xdcargo = request.form['txt_descripcion'].upper()
        xsueldo = request.form['txt_sueldo'] 
        xfkcods = request.form['txt_fkcods']

        xresp   =   set_modificar_tmcargo(   xcodcar,   xdcargo,   xsueldo,   xfkcods  )

    return   redirect("/tmcargos/reporte")

@obj_tmcargos.route('/eliminar')
def eliminar01():
    return render_template('m03_tmcargos/tmcargos05_consultar_modificar.html')

@obj_tmcargos.route('/eliminar/<int:xcodcar>')
def eliminar02(  xcodcar  =  None  ):
    xresp = set_delete_tmcargo(xcodcar)

    if (xresp):
        xmensaje = "¡¡¡ Error al eliminar el código: " + str(xcodcar) + " !!!"
    else:
        xmensaje = "¡¡¡ El código: " + str(xcodcar) + " fue eliminado con Éxito !!!"
 
    print (" " + xmensaje)
    return   redirect("/tmcargos/reporte")