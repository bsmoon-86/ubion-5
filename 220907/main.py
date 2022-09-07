from flask import Flask, render_template, request, redirect

# Flask라는 Class에서 __init__ 함수에 self를 제외한 매개변수 1개
# __name__ : 자기 자신의 파일의 이름
app = Flask(__name__)

# api 생성

# 127.0.0.1:5000
# 5000이라는 숫자는 port 번호
# port??
# 127.0.0.1 = localhost

## localhost:5000/
@app.route("/") 
# @app.route() -> localhost:5000/ 요청이 있는 경우에 바로 아래에 있는 
# 함수를 실행
def index():
    print(request)
    return render_template("index.html")

# get 형식에서 데이터는 url에 실어서 보낸다. 
# request -> 유저가 서버에게 보내는 데이터를 dict 형태로 출력
# 유저가 보낸 데이터 중에url에 있는 데이터는 : request.args : dict형태
@app.route("/second/")
def second():
    _id = request.args.get("ID")
    _pass = request.args.get("password")
    # id값 과 password값
    # id는 test, password는 1234
    # 위의 조건이 만족해야만 second.html 리턴
    # 위의 조건이 거짓이면 "로그인 실패" 리턴
    print(request)

    # if _id == "test" and _pass == "1234":
    #    return render_template("second.html")
    # else:
    #     # return "로그인 실패"
    #     return redirect("/")

    return render_template("second.html")

# localhost:5000/third  post 형식으로 요청 시
@app.route("/third/", methods=["post"])
def third():
    _title = request.form["title"]
    _content = request.form["content"]
    print(_title, _content)
    return render_template("third.html", 
                            content=_content, 
                            title=_title
                            )


# Flask라는 Class 안에 있는 run()이라는 함수 호출
app.run()



## 실제 서버와 유저간의 데이터의 이동 
## dict형태의 데이터로 request / response
## request -> 유저가 서버에게 보내는 데이터
## response -> 서버가 유저에게 보내는 데이터
## request =  {
    #           key : value, 
    #           key2 : value2, 
    #           args: {
    #                   ID : input에서 입력한 값(ID), 
    #                   password : input에서 입력한 값(password)
    #                 } 
    #         }
# request["args"]["ID"] == request.args.get("ID")