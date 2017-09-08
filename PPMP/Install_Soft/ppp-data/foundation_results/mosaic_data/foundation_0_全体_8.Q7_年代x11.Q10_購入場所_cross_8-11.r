library(RSVGTipsDevice)
    csv_mosaic <- read.csv("G:/SVN/Install_Soft/ppp-data/foundation_results/mosaic_data/foundation_0_�S��_8.Q7_�N��x11.Q10_�w���ꏊ_cross_8-11.csv", row.names=1, check.names=F, fileEncoding="cp932")
    devSVGTips(file = "G:/SVN/Install_Soft/ppp-data/foundation_results/mosaic_data/foundation_0_�S��_8.Q7_�N��x11.Q10_�w���ꏊ_mosaic_plot_8-11_sjis.svg", width=10, height=10, bg = "white", fg = "black", onefile=TRUE, toolTipMode = 0, xmlHeader=TRUE)
    mosaicplot(as.matrix(csv_mosaic), main="Q7_�N�� x Q10_�w���ꏊ (����: 10859)", xlab = "Q10_�w���ꏊ", ylab = "Q7_�N��", shade=FALSE, cex.axis=0.66, dir=c("h", "v"), las = 2, color=c("#FFBFCF", "#FFFFAA", "#FFCC99", "#CCFFCC", "#BFF1FF", "#CCCCFF"))
    dev.off()
    