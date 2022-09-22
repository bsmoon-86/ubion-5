library(dplyr)
library(ggplot2)

mpg = ggplot2::mpg

## 산점도 그래프 

## 배경 레이어 지정
ggplot(data = mpg, aes(x = displ, y = hwy))

## 그래프를 그려주는 레이어 추가 
ggplot(data = mpg, aes(x = displ, y = hwy)) + 
  geom_point()

## 옵션을 추가 (x축의 범위 지정)
ggplot(data = mpg, aes(x = displ, y = hwy)) + 
  geom_point() + xlim(3, 6)

## y축의 범위를 지정
ggplot(data = mpg, aes(x = displ, y = hwy)) + 
  geom_point() + xlim(3, 6) + ylim(20, 30)


## 막대 그래프
mpg2 = mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy = mean(hwy))


ggplot(data = mpg2, aes(x = drv, y = mean_hwy)) + 
  geom_col()

## 데이터의 크기에 따라 순서를 변경

# 오름차순 변경
ggplot(data = mpg2, aes(x = reorder(drv, mean_hwy), 
                        y = mean_hwy)) + 
  geom_col()

# 내림차순 변경
ggplot(data = mpg2, aes(x = reorder(drv, desc(mean_hwy)), 
                        y = mean_hwy)) +
  geom_col()


## geom_bar() 막대그래프
ggplot(data = mpg, aes(x = drv)) + geom_bar()
table(mpg$drv)
qplot(mpg$drv)


## 라인 그래프 
economics = ggplot2::economics
View(economics)
ggplot(data = economics, aes(x = date, y = unemploy)) +
  geom_line()


## 박스 플롯
ggplot(data = mpg, aes(x = drv, y = hwy)) + 
  geom_boxplot()


