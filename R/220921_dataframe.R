# csv 파일 로드 
df = read.csv("./csv/csv_exam.csv")
df

head(df)
head(df, 2)

tail(df)
tail(df, 2)

# 엑셀의 형태와 마찬가지의 뷰어창에 데이터프레임을 확인
view(df)
View(df)

# 데이터프레임의 크기를 출력
dim(df)

#데이터프레임의 속성 값을 출력
str(df)

# 컬럼의 데이터의 개수를 출력
table(df$class)

# 통계 요약 정보 출력
summary(df)
summary(df$math)

## dplyr 패키지 설치
install.packages("dplyr")
# dplyr패키지 로드
library(dplyr)

df_raw = data.frame(var1 = c(1, 2, 1), 
                    var2 = c(2, 3, 5))
df_raw

# rename(데이터프레임명, 새 컬럼명=변경이될 컬럼명)
rename(df_raw, v2 = var2)
df_raw

# 파생변수 생성
df_raw$sum = df_raw$var1 + df_raw$var2
df_raw

# if문을 이용해서 파생변수 
# sum의 값이 5보다 크면 pass 아니면 fail 
df_raw$res = ifelse(df_raw$sum > 5, "pass", "fail")
df_raw

# 다중 if문을 사용하려면?
# sum의 값이 5보다 크면 "pass" 5인 경우는 "hold" 
# 5보다 작으면 "fail"
df_raw$res = ifelse(df_raw$sum > 5, "pass", 
                    ifelse(df_raw$sum == 5, "hold", "fail"))
df_raw

# dplyr 패키지에 있는 내장 함수들 사용
df
# filter() 필터링 기능을 가진 함수
df %>% filter(class == 1)

# arrange() 정렬을 변경하는 함수
df %>%  arrange(math)
# desc나 음수형태로 변경하여 사용하면 내림차순 정렬
df %>% arrange(desc(math))
df %>% arrange(-math)

# 정렬의 기준을 여러개 
df %>% arrange(class, math)

# 클래스를 기준으로 오름차순, 수학 성적 기준으로 내림차순
df %>% arrange(class, desc(math))
df %>% arrange(class, -math)

# 특정 컬럼만 선택하여 출력
df %>% select(class)
df %>% select(class, math, english)
# 특정 컬럼만 삭제하여 출력
df %>% select(-class)

# 컬럼의 범위 지정
df %>% select(class : english)

# 새로운 컬럼을 추가하는 함수 
df %>% mutate(total = math + english + science, 
              mean = total/3)

# group_by(), summarise() 그룹화
df %>% group_by(class) %>% summarise(mean_math = mean(math), 
                                     mean_english = mean(english))


## df 데이터프레임에서 class를 기준으로 내림차순 정렬 -> 
## class , english 컬럼만 출력
df %>% arrange(desc(class)) %>% select(class, english)


## join() 함수를 사용
df_1 = data.frame(id = 1:5, score = c(80,70,80,90,95))
df_2 = data.frame(id = 1:5, weight = c(80,70,75,65,60))
df_3 = data.frame(id = 1:3, class = c(1,1,2))

#inner_join() -> 교집합
inner_join(df_1, df_2, by="id")
inner_join(df_1, df_3, by="id")

#left_join() 
left_join(df_1, df_2, by="id")
left_join(df_1, df_3, by="id")

#right_join()
right_join(df_1, df_2, by="id")
right_join(df_1, df_3, by="id")

# bind_rows() 데이터프레임에 행을 추가하는 함수
# 데이터프레임에 유니언 결합
rbind(df_1, df_2)
bind_rows(df_1, df_2)


### 결측치 처리 
c1 = c(1,2,NA,NA,5)
c2 = c(1,2,3,4,5)
c3 = c(NA,2,3,4,5)
df = data.frame(c1, c2, c3)
df
## is.na() 함수를 이용하여 결측치의 값을 확인
## 결측치인 경우 True 결측치가 아닌경우 False
is.na(df)
# is.na()함수와 table()함수를 이용하면 결측치 개수를 확인
table(is.na(df))
is.na(df$c1)
table(is.na(df$c1))

# 결측치를 제거하는 방법 
# case1 
df %>% filter(is.na(c1))
df %>% filter(!is.na(c1))
# case2
na.omit(df)


## 결측치를 제거하여 연산
## 결측치가 존재하면 연산 되지 않는다. 
mean(df$c1)
mean(df$c1, na.rm = T)
sum(df$c1)
sum(df$c1, na.rm=T)

exam = read.csv("./csv/csv_exam.csv")
exam

## 특정 부분에 결측치를 추가 
exam[c(5,7), 3] = NA
exam
is.na(exam$math)
dim(exam)
table(is.na(exam))

mean(exam$math)

## 수학 성적에 있는 결측치 부분에 평균 값을 삽입
exam$math = ifelse(is.na(exam$math), 
                   mean(exam$math, na.rm=T), 
                   exam$math)
exam

## exam$math (1,2,NA,5,NA,8)
## ifelse(is.na(exam$math), mean(exam$math, na.rm=T), exam$math)
## 1인경우 조건식이 거짓 -> 1
## 2인 경우 조건식이 거짓 -> 2
## NA인 경우 조건식이 참 -> mean()

## 이상치 제거 
outlier = data.frame(gender = c(1,2,1,2,3), 
                     score = c(80,90,70,80,50))
outlier
table(outlier$gender)

#성별에 있는 3이라는 수치는 이상치
# 성별이 3인 데이터는 결측치로 변경
outlier$gender = ifelse(outlier$gender == 3, NA, outlier$gender)
outlier

# 성별이 1,2면 원래의 값을 삽입 이 값이 아니면 NA
outlier$gender = ifelse(
  outlier$gender %in% c(1,2), 
  outlier$gender, NA)
outlier

outlier$gender = ifelse(
  outlier$gender == 1 | outlier$gender == 2, 
  outlier$gender, NA)
outlier

## 성별로 그룹화 평균 점수
## 결측치 제거 
## 그룹화
## 평균 스코어

outlier %>% 
  filter(!is.na(gender)) %>% 
  group_by(gender) %>% 
  summarise(score_mean = mean(score))


install.packages("ggplot2")
## ggplot2 로드 
library(ggplot2)

mpg = ggplot2::mpg
View(mpg)

## 극단치 고속도로연비 기준으로 
boxplot(mpg$hwy)

boxplot(mpg$hwy)$stats

## 극단치는 37 초과 거나 12 미만인 경우는 극단치
## 이 극단치들을 결측치로 변경
## mpg 데이터에서 결측치를 제거 
## manufacturer를 기준으로 그룹화
## hwy의 평균 값을 출력   & : and   | : or

## 극단치를 결측치로 변경
mpg$hwy = ifelse(
  mpg$hwy > 37 | mpg$hwy < 12, 
  NA, 
  mpg$hwy
)
table(is.na(mpg$hwy))

## 결측치를 제거 -> 제조사 그룹화 -> 평균 고속도로연비
mpg %>% 
  filter(!is.na(hwy)) %>% 
  group_by(manufacturer) %>% 
  summarise(mean_hwy = mean(hwy)) %>% 
  arrange(-mean_hwy) %>% 
  head(5)

