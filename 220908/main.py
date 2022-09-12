from flask import Flask, render_template, send_file
import pandas as pd
from io import BytesIO
import matplotlib.pyplot as plt

app=Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html")

## 이미지를 보내주는 api
## 여기에서 이미지는 matplotlib이용하여 만든 그래프를 보내주는 api
@app.route("/img")
def img():
    plt.switch_backend('Agg')
    df = pd.read_csv("../csv/corona.csv")
    df.columns = ["인덱스", "등록일시", "사망자", 
                "확진자", "게시글번호", "기준일", 
                "기준시간", "수정일시", "누적의심자", 
                "누적확진률"]
    df.sort_values("등록일시", inplace=True)
    df["일일확진자"] = df["확진자"].diff()
    y_pos = df["일일확진자"].head(10)
    plt.plot(y_pos)
    img_1 = BytesIO()
    plt.savefig(img_1, format="png", dpi=200)
    img_1.seek(0)

    return send_file(img_1, mimetype="image/png")

app.run()