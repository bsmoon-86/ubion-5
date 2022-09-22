## 패키지 설치
install.packages("dplyr")
install.packages("ggplot2")

# 패키지 로드
library(dplyr)
library(ggplot2)

mpg = ggplot2::mpg

## 파생변수 추가 (도심연비 + 고속도로 연비 / 2)
# case1
mpg$total = (mpg$cty + mpg$hwy)/2
head(mpg)
# case2 (dplyr 패키지 사용)
mpg = mpg %>% 
  mutate(total = (cty + hwy)/2) %>% 
  select(cty, hwy, total) %>% 
  head()

## total 컬럼을 기준으로 파생변수 생성
## test 파생변수 total의 값이 30이상이면 "A"
## total의 값이 20이상이면 "B"
## 그 외의 값은 "C"

# case1
mpg$test = ifelse(mpg$total >= 30, "A", (ifelse(mpg$total >= 20, "B", "C")))
View(mpg)
table(mpg$test)

# case2 
mpg2 = mpg %>% 
  mutate(test = ifelse(total >= 30, "A", (ifelse(total >=20 , "B", "C"))))
View(mpg2)

## 간단한 시각화
qplot(mpg$test)

## midwest ggplot2 샘플 데이터

midwest = ggplot2::midwest
View(midwest)
str(midwest)

## popasian컬럼의 이름을 asian 변경  --> 
## rename(데이터프레임명, 새 컬럼의 이름 = 변경이 될 컬럼의 이름)
## poptotal컬럼의 이름을 total 변경
## total, asian을 이용하여 전체 인구수 대비 아시아의 인구 수 값(백분율)을 
## 가지는 파생변수(ratio) 생성 
## ratio 컬럼의 평균값을 초과하면 large 이하면 small 
## 이라는 값을 가지는 파생 변수(group) 생성
## qplot을 이용하여 group을 시각화 하여 표시

## 컬럼의 이름을 변경
midwest = rename(midwest, asian = popasian, total = poptotal)
View(midwest)

midwest = midwest %>% 
  mutate(ratio = (asian / total) * 100) %>% 
  

midwest = midwest %>% 
  mutate(group = ifelse(ratio > mean(ratio), "large", "small"))
qplot(midwest$group)
table(midwest$group)
         