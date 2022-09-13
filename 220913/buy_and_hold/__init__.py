import numpy as np

class buyandhold():
    def __init__(self, df, col):
        self.df = df.loc[:, [col]]
        self.col = col

    def drop_na(self):
        self.df = self.df[~self.df.isin([np.nan, np.inf, -np.inf]).any(1)]
        return self.df
    
    def add_column(self):
        self.df["daily_rtn"] = self.df[self.col].pct_change()
        self.df["st_rtn"] = (1 + self.df["daily_rtn"]).cumprod()
        return self.df

    def testing(self):
        self.historical_max = self.df[self.col].cummax()
        self.daily_drawdown = self.df[self.col]/self.historical_max - 1.0
        self.historical_min = self.daily_drawdown.cummin()
        self.last_date = self.df.index[-1]
        self.CAGR = self.df.loc[self.last_date, 'st_rtn'] ** (252/len(self.df)) - 1
        self.sharpe = np.mean(self.df["daily_rtn"]) / np.std(self.df["daily_rtn"])\
             * np.sqrt(252)
        self.VOL = np.std(self.df["daily_rtn"]) * np.sqrt(252)
        self.MDD = self.historical_min.min()
        return [self.CAGR, self.sharpe, self.VOL, self.MDD]
    
