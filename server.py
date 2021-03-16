from flask import Flask, redirect, request, render_template, url_for
# import other libraries here

app = Flask(__name__, template_folder='templates', static_url_path='/static', static_folder='static')

@app.route("/", methods = ['GET', 'POST'])
def loadMainPage():
    return render_template('testMain.html')

if __name__ == "__main__":
    app.run(debug=True)
    app.run(host='0.0.0.0', port = 5000)
