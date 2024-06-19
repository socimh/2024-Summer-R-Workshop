## 2024 R 语言 tidyverse 入门工作坊

<!-- [点击回到 Github](https://github.com/socimh/2024-Summer-R-Workshop) -->

沈明宏（[mhshenaa\@connect.ust.hk](mailto:mhshenaa@connect.ust.hk)）

## 实用链接

工作坊链接

-   [在线讲义](https://socimh.github.io/intro2tidy/)
-   [每周的代码和作业等（回到 Github）](https://github.com/socimh/2024-Summer-R-Workshop)
-   [疑难问题搜集 (Q&A)](https://docs.qq.com/doc/DZWdQREVuUEtTV0l4?scene=45af37bc0fcf6a8f5e1ec050JkZHs1)

statart 和 tidyverse 链接

-   [statart 官网](https://socimh.github.io/statart/index.html)、[statart 函数大全](https://socimh.github.io/statart/reference/index.html)
-   [tidyverse 官网](https://www.tidyverse.org/packages/)、[dplyr 官网](https://dplyr.tidyverse.org/)、[ggplot2 官网](https://ggplot2.tidyverse.org/)

一些教材链接

-   [Hadley Wickham](https://hadley.nz/) 的 [R for Data Science (2e)](https://r4ds.hadley.nz/)
-   北大数学 李东风老师 [R 语言教程](https://www.math.pku.edu.cn/teachers/lidf/docs/Rbook/html/_Rbook/index.html)
-   川师物理 王敏杰老师 [数据科学中的 R 语言](https://bookdown.org/wangminjie/R4DS/author.html)

还有数不清的在线、免费教科书，可以在 [bookdown](https://bookdown.org/home/archive/) 等网站上找到。

## 时间地点

-   Zoom 会议链接见微信群；
-   或者直接打开 Zoom，“加入会议”那里点击下拉小箭头，找到历史会议，原来的会议室进去就行。
-   时间一般是每周二晚上 19:30-21:00，具体以下方为准。

## Week 1 概览（6月4日）

> 下面 1.2 表示讲义第 1 章第 2 节，Week1-0.R 表示相应 R 代码文件。后同。

-   下载安装 R、RStudio、Copilot (建议)、Github Desktop (建议)、更纱黑体 (建议)、敦煌配色 (建议)
    -   参见 [下载各种东西.md](https://github.com/socimh/2024-Summer-R-Workshop/blob/main/Week%201/%E4%B8%8B%E8%BD%BD%E5%90%84%E7%A7%8D%E4%B8%9C%E8%A5%BF.md)
-   下载安装 tidyverse 和 statart 等 R 包（[1.6](https://socimh.github.io/intro2tidy/intro.html), [2.2](https://socimh.github.io/intro2tidy/tibble.html), Week1-0.R）
-   R 简介（[1.5, 1.7, 1.10](https://socimh.github.io/intro2tidy/intro.html)）
-   tibble 数据简介（[1.8-1.9](https://socimh.github.io/intro2tidy/intro.html), [第 2 章](https://socimh.github.io/intro2tidy/tibble.html)）
-   导入、导出 tibble 数据（[Week 1-1.R 到 Week 1-4.R](https://github.com/socimh/2024-Summer-R-Workshop/tree/main/Week%201)）
-   浏览 tibble 数据（[3.1-3.2](https://socimh.github.io/intro2tidy/dplyr-skim.html)）
-   [Zoom 录像回放](https://hkust.zoom.us/rec/share/BctFpkiuSJ-Fu_My1Iu4FZjspod3VcfE2hc8B8Llf2VXzjyNbvurA4cLjx_09zkw.u9NJYutAgH8op6MG)

## Week 2 清理数据（6月11日）

-   [第一周作业讲解](https://github.com/socimh/2024-Summer-R-Workshop/blob/main/Week%201/Week%201%20Assignment/Week1%20Assignment%20Solution.R)
-   浏览 tibble 数据（[第3章](https://socimh.github.io/intro2tidy/dplyr-skim.html)）
-   dplyr 排序（[第 4 章](https://socimh.github.io/intro2tidy/dplyr-sort.html)）
-   magrittr 管道（[第 5 章](https://socimh.github.io/intro2tidy/dplyr-pipe.html)）
-   dplyr 的选取或删除（[第 6 章](https://socimh.github.io/intro2tidy/dplyr-grammar.html)）
-   分析宋朝官员数据（explore\_song\_officials.R）
-   [Zoom 录像回放](https://hkust.zoom.us/rec/share/2Cx0Gtdakqu7yJu17TcsRHJUOBXU02aQnMaCVpCvjGZxlECuXth9Gj3OgbSnpQiL.j6BskjhHfKlC-fBl)

## Week 3 统计数据（6月18日）

-   [第二周作业讲解](https://github.com/socimh/2024-Summer-R-Workshop/blob/main/Week%202/Week%202%20Assignment/Week2%20Assignment%20Solution.R)
-   dplyr 的选取或删除（[第 7 章](https://socimh.github.io/intro2tidy/dplyr-select.html)）
-   dplyr 的修改或新建（[第 6](https://socimh.github.io/intro2tidy/dplyr-grammar.html) 、[8 章](https://socimh.github.io/intro2tidy/dplyr-mutate.html)）
-   dplyr 统计（[第 9 章](https://socimh.github.io/intro2tidy/dplyr-stat.html)）
-   分析工作坊问卷数据（Week 3-1.R 和 Week 3-2.R 等）
-   [Zoom 录像回放](https://hkust.zoom.us/rec/share/oQM37hEeBRMvhiNsuR6LeBS8y4hmtmh2RKeZehGdU7IKChvrRTljfhlnRSR9DP1a.maAyum5DEeCJ6FLE)

## Week 4 数据可视化（6月25日）

-   第三周作业讲解
-   dplyr 分组（[第 10 章](https://socimh.github.io/intro2tidy/dplyr-group.html)）
-   s_plot() 快速画图
-   钻石数据可视化
-   ggplot2 画图（[R4DS Ch1](https://r4ds.hadley.nz/data-visualize)）
-   武汉马拉松运动员数据可视化

## Week 5 文本数据、正则表达式（7月2日）

-   第四周作业讲解
-   正则表达式（[R4DS Ch15](https://r4ds.hadley.nz/regexps)）
-   stringr 处理文本（[R4DS Ch14](https://r4ds.hadley.nz/strings.html)）
-   分析《诗经》数据

## Week 6 类别数据、时间数据、回归模型（7月9日 【可能晚些开始】）

## Week 7 驳杂数据（7月23日 【跳过一周】）

-   dplyr 合并（[第 11 章](https://socimh.github.io/intro2tidy/dplyr-join.html)）
-   分析中国省份简写数据

## Week 8 高维度数据（8月6日 【跳过一周】）

## Week 9 模型与画图进阶篇（8月13日）

## Week 10 空间数据、网络数据（8月20日）

## 说明

下载 Github Desktop 以后 fork 这个 repo，可以实时更新一些资料（参见 Week 1/下载各种东西.md）。如果不会操作也没关系，我会在每周的工作坊之前把压缩包发到群里。

这个 repo 可能会在工作坊结束后转为私密，所以请大家及时下载资料噢。
