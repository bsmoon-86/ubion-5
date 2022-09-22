## openapi 

install.packages("XML")
library(XML)

#접속 주소 변수
url <- "http://apis.data.go.kr/1160100/service/GetFnCoBasiInfoService/getFnCoOutl"

#서비스키
servicekey <- "dtbWOdJ%2FCz5HE0DGLU%2BCRPe7pOW0NIQBUcGEqsHZaTRiYCI%2F5%2BzugwzQjcvuId7NPdg6rUiW%2Bft3fm7yqyD4pw%3D%3D"

#페이지 넘버
pageno = 1

#페이지당 데이터의 개수
numofrows = 10

#데이터의 타입
type_data = "xml"


service_url = paste0(url, 
                     "?serviceKey=", servicekey, 
                     "&pageNo=", pageno, 
                     "&numOfRows=", numofrows, 
                     "&resultType=", type_data)
service_url

xmlDocument = xmlTreeParse(service_url, 
                           useInternalNodes = TRUE, 
                           encoding = "UTF-8")
xmlDocument

## xml root node 확인
rootnode = xmlRoot(xmlDocument)
rootnode

## 페이지당 데이터의 개수
rows = xpathSApply(rootnode, '//numOfRows', xmlValue)
rows

## 전체 데이터의 개수
total_rows = xpathSApply(rootnode, '//totalCount', xmlValue)
total_rows

# 반복 전체 데이터의 개수/페이지당 데이터의 개수 + 1
typeof(total_rows)
#숫자의 형태로 변경 연산
rows = as.numeric(rows)
total_rows = as.numeric(total_rows)

loopcount = ceiling(total_rows/rows)
loopcount

# 빈 데이터프레임 생성
total_data = data.frame()

for (i in 1:2){
  service_url = paste0(url, 
                       "?serviceKey=", servicekey, 
                       "&pageNo=", i, 
                       "&numOfRows=", numofrows, 
                       "&resultType=", type_data)
  
  xmlDocument = xmlTreeParse(service_url, 
                             useInternalNodes = TRUE, 
                             encoding = "UTF-8")
  # rootnode 확인
  rootnode = xmlRoot(xmlDocument)
  
  # item 태그 안에 있는 값들을 호출
  node = getNodeSet(rootnode, '//item')
  
  # xml 데이터를 데이터프레임으로 변경
  df_node = xmlToDataFrame(node)
  
  # Total_data 유니언 결합
  total_data = rbind(total_data, df_node)
}


View(total_data)

write.csv(total_data, 
          "금융.csv", 
          row.names = F, 
          fileEncoding = "cp949")




