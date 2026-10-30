# LEEZY MapCraft

**GIS 精细制图 · LEEZY Skills · 作者 [BigWai1312](https://github.com/BigWai1312)**

官方源地址：https://github.com/BigWai1312/leezy-skills/tree/main/skills/leezy-mapcraft

适用于 ArcGIS Pro 专题图、现有工程版式调整及离线手工制图教程。规范包含完整底图、地形晕渲、道路水系层级、指标配色、双列图例、经纬度图廓和可编辑交付；不会附带你的项目数据。

## 安装与调用

在 Codex 中发送：

```text
$skill-installer 从 BigWai1312/leezy-skills 安装 skills/leezy-mapcraft。
```

安装后调用：

```text
$leezy-mapcraft
根据 <数据目录> 制作一张 <指标名称> 专题图。
指标字段为 <字段>，单位为 <单位>，输出到 <输出目录>。
先检查数据并出一张样图，提供可编辑 APRX 和图片预览。
```

详细输入及参考输出见 [examples.md](examples.md)。需要执行制图时，还须提供 ArcPy 环境和数据连接字段；缺少实际数据时不编造空间分布或统计结论。

## 署名与水印

包内保留作者和来源声明，见 [NOTICE.md](NOTICE.md) 及 [LICENSE](LICENSE)。用户地图默认不加品牌水印。需要署名版预览时，可在任务中要求：

```text
在预览图空白角落加入可编辑的署名：
LEEZY MapCraft | BigWai1312 | github.com/BigWai1312/leezy-skills
不要遮挡图例、比例尺或地理要素。
```

仅有技能规范不等于已经完成制图；实际制图需要 ArcGIS Pro、有效许可、可用的本地执行工具及数据。版本：1.0.0。当前调用名为 `$leezy-mapcraft`，旧调用 `$arcgis-map-craft` 不会自动指向新版。

---

LEEZY MapCraft · BigWai1312 · https://github.com/BigWai1312/leezy-skills
