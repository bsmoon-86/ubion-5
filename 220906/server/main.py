from flask import Flask

#__name__ : 파일의 이름
app = Flask(__name__)


@app.route("/")     ##127.0.0.1:5000/ 로 접속(요청)했을때 바로 밑에 함수를 실행
def index():
    return "Hello World"

## 127.0.0.1:5000/second 웹브라우져를 이용하여 요청을 했을때 바로 밑에 함수를 실행
@app.route("/second")
def second():
    return "Second Page"


app.run()