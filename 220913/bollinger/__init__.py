import pandas as pd
import numpy as np

class Bol():
    def __init__(self, df, col):
        self.df = df.set_index(["Date"])
        self.df = self.df.loc[:, [col]]
        self.col = col

    def add_column(self, num):
        self.df["center"] = self.df[self.col].rolling(num).mean()
        self.df["ub"] = self.df["center"] + 2 * self.df[self.col].rolling(num).std()
        self.df["lb"] = self.df["center"] - 2 * self.df[self.col].rolling(num).std()
        self.df["trade"] = ""
        return self.df

    def start_time(self, time):
        self.df = self.df.loc[time:]
        return self.df

    def insert_buy(self):
        for i in self.df.index:
            if self.df.loc[i, self.col] > self.df.loc[i, "ub"]:
                self.df.loc[i, "trade"] = ""
            elif self.df.loc[i, "lb"] > self.df.loc[i, self.col]:
                self.df.loc[i, "trade"] = "buy"
            elif self.df.loc[i, "ub"] >= self.df.loc[i, self.col] and \
                self.df.loc[i, self.col] >= self.df.loc[i, "lb"]:
                if self.df.shift(1).loc[i, "trade"] == "buy":
                    self.df.loc[i, "trade"] = "buy"
                else : 
                    self.df.loc[i, "trade"] = ""

        return self.df.value_counts("trade")

    def returns(self):
        self.rtn = 1.0
        self.buy = 0.0
        self.sell = 0.0
        self.df["return"] = 1
        for i in self.df.index:
            if self.df.loc[i, "trade"] == "buy" and \
                self.df.shift(1).loc[i, "trade"] == "":
                self.buy = self.df.loc[i, self.col]
                print("진입일 : ", i, "진입 가격 : ", self.buy)
            elif self.df.loc[i, "trade"] == "" and \
                self.df.shift(1).loc[i, "trade"] == "buy":
                self.sell = self.df.loc[i, self.col]
                self.rtn = (self.sell - self.buy) / self.buy + 1
                self.df.loc[i, "return"] = self.rtn
                print("청산일 : ", i, "진입 가격 : ", self.buy, "청산 가격 : ", self.sell, \
                    "| return : ", self.rtn)
            if self.df.loc[i, "trade"] == "":
                self.buy = 0.0
                self.sell = 0.0
        self.acc_rtn = 1.0
        for i in self.df.index:
            self.rtn = self.df.loc[i, "return"]
            self.acc_rtn = self.acc_rtn * self.rtn
            self.df.loc[i, "acc_rtn"] = self.acc_rtn
        return self.acc_rtn


