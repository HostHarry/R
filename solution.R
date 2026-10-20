# 功能：用 R 重现第一篇疟疾论文的图 1，并按作者补充代码重现图 3、4、5、6A—B。
# 在项目目录的 R 控制台运行：source("solution.R")
# 也可以在终端运行：Rscript solution.R
#
# 原始数据 spatioTemporalEpisodeHistories.csv 与本脚本放在同一个文件夹。
# 所有图直接使用这份原始 CSV；文件缺失时会报错停止。
# 图 4 按补充代码绘制两个面板；图 5 按补充代码使用 PrevEpisodes / Age。
#
# 阅读提示：# 后面的文字是注释，不会作为代码执行。
# <- 表示把右边的结果保存到左边的变量；$ 用来访问数据框中的某一列。
# 同一个函数调用如果写成多行，需要选中整个调用一起运行。

# 1. 直接指定项目绝对路径，并加载绘图包 ----
project_dir <- "/Users/hostharry/Downloads/intro-r-lectures" # 固定项目目录，用来确定输出位置。
library(ggplot2) # 加载 ggplot2，让后面可以直接使用 ggplot() 等函数。
library(patchwork) # 加载 patchwork，用来将多个面板拼接成一张图。

paper_dir <- file.path(project_dir, "paper_1") # 指向保存论文图片和参考资料的子目录。
# 直接指定与 solution.R 同目录的原始 CSV 绝对路径；移动项目时也需要修改这一行。
data_file <- "/Users/hostharry/Downloads/intro-r-lectures/spatioTemporalEpisodeHistories.csv"
output_dir <- file.path(paper_dir, "figures") # 指定图片和汇总表的保存目录。
# 创建输出目录；允许连同父目录一起创建，目录已存在时不显示警告。
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)
years <- 2006:2018 # : 生成连续整数，研究年份包括 2006 年和 2018 年。
episode_groups <- c("1", "2", "3+") # 定义一年发病 1 次、2 次、至少 3 次的三个分组。

# 2. 计算每年的发病总次数，以及三个发病分组各自贡献的次数 ----
episodes <- read.csv(data_file, stringsAsFactors = FALSE) # 直接读取原始 CSV；路径错误时会报错。
required_columns <- c( # 列出后续计算必须使用的字段。
    # 依次为儿童编号、年份、年龄、当年发病次数、累计发病次数和出生季度。
    "Participant.ID", "Year", "Age", "Episodes", "CumEpisodes", "BirthQuarter",
    "BirthYear", "Genotype", "PrevEpisodes", "GotEpisode" # 出生年份、基因型、既往次数和发病标志。
) # 结束必需字段名向量的定义。
# %in% 检查每个必需字段是否在实际列名中；只要有字段缺失就进入下面的分支。
if (!all(required_columns %in% names(episodes))) {
    # 停止运行，并用逗号连接字段名，提示 CSV 应该包含哪些列。
    stop("The CSV must contain: ", paste(required_columns, collapse = ", "))
} # 结束字段完整性检查。
if (anyNA(episodes[, required_columns])) { # 选取必需列，检查其中是否出现缺失值 NA。
    # 有缺失值时停止，防止后面的求和或比例计算产生不可靠结果。
    stop("Required data contain missing values; resolve these before plotting.")
} # 结束缺失值检查。
# 年份、年龄、发病次数等字段必须是数值；儿童编号、季度和基因型可以是文本。
numeric_columns <- c("Year", "Age", "Episodes", "CumEpisodes", "BirthYear", "PrevEpisodes")
# 对这些列分别调用 is.numeric()；如果不是全部为数值列，就进入错误分支。
if (!all(vapply(episodes[, numeric_columns], is.numeric, logical(1)))) {
    stop("These columns must be numeric: ", paste(numeric_columns, collapse = ", ")) # 提示类型要求。
} # 结束数值类型检查。

# 论文研究的是 2006—2018 年、年龄 1—12 岁的儿童，包含镰状细胞性状携带者。
episodes <- episodes[ # 开始按条件筛选行，再把筛选结果存回 episodes。
    # & 表示三个条件必须同时满足；行条件后面的逗号分隔行选择和列选择。
    episodes$Year %in% years & episodes$Age >= 1 & episodes$Age <= 12,
] # 列选择留空，表示保留所有列；结束数据筛选。
if (!setequal(episodes$Year, years)) { # 比较年份集合，不考虑重复次数和顺序。
    # 如果筛选后没有覆盖全部 13 个研究年份，就停止并提示。
    stop("The selected observations must cover every year from 2006 to 2018.")
} # 结束年份覆盖检查。
if (anyDuplicated(episodes[, c("Participant.ID", "Year")])) { # 检查儿童与年份的组合是否重复。
    # 同一儿童同一年应只有一行，重复记录会造成发病次数和人数重复计算。
    stop("Duplicate participant-year records would distort the annual totals.")
} # 结束重复记录检查。
# | 表示任一条件成立即可；floor() 向下取整，用来识别非整数的发病次数。
if (any(episodes$Episodes < 0 | episodes$Episodes != floor(episodes$Episodes))) {
    stop("Episodes must be non-negative whole numbers.") # 发病次数必须是非负整数。
} # 结束发病次数取值检查。
if (any(episodes$CumEpisodes < episodes$Episodes)) { # 累计次数不应小于当年次数。
    stop("CumEpisodes must include the current year's Episodes.") # 不满足就停止。
} # 结束累计次数检查。
# 先转为文本，再去掉开头的 Q，使 Q1 和 1 等两种写法都变成字符 "1"。
episodes$BirthQuarter <- sub("^Q", "", as.character(episodes$BirthQuarter))
if (!all(episodes$BirthQuarter %in% as.character(1:4))) { # 确保出生季度只能取 1、2、3、4。
    stop("BirthQuarter must use 1-4 or Q1-Q4.") # 出现其他季度写法时停止。
} # 结束出生季度取值检查。
episodes$BirthQuarter <- factor( # 将出生季度转成分类变量，控制绘图时的排列顺序。
    # levels 规定原值的顺序，labels 将这四个类别显示为 Q1、Q2、Q3、Q4。
    episodes$BirthQuarter, levels = as.character(1:4), labels = paste0("Q", 1:4)
) # 完成出生季度因子的转换。
if (!all(episodes$Genotype %in% c("AA", "AS"))) { # 本研究使用 AA 和 AS 两种基因型。
    stop("Genotype must be AA or AS for these figures.") # 避免将未知基因型混入分组。
} # 结束基因型检查。
if (!all(episodes$GotEpisode %in% c("no", "yes"))) { # 发病标志只应为 no 或 yes。
    stop("GotEpisode must use no or yes.") # 出现其他标志时停止。
} # 结束发病标志取值检查。
if (any((episodes$GotEpisode == "yes") != (episodes$Episodes > 0))) { # 检查标志与次数是否一致。
    stop("GotEpisode disagrees with Episodes > 0.") # 不一致时不继续生成分组图。
} # 结束发病标志一致性检查。
episodes$GotEpisode <- factor(episodes$GotEpisode, levels = c("no", "yes")) # 固定分组显示顺序。

annual <- aggregate( # 按年份分组，对下面三列分别求和，生成年度汇总表。
    data.frame( # 临时创建一个由三列组成的数据框，每行仍对应一名儿童的一年。
        TotalEpisodes = episodes$Episodes, # 这一列记录每条记录的当年发病次数。
        ChildrenWithEpisode = as.integer(episodes$Episodes > 0), # 发病记为 1，否则记为 0。
        ChildrenObserved = rep(1L, nrow(episodes)) # 每行记为 1，分组求和后就是当年人数。
    ), # 结束临时数据框，逗号表示后面还有 aggregate() 的参数。
    by = list(Year = episodes$Year), # 指定分组依据为 Year，并保留这个列名。
    FUN = sum # 指定每组的汇总函数为 sum()，即求和。
) # 结束汇总，每个年份得到一行结果。
# 用“至少发病一次的儿童数”除以“当年观察儿童总数”，得到 0—1 之间的比例。
annual$ProportionWithEpisode <- annual$ChildrenWithEpisode / annual$ChildrenObserved

positive <- episodes[episodes$Episodes > 0, ] # 只保留当年至少发病一次的记录，列全部保留。
# ifelse() 逐行判断：发病至少三次归为 "3+"，其余保留为 1 或 2。
positive$EpisodeGroup <- ifelse(positive$Episodes >= 3, "3+", positive$Episodes)
episode_distribution <- aggregate( # 同时按年份和发病分组汇总发病次数。
    # 公式左边是求和的变量，右边两个变量共同定义分组；这里的 + 不表示数值相加。
    Episodes ~ Year + EpisodeGroup, data = positive, FUN = sum
) # 完成每年、每个发病分组的次数统计。
# 如果某一年没有某类发病记录，也要保留这个分组，并把次数补成零。
episode_distribution <- merge( # 将全部“年份 × 分组”组合与实际汇总结果连接。
    expand.grid(Year = years, EpisodeGroup = episode_groups), # 生成 13 × 3 种组合。
    # 按年份和分组匹配；all.x=TRUE 保留左表的全部组合，即使右表没有对应记录。
    episode_distribution, by = c("Year", "EpisodeGroup"), all.x = TRUE
) # 完成连接，缺少记录的组合暂时会得到 NA。
# 找出连接后 Episodes 列里的 NA，把这些没有发病贡献的组合改为零。
episode_distribution$Episodes[is.na(episode_distribution$Episodes)] <- 0
output_suffix <- "recreated" # 输出文件统一使用 recreated 后缀。
# 设置图片底部的说明，注明使用原始观测数据和论文来源。
figure_note <- "Recreated from the original participant-year CSV; Valletta et al. (2021)."
message( # 向控制台显示读取的数据量。
    "Loaded ", nrow(episodes), " child-years from ", # nrow() 统计儿童年度记录数。
    length(unique(episodes$Participant.ID)), " children." # 先去重编号，再计算不同儿童的人数。
) # 结束这条提示信息。

annual <- annual[order(annual$Year), ] # 按年份从小到大重新排列汇总表，保留所有列。
episode_distribution$EpisodeGroup <- factor( # 将发病分组转成因子，让图例顺序固定。
    episode_distribution$EpisodeGroup, levels = episode_groups # 类别依次为 1、2、3+。
) # 完成发病分组因子的转换。
episode_distribution$EpisodeShare <- episode_distribution$Episodes / # 分子是每组贡献的发病次数。
    # match() 找到同一年在年度表中的行号，取出对应总数作为分母，避免行顺序不同时错配。
    annual$TotalEpisodes[match(episode_distribution$Year, annual$Year)]

# 下列检查验证年度汇总与分组汇总是否一致。
stack_totals <- aggregate(Episodes ~ Year, episode_distribution, sum) # 把每年的三个分组重新求和。
stopifnot( # 要求下面所有条件都成立，否则立即报错停止。
    # 每一年的发病儿童比例都必须在 0 到 1 之间。
    all(annual$ProportionWithEpisode >= 0 & annual$ProportionWithEpisode <= 1),
    all(episode_distribution$Episodes >= 0), # 每个分组贡献的发病次数不能为负。
    isTRUE(all.equal(stack_totals$Episodes, annual$TotalEpisodes)) # 分组之和应与年度总数一致。
) # all.equal() 允许微小浮点误差；isTRUE() 确认比较结果确实为 TRUE。

# 3. 绘制图 1A：年度发病总次数和至少发病一次的儿童比例 ----
paper_theme <- theme_gray(base_size = 13) + # 使用灰底白网格的基础主题，基础字号设为 13。
    theme( # 在基础主题上进一步调整外观；ggplot2 中的 + 用于叠加图层或设置。
        legend.position = "top", # 把图例放在图的上方。
        legend.title = element_text(size = 13), # 设置图例标题字号。
        legend.text = element_text(size = 12), # 设置图例各项的文字字号。
        axis.title = element_text(colour = "black"), # 将坐标轴标题设为黑色。
        plot.tag = element_text(size = 18), # 设置 A、B、C 等子图编号的字号。
        plot.caption = element_text(size = 9, hjust = 0), # 设置图注字号，并让它左对齐。
        plot.margin = margin(10, 10, 10, 10) # 设置上、右、下、左四边留白，默认单位为点。
    ) # 完成主题设置，后面多张图会重复使用。

# ggplot2 的右侧坐标轴由左侧坐标变换而来，不能直接当作独立坐标轴使用。
# 原图中比例 0.5 与发病次数 300 对齐，所以绘图时将比例乘以 600。
# 600 只是坐标轴换算系数，不是儿童人数，也不改变实际计算出的比例。
axis_conversion <- 600 # 保存左右坐标轴之间的换算系数。
figure_1a <- ggplot(annual, aes(x = Year)) + # 使用年度汇总表，aes() 将年份映射到横轴。
    geom_line( # 添加第一条折线，表示年度总发病次数。
        # 纵轴取总次数；颜色映射到指定图例名称，线宽设为 0.9。
        aes(y = TotalEpisodes, colour = "Total number of episodes"), linewidth = 0.9
    ) + # 结束第一条折线，继续叠加下一图层。
    geom_line( # 添加第二条折线，表示至少发病一次的儿童比例。
        # 将比例乘以 600 后放到左轴坐标中绘制，并为它设置另一项图例。
        aes(y = ProportionWithEpisode * axis_conversion, colour = "Proportion with episode"),
        linewidth = 1.3 # 比例折线稍粗，便于与总次数折线区分。
    ) + # 结束第二条折线。
    scale_colour_manual( # 手动指定两条折线的颜色和图例顺序。
        name = NULL, # 不额外显示颜色图例的总标题。
        values = c( # 用带名称的颜色向量，将图例名称与十六进制颜色值对应。
            "Proportion with episode" = "#0073C2", # 发病儿童比例用蓝色。
            "Total number of episodes" = "#EFC000" # 总发病次数用黄色。
        ), # 结束颜色对应表。
        # 在图例中先显示儿童比例，再显示发病总次数。
        breaks = c("Proportion with episode", "Total number of episodes")
    ) + # 结束颜色设置。
    # 横轴每两年显示一个主刻度，次刻度覆盖全部研究年份。
    scale_x_continuous(breaks = seq(2006, 2018, 2), minor_breaks = years) +
    scale_y_continuous( # 设置左侧纵轴，并通过坐标变换生成右侧纵轴。
        name = "Total number of episodes", # 左轴标题表示总发病次数。
        breaks = seq(100, 500, 100), # 左轴主刻度依次为 100、200、300、400、500。
        sec.axis = sec_axis( # 定义右侧的第二纵轴。
            ~ . / axis_conversion, # . 代表左轴数值，将其除以 600 还原为实际比例。
            name = "Proportion of individuals with episodes", # 设置右轴的标题。
            breaks = c(0.25, 0.50, 0.75) # 右轴显示 25%、50%、75% 对应的小数刻度。
        ) # 结束右轴定义。
    ) + # 结束纵轴设置。
    coord_cartesian(ylim = c(75, 535)) + # 设置纵向观察范围，仍保留默认留白，不删除原始记录。
    labs(x = "Year") + # 设置横轴标题为 Year。
    paper_theme # 应用前面定义的统一主题，并结束图 1A 的构建。

# 4. 绘制图 1B 和 1C：不同发病分组对总发病次数的贡献 ----
# 一名儿童一年发病 4 次，会给“3+”组贡献 4 次，而不是贡献 1 人。
# 图 1C 的百分比也按发病次数计算，不是各组儿童占全体儿童的比例。
# 给 1 次、2 次、3+ 次三个组分别指定紫色、青绿色、黄色。
group_colours <- c("1" = "#440154", "2" = "#21908C", "3+" = "#FDE725")
figure_1b <- ggplot( # 开始构建图 1B 的堆叠柱状图。
    # 用分组汇总表绘图：横轴是年份，纵轴是发病次数，柱子填充颜色区分发病分组。
    episode_distribution, aes(x = Year, y = Episodes, fill = EpisodeGroup)
) + # 结束基础映射，继续添加柱状图层。
    geom_col(width = 0.7) + # 直接以汇总好的数值作为柱高，同一年不同分组默认堆叠。
    # 设置填充图例标题和颜色；drop=FALSE 保留因子中定义的全部分组。
    scale_fill_manual(name = "# episodes", values = group_colours, drop = FALSE) +
    # 每年显示一个横轴主刻度，每半年的位置设置次刻度。
    scale_x_continuous(breaks = years, minor_breaks = seq(2006, 2018, 0.5)) +
    scale_y_continuous(breaks = c(0, 200, 400)) + # 设置纵轴显示的主刻度。
    labs(x = "Year", y = "Total number of episodes") + # 设置横轴和纵轴标题。
    paper_theme # 应用统一主题，完成图 1B。

figure_1c <- ggplot( # 开始构建图 1C 的百分比堆叠柱状图。
    # 这里纵轴改用预先算好的 EpisodeShare，每年的三个分组比例之和为 1。
    episode_distribution, aes(x = Year, y = EpisodeShare, fill = EpisodeGroup)
) + # 结束基础映射，继续添加图层。
    geom_col(width = 0.7) + # 将三个分组的比例堆叠，每年的总柱高都是 100%。
    # 沿用图 1B 的分组颜色和图例设置，方便对照。
    scale_fill_manual(name = "# episodes", values = group_colours, drop = FALSE) +
    # 横轴同样逐年标注，每半年的位置设置次刻度。
    scale_x_continuous(breaks = years, minor_breaks = seq(2006, 2018, 0.5)) +
    scale_y_continuous( # 设置比例纵轴的刻度和显示格式。
        breaks = seq(0, 1, 0.25), # 从 0 到 1，每隔 0.25 显示一个刻度。
        labels = function(x) paste0(round(100 * x), "%") # 将 0.25 这样的数显示成 25%。
    ) + # 结束比例纵轴设置。
    labs(x = "Year", y = "Episode distribution") + # 设置横轴年份和纵轴发病次数分布的标题。
    paper_theme # 应用统一主题，完成图 1C。

# 用 patchwork 包的 wrap_plots() 将 A、B、C 三张图按一列排列。
figure_1 <- patchwork::wrap_plots(figure_1a, figure_1b, figure_1c, ncol = 1) +
    patchwork::plot_annotation( # 为拼接后的整张图添加编号和说明。
        tag_levels = "A", # 自动使用 A、B、C 等大写字母为子图编号。
        caption = figure_note, # 在整张图底部添加数据来源说明。
        theme = theme(plot.caption = element_text(size = 10, hjust = 0)) # 图注字号为 10，左对齐。
    ) # 完成三联图 figure_1。

# 5. 保存图片、PDF，以及绘图使用的数值汇总表 ----
save_figure <- function(plot, name, width, height, suffix) { # 定义可复用的保存函数，接收五个参数。
    for (extension in c("png", "pdf")) { # 循环两次，同一张图分别保存为 PNG 和 PDF。
        filename <- paste0(name, "_", suffix, ".", extension) # 组合图名、文件名后缀和扩展名。
        ggsave( # 调用 ggplot2 的图片保存函数。
            filename = file.path(output_dir, filename), plot = plot, # 指定完整保存路径和要保存的图。
            # 宽高使用英寸；PNG 分辨率为每英寸 180 点，背景设为白色。
            width = width, height = height, units = "in", dpi = 180, bg = "white"
        ) # 结束这一次文件保存。
    } # 结束格式循环，此时 PNG 和 PDF 都已保存。
    return(invisible(NULL)) # 函数返回 NULL，但不在控制台额外打印返回值。
} # 完成 save_figure() 函数定义。

# 保存完整图 1，宽 8.2 英寸、高 14.5 英寸，并使用统一的文件名后缀。
save_figure(figure_1, "figure_1", width = 8.2, height = 14.5, suffix = output_suffix)
save_figure( # 另外保存一份独立的图 1A，便于单独查看。
    figure_1a + labs(tag = "A", caption = figure_note), # 给独立图加上 A 编号和数据来源说明。
    "figure_1A", width = 8.2, height = 5, suffix = output_suffix # 设置文件名、宽高和统一后缀。
) # 完成图 1A 的 PNG、PDF 保存。
write.csv( # 将年度汇总表导出为 CSV 文件。
    # 保存 annual 表，文件名为 annual_summary_recreated.csv。
    annual, file.path(output_dir, paste0("annual_summary_", output_suffix, ".csv")),
    row.names = FALSE # 不额外把 R 的行编号写成 CSV 的第一列。
) # 完成年度汇总表导出。
write.csv( # 将各年各发病分组的次数和占比导出。
    episode_distribution, # 指定要保存的数据框。
    # 生成分组汇总表的完整保存路径。
    file.path(output_dir, paste0("episode_distribution_", output_suffix, ".csv")),
    row.names = FALSE # 不导出自动行编号。
) # 完成分组汇总表导出。

# 6. 按补充代码绘制图 3：不同出生年份儿童的累计发病轨迹 ----
supplement_note <- "Recreated from original data following SupplementaryInfo.html." # 标注代码来源。
history <- episodes[episodes$BirthYear %in% 2007:2012, ] # 和作者一样，只展示六个出生年份。
high_transmission <- data.frame( # 定义作者用来突出高传播年份的两个橙色区间。
    start = c(2013, 2017), end = c(2014, 2018), group = c(1, 2) # 保留补充代码的区间端点。
) # 完成区间表；后面在每一个出生年份面板中重复绘制。
figure_3 <- ggplot( # 开始绘制每名儿童的累计发病轨迹。
    # group 按儿童编号分线，防止不同儿童之间被错误连接；颜色由基因型决定。
    history, aes(x = Year, y = CumEpisodes, group = Participant.ID, colour = Genotype)
) + # 完成轨迹的基础映射。
    geom_line() + # 连接同一个儿童在不同年份的观测，不人为补全缺失年份。
    facet_wrap(~BirthYear, labeller = label_both, ncol = 3) + # 六个出生年份按三列、两行排列。
    scale_x_continuous(breaks = seq(2007, 2018, 2)) + # 使用作者代码的两年刻度间隔。
    scale_colour_manual(values = c("AA" = "#3B4992", "AS" = "#EE0000")) + # 对应 AAAS 配色。
    geom_rect( # 按作者的图层顺序，在轨迹上叠加透明的橙色区域。
        data = high_transmission, inherit.aes = FALSE, # 使用区间表，不继承儿童轨迹的映射。
        aes(xmin = start, xmax = end, group = group), # 指定每个矩形的左右边界和分组。
        ymin = 0, ymax = max(episodes$CumEpisodes), # 高度取完整数据的最大累计次数，与作者一致。
        colour = "transparent", fill = "orange", alpha = 0.1 # 不显示边框，并设置较低的不透明度。
    ) + # 完成高传播区间的标注。
    labs(x = "Year", y = "Cumulative episodes", caption = supplement_note) + # 设置轴名和来源。
    paper_theme + # 使用已有的统一主题。
    theme(legend.position = "right") # 与补充材料一样将基因型图例放在右侧。
save_figure(figure_3, "figure_3", width = 10.8, height = 6.3, suffix = output_suffix) # 保存两种格式。

# 7. 按补充代码绘制图 4：年龄分布与既往发病次数分布，共两个面板 ----
clinical_colours <- c("no" = "#0073C2", "yes" = "#EFC000") # 使用作者 JCO 配色的前两种颜色。
status_counts <- table(episodes$GotEpisode) # 面板 A 包含全部儿童年度记录，包括 AA 和 AS。
status_labels <- paste0(names(status_counts), "\n(N = ", status_counts, ")") # 横轴标签显示样本量。
names(status_labels) <- names(status_counts) # 将每个标签绑定到对应的 no 或 yes。
aa_episodes <- episodes[episodes$Genotype == "AA", ] # 面板 B 和图 5 排除 AS，仅保留 AA。
aa_counts <- table(aa_episodes$GotEpisode) # 单独计算 AA 数据中未发病和发病的记录数。
aa_labels <- paste0(names(aa_counts), "\n(N = ", aa_counts, ")") # 生成面板 B 的样本量标签。
names(aa_labels) <- names(aa_counts) # 确保标签和发病状态正确对应。
figure_4a <- ggplot( # 面板 A：按当年是否发病，比较儿童的年龄分布。
    episodes, aes(x = GotEpisode, y = Age, fill = GotEpisode) # 使用全部基因型的记录。
) + # 完成面板 A 的基础映射。
    geom_violin(width = 0.6) + # 小提琴的宽度表示年龄分布的密度。
    # 按作者代码叠加黑色箱体、白色边线；隐藏单独的离群点符号。
    geom_boxplot(width = 0.15, outlier.shape = NA, colour = "white", fill = "black") +
    scale_y_continuous(breaks = seq(2, 15, 2)) + # 年龄轴每两岁标注一个刻度。
    scale_x_discrete(labels = status_labels) + # 横轴显示 no/yes 及各自的记录数。
    scale_fill_manual(values = clinical_colours) + # 未发病用蓝色，发病用黄色。
    labs(x = "Clinical episode", y = "Age [years]", tag = "A") + # 设置轴名和面板编号。
    paper_theme + # 应用统一主题。
    theme(legend.position = "none") # 横轴已经显示分组，因此不重复显示图例。
figure_4b <- ggplot( # 面板 B：在 AA 儿童中比较既往发病次数。
    aa_episodes, aes(x = GotEpisode, y = PrevEpisodes, fill = GotEpisode) # 使用既往次数，不含当年。
) + # 完成面板 B 的基础映射。
    geom_violin(width = 0.9) + # 保留补充代码为此面板设置的小提琴宽度。
    geom_boxplot(width = 0.1, outlier.shape = NA, colour = "white", fill = "black") + # 叠加箱线图。
    scale_x_discrete(labels = aa_labels) + # 使用仅 AA 记录的样本量标签。
    scale_fill_manual(values = clinical_colours) + # 保持两面板的颜色含义一致。
    labs(x = "Clinical episode", y = "Previous epsisodes", tag = "B") + # 保留作者原始轴标签。
    paper_theme + # 应用统一主题。
    theme(legend.position = "none") # 隐藏重复图例。
figure_4 <- patchwork::wrap_plots(figure_4a, figure_4b, nrow = 1) + # 按补充代码将两面板左右排列。
    patchwork::plot_annotation( # 为整张图添加数据与代码来源。
        caption = supplement_note, # 说明这是依据补充代码进行的复现。
        theme = theme(plot.caption = element_text(size = 9, hjust = 0)) # 图注左对齐。
    ) # 完成图 4 的拼接。
save_figure(figure_4, "figure_4", width = 9, height = 6, suffix = output_suffix) # 保存图 4。

# 8. 按补充代码绘制图 5：只用 AA，纵轴明确采用 PrevEpisodes / Age ----
aa_episodes$AgePanel <- factor( # 建立年龄面板标签，避免按字符串排序把 10 岁排在 2 岁之前。
    paste(aa_episodes$Age, "years"), levels = paste(1:12, "years") # 固定面板顺序为 1—12 岁。
) # 完成年龄标签转换。
figure_5 <- ggplot( # 按作者代码直接在 aes() 中计算既往次数与年龄的比值。
    aa_episodes, aes(x = GotEpisode, y = PrevEpisodes / Age, fill = GotEpisode) # 保持除以年龄的定义。
) + # 完成图 5 的基础映射。
    geom_boxplot(outlier.shape = NA) + # 箱体显示四分位数，不重复绘制离群点符号。
    geom_point( # 下一层绘制所有记录，包括箱线图定义的离群观测。
        position = position_jitter(width = 0.05, height = 0, seed = 16524), # 固定水平抖动以便重现。
        size = 0.25 # 使用补充代码中的散点大小；纵向抖动为零，保持比值不变。
    ) + # 完成散点层。
    facet_wrap(~AgePanel, ncol = 4) + # 分成十二个年龄面板，按四列、三行排列。
    scale_fill_manual(values = clinical_colours) + # no/yes 的颜色与图 4 一致。
    labs( # 保留作者代码的轴标题，同时在图注中明确实际纵轴的计算式。
        x = "Clinical episode", y = "Previous number of epsisodes", # 作者原始文字包含拼写错误。
        caption = paste(supplement_note, "Y = PrevEpisodes / Age.", sep = "\n") # 避免误读成原始次数。
    ) + # 完成轴标签与图注。
    paper_theme + # 使用统一主题。
    theme(legend.position = "none") # 横轴已表示 no/yes，无需额外图例。
save_figure(figure_5, "figure_5", width = 9, height = 9, suffix = output_suffix) # 保存图 5。

# 9. 按补充代码绘制图 6A：六岁儿童的累计发病次数与出生季度 ----
age_six <- episodes[episodes$Age == 6, ] # 筛选年龄恰好为六岁的记录，保留全部列。
if (nrow(age_six) == 0L) { # 检查是否完全没有符合条件的儿童。
    stop("There are no children aged exactly six for Figure 6A.") # 没有样本就报错停止。
} # 结束六岁样本是否存在的检查。
quarter_counts <- table(age_six$BirthQuarter) # 统计四个出生季度分别有多少条六岁儿童记录。
# 为横轴生成包含样本量的两行标签，例如 Q1 换行后显示 (n=97)。
quarter_labels <- paste0(names(quarter_counts), "\n(n=", quarter_counts, ")")
names(quarter_labels) <- names(quarter_counts) # 用 Q1—Q4 给标签命名，确保与对应季度匹配。

figure_6a <- ggplot( # 开始创建出生季度与累计发病次数的图。
    # 横轴映射出生季度，纵轴映射累计次数，箱体的填充颜色也由出生季度决定。
    age_six, aes(x = BirthQuarter, y = CumEpisodes, fill = BirthQuarter)
) + # 结束基础映射，开始添加箱线图层。
    # 箱体展示中位数和四分位数；隐藏单独的离群点符号，因为下一层会绘制所有观测点。
    geom_boxplot(width = 0.5, outlier.shape = NA, alpha = 0.75) +
    geom_point( # 将每名六岁儿童的真实累计次数绘制成黑色散点。
        # 仅在水平方向轻微抖动，减少点重叠；height=0 保持纵轴值不变，seed 固定结果。
        position = position_jitter(width = 0.05, height = 0, seed = 16524),
        size = 0.7 # 使用补充代码的散点大小。
    ) + # 完成散点层，继续设置颜色和坐标轴。
    # 按 Q1、Q2、Q3、Q4 的顺序为箱体设置蓝、橙、绿、红四种颜色。
    scale_fill_manual(values = c("#1F77B4", "#FF7F0E", "#2CA02C", "#D62728")) +
    scale_x_discrete(labels = quarter_labels) + # 横轴使用带样本量的季度标签。
    scale_y_continuous(breaks = seq(0, 25, 5)) + # 纵轴每隔 5 次发病设置一个候选刻度。
    labs( # 设置这张图的标题文字信息。
        x = "Birth quarter", y = "Cumulative episodes", tag = "A", # 设置两轴标题和子图编号。
        caption = supplement_note # 在底部说明数据与补充代码来源。
    ) + # 完成标签设置。
    paper_theme + # 应用与图 1 相同的主题。
    theme(legend.position = "none") # 横轴已说明季度，所以隐藏重复的颜色图例。
# 保存独立的图 6A，宽 8.2 英寸、高 5.8 英寸。
save_figure(figure_6a, "figure_6A", width = 8.2, height = 5.8, suffix = output_suffix)
# 按出生季度分组，计算六岁儿童累计发病次数的中位数。
birth_quarter_medians <- aggregate(CumEpisodes ~ BirthQuarter, age_six, median)
write.csv( # 将四个季度的中位数结果保存为 CSV。
    birth_quarter_medians, # 指定需要导出的季度中位数表。
    file.path(output_dir, "birth_quarter_medians_recreated.csv"), # 指定完整保存路径。
    row.names = FALSE # 不在文件中加入自动行编号。
) # 完成季度中位数表的保存。
print(birth_quarter_medians, row.names = FALSE) # 在控制台打印中位数表，不显示行编号。

# 10. 按补充代码绘制图 6B：每两岁一组，比较 Q4 与 Q1—Q3 的发病风险 ----
# 作者使用 epitools::riskratio()，默认是 Wald 法；下面用基础 R 写出同一计算公式。
# 这里按儿童年度记录计数，与作者一致，不把跨年份的同一儿童合并为一条记录。
risk_rows <- vector("list", 6) # 创建列表，用来保存六个年龄组的风险比结果。
for (i in seq_len(6)) { # 依次处理 1—2、3—4、5—6、7—8、9—10、11—12 岁。
    age_lower <- 2 * i - 1 # 当前年龄组的下界，用于显示标签。
    age_upper <- 2 * i # 当前年龄组的上界，也用于数据筛选。
    age_data <- episodes[episodes$Age > 2 * (i - 1) & episodes$Age <= age_upper, ] # 对齐作者区间。
    is_q4 <- age_data$BirthQuarter == "Q4" # 标记当前年龄组中第四季度出生的记录。
    q4_total <- sum(is_q4) # Q4 组的全部记录数，作为该组发病风险的分母。
    q4_cases <- sum(age_data$GotEpisode[is_q4] == "yes") # Q4 组中当年至少发病一次的记录数。
    other_total <- sum(!is_q4) # Q1—Q3 作为参照组，计算其总记录数。
    other_cases <- sum(age_data$GotEpisode[!is_q4] == "yes") # 参照组中当年至少发病一次的记录数。
    if (any(c(q4_total, q4_cases, other_total, other_cases) == 0)) { # 对数公式需要正的计数。
        stop("The supplementary Wald calculation requires non-zero counts in every age group.")
    } # 当前原始数据的六个年龄组都满足此条件，不需要连续性校正。
    risk_ratio <- (q4_cases / q4_total) / (other_cases / other_total) # Q4 风险除以参照组风险。
    # 按作者默认的 Wald 法计算 log(RR) 的标准误。
    log_se <- sqrt(1 / q4_cases - 1 / q4_total + 1 / other_cases - 1 / other_total)
    # 在对数尺度上取正负 1.96 个标准误，再用 exp() 换回风险比尺度。
    interval <- exp(log(risk_ratio) + c(-1, 1) * qnorm(0.975) * log_se)
    risk_rows[[i]] <- data.frame( # 保存分子、分母、风险比和区间，便于核对。
        AgeGroup = paste0(age_lower, "-", age_upper), # 用 1-2 等标签表示当前年龄组。
        Q4Cases = q4_cases, Q4Total = q4_total, # 第四季度出生组的发病记录数及总数。
        OtherCases = other_cases, OtherTotal = other_total, # 第一至第三季度参照组的对应计数。
        RR = risk_ratio, Lower95 = interval[1], Upper95 = interval[2] # 保存估计值和 95% 区间。
    ) # 完成当前年龄组的一行结果。
} # 六个年龄组全部计算完毕。
risk_by_age <- do.call(rbind, risk_rows) # 将六个数据框按行合并为一张汇总表。
risk_by_age$AgeGroup <- factor( # 把年龄组变成因子，以保持自然年龄顺序。
    risk_by_age$AgeGroup, levels = risk_by_age$AgeGroup # 使用表中现有的六组顺序。
) # 完成年龄组因子转换。
figure_6b <- ggplot(risk_by_age, aes(x = AgeGroup, y = RR)) + # 横轴为年龄组，纵轴为风险比。
    # RR=1 的蓝色虚线表示两组的发病风险相同。
    geom_hline(yintercept = 1, linetype = 2, linewidth = 0.25, colour = "darkblue") +
    geom_errorbar(aes(ymin = Lower95, ymax = Upper95), width = 0.2) + # 绘制作者方法的 95% 区间。
    geom_point(colour = "red") + # 用红点表示每个年龄组的风险比点估计。
    labs( # 设置图 6B 的坐标轴、面板编号和来源说明。
        x = "Age group [years]", y = "Risk ratio (Q4)", tag = "B", # 保持作者轴标签。
        caption = supplement_note # 标注采用原始数据和补充代码的方法。
    ) + # 完成标签设置。
    paper_theme # 应用统一主题。
save_figure(figure_6b, "figure_6B", width = 8.2, height = 5.8, suffix = output_suffix) # 单独保存 B。
figure_6 <- patchwork::wrap_plots( # 另外把图 6A 与图 6B 按作者方式上下拼接。
    figure_6a + labs(caption = NULL), figure_6b + labs(caption = NULL), ncol = 1 # 移除重复图注。
) + # 拼图后统一添加来源说明。
    patchwork::plot_annotation( # 为完整图 6 添加图注。
        caption = supplement_note, # 数据来源与两个面板一致。
        theme = theme(plot.caption = element_text(size = 9, hjust = 0)) # 图注左对齐。
    ) # 完成图 6 的拼接。
save_figure(figure_6, "figure_6", width = 8.2, height = 12, suffix = output_suffix) # 保存完整图 6。
write.csv( # 导出图 6B 的精确数值及计数，方便复核每个风险比。
    risk_by_age, file.path(output_dir, "risk_ratio_by_age_recreated.csv"), # 指定输出表和路径。
    row.names = FALSE # 不写入自动行编号。
) # 完成风险比表的导出。
print(risk_by_age, row.names = FALSE, digits = 4) # 在控制台显示六个年龄组的风险比和置信区间。

print(annual, row.names = FALSE, digits = 4) # 打印年度汇总表；digits 控制显示精度，不修改实际数值。
message("Saved plots and summary tables in: ", output_dir) # 提示所有结果保存在哪个目录。
if (interactive()) { # 只在 R 控制台或 RStudio 等交互会话中显示图，而非普通 Rscript 运行。
    print(figure_1) # 将完整图 1 显示在绘图窗口或 RStudio 的 Plots 面板中。
} # 结束交互显示判断，整份脚本运行完毕。
