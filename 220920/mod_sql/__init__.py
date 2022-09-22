import pymysql
import pandas as pd

class Database():
    def __init__(self):
        self._db = pymysql.connect(
            host = "localhost", 
            user = "root", 
            passwd= "1234", 
            db = "web_test", 
            port = 3306
        )
        self.cursor = self._db.cursor(pymysql.cursors.DictCursor)

    def execute(self, sql, values=[]):
        self.cursor.execute(sql, values)

    def commit(self):
        self._db.commit()

    def executeall(self, sql, values=[]):
        self.cursor.execute(sql, values)
        self.result = self.cursor.fetchall()
        return self.result
    
    def close(self):
        self._db.close()
    