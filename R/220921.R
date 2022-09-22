# 벡터
a = c(1,2,3,4,5)
a
b = 1:5
b
c = c(3,1,5,6,7)

# 행렬
b = array(1:20, dim=c(4,5))
b

c = matrix(1:10, nrow=2)
c

# 리스트
d = list(name = "test", age = 20, 
         phone = "01012345678")
d
d["name"]

df = data.frame(name = c("test", "test2"), 
                age = c(20, 30), 
                phone = c("01012345678", "01098765432"))
df


# if문 
a = 10
if (a > 20){
  print("a는 20보다 크다")
}else{
  print("a는 20보다 작거나 같다")
}

# which 문
name  = c("test", "test2", "test3")
which(name == "test2")
which(name != "test2")
which(name == "test5")

a <- 1
5 -> a


# 함수(매개변수가 존재하지 않는 경우)
func_1 = function(){
  print("Hello R")
}
func_1()

# 매개변수가 존재하는 함수 생성
func_2 = function(x, y){
  result = x ^ y
  return(result)
}
func_2(5, 2)

func_3 = function(x, y){result=x^y; return(result);}
func_3(5, 2)

# 매개변수 존재하는 경우 (매개변수에 기본값을 설정)
func_4 = function(x, y=3){
  result = x ^ y
  return(result)
}
func_4(10)
func_4(10, 2)

## 매개변수의 개수가 가변인 경우 
func_5 = function(x, ...){
  print(x)
  summary(...)
}

e = 1:10
f = 1:5
func_5("test", e)
func_5("test2", f)

## 백터형의 데이터를 가지고 데이터프레임을 생성
## 백터 데이터의 길이가 동일해야 가능

name = c("test", "test2", "test3", "test4", "test5")
grade = c(1,3,2,1,2)
student = data.frame(name, grade)
student

midturm = c(70,80,60,70,90)
final = c(80,80,70,60,60)
scores = cbind(midturm, final)
scores

students = data.frame(student, scores)
students

gender = c("M", "F", "F", "M", "F")
students = cbind(students, gender)
students

## 새로운 컬럼을 추가 ( 중간 + 기말 합친 데이터를 추가 )
# case1 (위에 중간, 기말 성적 백터 데이터의 합 )
total_score = midturm + final
total_score

# case2 ( 중간 성적 컬럼의 값, 기말 성적의 값 두개의 합 )
# 컬럼 하나의 값을 출력
students$midturm
students[["final"]]
students[[5]]
total_score2 = students$midturm + students[["final"]]
total_score2

total_score == total_score2

cbind(students, total_score)

## 행을 추가하는 함수 rbind()
## rbind()는 데이터프레임의 형태와 같은 형태의 데이터를 추가

new_student = data.frame(name = "test6", 
                         grade= 3, 
                         midturm = 80, 
                         final = 70, 
                         gender = "F")
new_student

rbind(students, new_student)

## 인덱스를 기준으로 필터링 
## 데이터프레임[행의 수, 열의 수]
students[1,]
students[2:4,]
# 인덱스의 값을 음수로 하게 되면 
# 해당하는 인덱스를 제외한 나머지의 값들이 출력
students[-2, ]

# 행의 수가 들어가는 부분에 조건식이 들어가면 참이 값만 출력
students$grade > 2
students[students$grade > 2, ]

# 정렬 (grade 기준) - 기본값은 오름차순 정렬
order(students$grade)
students[order(students$grade), ]

# 내림차순 정렬
order(students$grade, decreasing = TRUE)
order(-students$grade)
students[order(-students$grade), ]

# 결측치가 포함된 연산
x = c(7, 9, NA, 5, 2)
x[x>6]
subset(x, x>6)




