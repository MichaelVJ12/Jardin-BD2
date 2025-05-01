import os
from flask import Flask, url_for, render_template

mi_app = Flask(__name__)

mi_app.secret_key="anything"

@mi_app.route('/')
@mi_app.route('/index')
@mi_app.route('/main')
def start():
	return render_template('m01_sitio/main.html')

if __name__=='__main__':
	mi_app.run(host="127.0.0.1", port = 5000, debug=True)
