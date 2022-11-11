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