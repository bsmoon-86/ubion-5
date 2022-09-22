library(dplyr)
library(ggplot2)

## sav 확장자 파일을 로드 하기위한 패키지 설치
install.packages("foreign")
install.packages("readxl")

library(foreign)
library(readxl)


## 한국복지패널 데이터 로드
raw_welfare = read.spss(file = "./csv/Koweps_hpc10_2015_beta1.sav", 
                        to.data.frame = T)
View(raw_welfare)
dim(raw_welfare)

# 복사본 생성
welfare = raw_welfare

# 컬럼의 이름 변경
welfare = rename(welfare, 
                 gender = h10_g3, 
                 birth = h10_g4, 
                 marriage = h10_g10, 
                 religion = h10_g11, 
                 income = p1002_8aq1, 
                 code_job = h10_eco9, 
                 code_region = h10_reg7)

## 성별에 따라서 월급의 차이가 과연 존재하는가?
table(welfare$gender)
## 성별은 1 : 남자, 2 : 여자, 9 : 무응답
## 9라는 데이터가 존재한다 생각하고 9라는 답은 결측치로 처리 
welfare$gender = ifelse(welfare$gender == 9, NA, welfare$gender)

# 결측치 확인
table(is.na(welfare$gender))

# gender의 1은 male , 2는 female 변경
welfare$gender = ifelse(welfare$gender == 1, "male", "female")
table(welfare$gender)

## income 컬럼의 이상치를 확인
## 월급이 0인 사람을 결측치 변경
## 월급이 9999인 사람도 결측치 변경 (극단치)

# case1 
welfare$income = ifelse(welfare$income == 0, NA, 
                       (ifelse(welfare$income == 9999, NA, welfare$income)))

# case2 
welfare$income = ifelse(welfare$income == 0 | welfare$income == 9999, 
                        NA, welfare$income)

# case3
welfare$income = ifelse(welfare$income %in% c(0, 9999), 
                        NA, welfare$income)

# 결측치 확인
table(is.na(welfare$income))

## 실제 성별에 따라 월급에 차이가 존재하는가
## 결측치를 제외
## 성별로 그룹화
## 월급의 평균 
## 데이터를 시각화

gender_income = welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(gender) %>% 
  summarise(mean_income = mean(income))

gender_income

ggplot(data = gender_income, aes(x = gender, y = mean_income)) +
  geom_col()


## 나이별 월급이 어떤가 확인.
## age 컬럼을 하나 생성
## birth을 기준으로 age 컬럼을 하나 생성
## 월급, 나이의 결측치가 존재하면 삭제 계산
## 나이별 월급의 평균 
## 시각화

# birth 확인
table(welfare$birth)
## 이상치 존재 가능성 확인 

## age 컬럼을 생성
welfare$age = 2022 - welfare$birth
table(welfare$age)

age_income = welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age) %>% 
  summarise(mean_income = mean(income))

ggplot(data = age_income, aes(x = age, y = mean_income)) +
  geom_col()

## 연령대 파생변수 생성
## ageg -> 나이가 30세 미만 'young'
              ##  30세 이상 - 60세 미만 'middle'
              ##  60세 이상 - 'old'
welfare$ageg = ifelse(welfare$age < 30, 'young', 
                      (ifelse (welfare$age < 60, 'middle', 'old')))
table(welfare$ageg)

## 직업별로 월급의 평균이 차이가 나는가?
## 직업이라는 컬럼은 존재 X
## code_job 컬럼만 존재 -> codebook sheet2에 있는 직업을 컬럼을 추가
## left_join 이용하여 데이터프레임을 결합
## 월급의 결측치 제거 
## 직업별로 그룹화 
## 월급의 평균을 구해서
## 상위 10개의 직업 출력
## 시각화

## 코드북 파일 로드
list_job = read_excel("./csv/Koweps_Codebook.xlsx", 
                      sheet = 2, 
                      col_names = T)
View(list_job)

# welfare 데이터프레임과 list_job 데이터프레임을 left_join()
# 두 데이터가 공통적으로 가지고 있는 컬럼의 이름? -> code_job
# 결측치 제외하고
# 직업별로 그룹화
# 월급의 평균
# 상위 10개를 출력
# 시각화

## 두개의 데이터프레임 결합 
## left_join( 데이터프레임명1, 데이터프레임명2, by="공통되는 컬럼명" )
join_data = left_join(welfare, list_job, by="code_job")
table(join_data$job)

table(is.na(join_data$job))

## 결측치를 제거해야되는 컬럼 (job, income)
job_income = join_data %>% 
  filter(!is.na(job) & !is.na(income)) %>% 
  group_by(job) %>% 
  summarise(mean_income = mean(income))
View(job_income)

## 상위 10개만 출력
## 월급을 기준으로 내림차순 정렬
## 데이터의 시작부터 10개를 출력
job_income = job_income %>% 
  arrange(desc(mean_income)) %>% 
  head(10)
job_income

# 시각화
ggplot(data=job_income, aes(x = job, y = mean_income)) +
  geom_col()

ggplot(data=job_income, aes(x = reorder(job, -mean_income), 
                            y = mean_income)) +
  geom_col()

top10 = ggplot(data=job_income, aes(x = reorder(job, mean_income), 
                            y = mean_income)) +
  geom_col() + coord_flip()

## plotly 패키지 설치
install.packages("plotly")
library(plotly)
ggplotly(top10)


## dygraghs -> 시계열데이터를 시각화
install.packages("dygraphs")
library(dygraphs)

economics = ggplot2::economics


## xts 데이터 타입 변경( 시계열 변경 )
library(xts)
eco = xts(economics$unemploy, order.by =economics$date)
head(eco, 3)

dygraph(eco) %>% dyRangeSelector()


