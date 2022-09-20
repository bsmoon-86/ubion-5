from flask import Flask, render_template, request, redirect
import pymysql
import pandas as pd 
import mod_sql 

# __name__ : 현재 실행이 되고 있는 파일의 이름(main.py)
app = Flask(__name__)

# api 생성 

# localhost:5000/ 를 호출했을 때
# 먼가의 행동을 하겠다 
# 행동을 하는 주체  : 서버
@app.route("/")
def index():
    # return "Hello World"
    return render_template("index.html")

## 로그인
## 유저의 ID, password 값을 받아와서 sql을 통해 데이터를 확인하여 
## 로그인 성공 , 실패 여부 확인
@app.route("/login", methods=["POST"])
def login():
    _id = request.form["_id"]
    _pass = request.form["_pass"]
    print(_id, _pass)
    ## sql을 통해서 _id, _pass 같은 데이터를 확인
    db = mod_sql.Database()
    sql = """
            select 
            * 
            from 
            user_info 
            where 
            ID = %s and password = %s
    """
    values = [_id, _pass]
    result = db.executeall(sql, values)
    if result:
        return redirect("/main")
    else:
        return redirect("/")

@app.route("/main")
def main():
    ## sql 접속 
    ## data 가지고와서 테이블 형태로 페이지에서 출력
    db = mod_sql.Database()
    ## Region을 기준으로 그룹화
    ## 컬럼 Region, AVG_Cost
    ## html에서 테이블로 출력
    sql = """
            select 
            Region, 
            AVG(`Total Cost`) as AVG_Cost 
            from 
            `sales records`
            group by 
            Region
    """
    result = db.executeall(sql)
    print(result)
    cnt = len(result)
    ## result값을 데이터프레임 변경
    df = pd.DataFrame(result)
    ## region 컬럼의 값을 리스트로 region 변수에 삽입
    region = df["Region"].to_list()
    ## AVG_Cost 컬럼의 값을 리스트 형태로 avg 변수에 삽입
    avg = df["AVG_Cost"].to_list()
    return render_template("main.html", 
                        sales = result, 
                        cnt = cnt, 
                        region = region, 
                        avg = avg)


# 회원 정보 추가
# 회원 가입 페이지 
@app.route("/signup")
def signup():
    return render_template("signup.html")

## 웹 서버에 호출하는 방식 
## get , post
## get : 유저가 데이터를 보낼때 url에 실어서 보내는 방법
## get형식은 데이터를 받아오는 방법 request.args[key]
## post : 유저가 데이터를 보낼때 request 메시지 안에 body 곳에 실어서 보내는 방법
## post형식은 데이터를 받아오는 방법 request.form[key]
@app.route("/signup2", methods=["POST"])
def signup2():
    # 유저가 보낸 데이터를 변수에 삽입을 하는 구간
    _id = request.form["_id"]
    _pass = request.form["_pass"]
    _name = request.form["_name"]
    _birth = request.form["_birth"]
    _phone = request.form["_phone"]
    print(_id, _pass, _name, _birth, _phone)
    # 이 변수들을 sql에 추가
    # mod_sql에 있는 Database 클래스 생성
    db = mod_sql.Database()
    sql = """
            insert into 
            user_info 
            values 
            (%s, %s, %s, %s, %s)
    """
    values = [_id, _pass, _name, _birth, _phone]
    db.execute(sql, values)
    db.commit()
    db.close()

    # 로그인 페이지로 이동 
    return redirect("/")
# 웹 서버를 오픈
app.run()