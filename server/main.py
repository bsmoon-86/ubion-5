## flask 로드 
from flask import Flask, render_template, request, redirect

## Class 생성
app = Flask(__name__)

## localhost:5000/ 요청시 index.html 리턴 api 생성
@app.route("/")
def index():
    # inex.html 그래프를 그리기 위해서 필요한 변수 값 
    # x_pos, y_pos 
    _x = [1,2,3,4,5]
    _y = [10, 20, 30, 40, 50]
    return render_template("index.html", x_pos=_x, y_pos=_y)

app.run()