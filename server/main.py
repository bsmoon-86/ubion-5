## flask 로드 
from flask import Flask, render_template, request, redirect

## Class 생성
app = Flask(__name__)

## localhost:5000/ 요청시 index.html 리턴 api 생성
@app.route("/")
def index():
    return render_template("index.html")

app.run()