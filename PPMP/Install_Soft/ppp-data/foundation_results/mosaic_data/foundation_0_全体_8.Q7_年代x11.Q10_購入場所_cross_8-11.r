library(RSVGTipsDevice)
    csv_mosaic <- read.csv("G:/SVN/Install_Soft/ppp-data/foundation_results/mosaic_data/foundation_0_‘S‘Ì_8.Q7_”N‘ãx11.Q10_w“üêŠ_cross_8-11.csv", row.names=1, check.names=F, fileEncoding="cp932")
    devSVGTips(file = "G:/SVN/Install_Soft/ppp-data/foundation_results/mosaic_data/foundation_0_‘S‘Ì_8.Q7_”N‘ãx11.Q10_w“üêŠ_mosaic_plot_8-11_sjis.svg", width=10, height=10, bg = "white", fg = "black", onefile=TRUE, toolTipMode = 0, xmlHeader=TRUE)
    mosaicplot(as.matrix(csv_mosaic), main="Q7_”N‘ã x Q10_w“üêŠ (‘”: 10859)", xlab = "Q10_w“üêŠ", ylab = "Q7_”N‘ã", shade=FALSE, cex.axis=0.66, dir=c("h", "v"), las = 2, color=c("#FFBFCF", "#FFFFAA", "#FFCC99", "#CCFFCC", "#BFF1FF", "#CCCCFF"))
    dev.off()
    