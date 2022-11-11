R at Aobayama 20221116 by Ryosuke TAJIMA 
==============  

# 基本
## R言語の基本的な操作
```R  
x<-2
y<-5
a<-c(1,3,5,7,9) #数字列
b<-c(2,4,6,8,10) #数字列
e<-a+b #要素の足し算
f<-a*b #要素の掛け算
moji<-c("A","B","C","D") #文字列も要素になる
```

## データの読み込み
```R  
getwd() #現在のディレクトリを確かめる
```

GUIで作業ディレクトリの設定
File > Change Directory ...  
R studioだと簡単らしい
```R  
d<-read.table("data.txt", header=T)
head(d)
d
```  
  
## データセットの操作  
```R  
A<-d[1,1]
A<-d[10,1]  
A<-d[1:3,4:7]  
A<-d[3,]  
A<-d[,8]  
# headerを使った抽出  
rep<-d$Rep  
rep<-d$rep #大文字小文字は区別される
# subsetを使った抽出
sdS<-subset(d,d$Sen=="S")  
sdT<-subset(d,d$Sen=="T")  
# データの追加
sd<-d[,12:32]
TRL<-apply(sd, 1, sum) #全根長，ちょっとテクニカル
TLN<-d$Seg1+d$Seg2+d$Seg3 #側根数0-6cm
d2<-cbind(d,TLN, TRL)
sd2S<-subset(d2,d2$Sen=="S")  
sd2T<-subset(d2,d2$Sen=="T")  
```  

## クラスの確認
```R  
class(d$Rep)  
class(d$SDW)  
# numeric -> 数値，character -> 文字列，factor -> ファクター等
```  
  
  
  
# 解析
## 分散分析
```R  
resultSDW<-aov(SDW~Sen,d) #一元配置の分散分析  
d$Salt<-as.factor(d$Salt)
resultSDW<-aov(SDW~Salt,d) #一元配置の分散分析  
summary(resultSDW)
resultSDW<-aov(SDW~Rep+Salt,d) #一元配置，乱塊法  
summary(resultSDW)
resultSDW<-aov(SDW~Sen+Salt+Sen*Salt,d) #二元配置の分散分析  
summary(resultSDW)
resultSDW<-aov(SDW~Sen*Salt,d) #二元配置の分散分析，簡易記述  
summary(resultSDW)
  
# おまけ  
resultSDW<-aov(SDW~Rep+Sen*Salt,d) #二元配置の分散分析，乱塊法  
summary(resultSDW)
resultSDW<-aov(SDW~Rep+Sen+Error(Rep/Sen)+Salt+Sen*Salt,d) #二元配置の分散分析，分割区法  
summary(resultSDW)
resultSDW<-aov(SDW~Rep+Sen+Error(Rep/(Sen*Salt))+Sen*Salt,d) #二元配置の分散分析，二方分割法  
summary(resultSDW)
```  

## まとめてできる
```R  
resultSDW<-aov(SDW~Sen*Salt,d) #地上部DW  
resultSap<-aov(Sap~Sen*Salt,d) #出液
resultVol<-aov(Vol~Sen*Salt,d) #体積
resultBdiam<-aov(Bdiam~Sen*Salt,d) #基部直径
resultTRL<-aov(TRL~Sen*Salt,d2) #全根長

summary(resultSDW)
summary(resultSap)
summary(resultVol)
summary(resultBdiam)
summary(resultTRL)
```  

## 多重性の問題  
$$1-(1-p)^{n}$$  
```R  
p<-0.05
n<-6
1-(1-p)^n
```  

## TukeyHSDによる多重比較  
```R  
resultSDWsdS<-aov(SDW~Salt, sdS) # 一元配置の分散分析
resultSDWsdT<-aov(SDW~Salt, sdT) # 一元配置の分散分析
summary(resultSDWsdS)  
summary(resultSDWsdT)  
TukeyHSD(resultSDWsdS)  
TukeyHSD(resultSDWsdT)  
```  
  
## ライブラリmultcomp利用
```R  
install.packages("multcomp", dependencies = T)
library(multcomp)
d$Sen<-as.factor(d$Sen) #クラスをfactorにする，上の例では自動でfactorと認識している
d$Salt<-as.factor(d$Salt) #クラスをfactorにする，上の例では自動でfactorと認識している
sdS<-subset(d,d$Sen=="S")  
sdT<-subset(d,d$Sen=="T")  
resultSDWsdS<-aov(SDW~Salt, sdS) #一元配置の分散分析
resultSDWsdT<-aov(SDW~Salt, sdT) # 一元配置の分散分析
TukeySDWsdS<-glht(resultSDWsdS, linfct=mcp(Salt="Tukey"))  
TukeySDWsdT<-glht(resultSDWsdT, linfct=mcp(Salt="Tukey"))  

summary(TukeySDWsdS)  
summary(TukeySDWsdT)  

cld(TukeySDWsdS, level = 0.05, decreasing = TRUE) # アルファベットをつける
cld(TukeySDWsdT, level = 0.05, decreasing = TRUE) # アルファベットをつける
```  
  
## 相関  
```R  
cor(d$SDW, d$Sap)  
cor(sdS$SDW, sdS$Sap)  
cor(sdT$SDW, sdT$Sap)  
allcor<-cor(d2[,5:34]) #まとめて解析  
allcor
```  
  
## 回帰
```R  
result<-lm(SDW~Sap, sdT) #単回帰  
summary(result)  
result<-lm(SDW~Sap+TRL, sd2T) #重回帰  
summary(result)  
```  
  
## 共分散解析
```R  
d2$Salt<-as.numeric(d2$Salt)
resultSDW<-lm(SDW~Sen*Salt,d2)
summary(resultSDW)
resultSap<-lm(Sap~Sen*Salt, d2)
summary(resultSap)
resultTRL<-lm(Sap~Sen*Salt, d2)
summary(resultTRL)
```

# 図表作成に向けて  
## Excelで平均と標準誤差
エクセルで別途説明  
  
## Rで平均と標準誤差，ライブラリdplyr利用
```R  
install.packages("dplyr", dependencies = T)
library(dplyr)
dpS <-d2 %>%
    filter(Sen=="S") %>%
    group_by(Salt) %>%
    summarise(Mean=mean(SDW), SE=sd(SDW)/sqrt(3))

dpT <-d2 %>%
    filter(Sen=="T") %>%
    group_by(Salt) %>%
    summarise(Mean=mean(SDW), SE=sd(SDW)/sqrt(3))

Sen<-rep(c("S", "T"), times = c(10,10)) # 数列生成
dpSDW<-data.frame(cbind(Sen, rbind(dpS,dpT)))

write.table(dpSDW, file="dSDW.csv", sep=",", row.names=F) #書き出し
```  

## 全根長のデータも
```R  
dpS <-d2 %>%
    filter(Sen=="S") %>%
    group_by(Salt) %>%
    summarise(Mean=mean(TRL), SE=sd(TRL)/sqrt(3))

dpT <-d2 %>%
    filter(Sen=="T") %>%
    group_by(Salt) %>%
    summarise(Mean=mean(TRL), SE=sd(TRL)/sqrt(3))

dpTRL<-data.frame(cbind(Sen, rbind(dpS,dpT)))
write.table(dpTRL, file="dTRL.csv", sep=",", row.names=F) #書き出し
```  


## Excelの表
エクセルで別途説明  

## Rで図を作りデータのアウトラインを確認する  
```R  
#相関
plot(d2[,5:7])
plot(d2$SDW, d2$TRL)  
par(mfcol=c(1,2)) # 並べる
plot(sd2S$SDW, sd2S$TRL)  
plot(sd2T$SDW, sd2T$TRL)  

#箱ヒゲ図
boxplot(d$SDW)  
boxplot(d2$SDW~d2$Sen)  
par(mfcol=c(2,2)) # 並べられる
boxplot(sd2S$SDW~sd2S$Salt)  
boxplot(sd2T$SDW~ sd2T$Salt)  
boxplot(sd2S$TRL~sd2S$Salt)  
boxplot(sd2T$TRL~ sd2T$Salt)  
```  

## libraryを使わないで図を作る
  
```R  
dSDW<-read.csv("dSDW.csv")
sdSDWS<-subset(dSDW,dSDW$Sen=="S")  
sdSDWT<-subset(dSDW,dSDW$Sen=="T")  
dTRL<-read.csv("dTRL.csv")
sdTRLS<-subset(dTRL,dTRL$Sen=="S")  
sdTRLT<-subset(dTRL,dTRL$Sen=="T")  
  
pdf("Fig.pdf", width=14, height=7)
par(oma = c(2, 2, 2, 2)) # 下・左・上・右
par(mfrow=c(1,2))
par(family = "serif")
par(mgp = c(5, 1, 0))        # ラベル位置，数値位置，軸位置
  
# SDW
# S
x<-sdSDWS$Salt
y<-sdSDWS$Mean
ySE<-sdSDWS$SE
plot(x, y,
    xlim = c(0,9), 
    ylim = c(0,2.4), 
    xlab = "",
    ylab = "",
    col = "blue",
    pch=16,
    cex=2.5,
    axes=FALSE
    )
arrows(x, y, x, y + ySE, angle = 90, length = 0.05)
arrows(x, y, x, y - ySE, angle = 90, length = 0.05)
par(new=T)

# T
x<-sdSDWT$Salt
y<-sdSDWT$Mean
ySE<-sdSDWT$SE
plot(x, y,
    xlim = c(0,9), 
    ylim = c(0,2.4), 
    xlab = "",
    ylab = "",
    col = "red",
    pch=15,
    cex=2.5,
    axes=FALSE
    )
arrows(x, y, x, y + ySE, angle = 90, length = 0.05)
arrows(x, y, x, y - ySE, angle = 90, length = 0.05)

##Adding axes
box("plot",lty=1,lwd=2)
axis(1, at=c(0,1,2,3,4,5,6,7,8,9), cex.axis=2, las=1, labels = T)
axis(2, at=c(0,0.6,1.2,1.8,2.4), cex.axis=2, las=1, labels = T)
legend(7.5,2.3,legend=c("S","T"), pch=c(16,15), col=c("blue","red"), cex=1.5, pt.cex = 2,bty = "n")
text(2.5,2.3, labels="Shoot Dry Weight",family="serif", cex=2)

# TRL
# S
x<-sdTRLS$Salt
y<-sdTRLS$Mean
ySE<-sdTRLS$SE
plot(x, y,
    xlim = c(0,9), 
    ylim = c(0,6000), 
    xlab = "",
    ylab = "",
    col = "blue",
    pch=16,
    cex=2.5,
    axes=FALSE
    )
arrows(x, y, x, y + ySE, angle = 90, length = 0.05)
arrows(x, y, x, y - ySE, angle = 90, length = 0.05)
par(new=T)

# T
x<-sdTRLT$Salt
y<-sdTRLT$Mean
ySE<-sdTRLT$SE
plot(x, y,
    xlim = c(0,9), 
    ylim = c(0,6000), 
    xlab = "",
    ylab = "",
    col = "red",
    pch=15,
    cex=2.5,
    axes=FALSE
    )
arrows(x, y, x, y + ySE, angle = 90, length = 0.05)
arrows(x, y, x, y - ySE, angle = 90, length = 0.05)

##Adding axes
box("plot",lty=1,lwd=2)
axis(1, at=c(0,1,2,3,4,5,6,7,8,9), cex.axis=2, las=1, labels = T)
axis(2, at=c(0,2000,4000,6000), cex.axis=2, las=1, labels = T)
legend(7.5,5800,legend=c("S","T"), pch=c(16,15), col=c("blue","red"), cex=1.5, pt.cex = 2,bty = "n")
text(2.5,5800, labels="Total Root Length",family="serif", cex=2)
dev.off()  
```  

環境を構築したり慣れると効率的だがおすすめまではしない
```R  
source("plot.r")
```  
  
最近はggplot2で作る人が多い気がします  
Rstudioと一緒に使うと便利そうに見えます  
以上です  