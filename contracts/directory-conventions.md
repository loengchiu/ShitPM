# Directory Conventions

工作项目默认产物目录：

```text
docs/
  briefs/
  diagrams/
  mindmaps/
  feature-lists/
  page-structures/
  prd/
  prototypes/
  prototype-annotations/
  reviews/
  review-meetings/
  wiki-sync/
```

其中图表目录约定：

```text
docs/
  diagrams/
    prd/
```

命名规则：

- 功能清单：`YYYY-MM-DD_feature-list-<topic>-vN.md`
- 页面清单：`YYYY-MM-DD_page-structure-<topic>-vN.md`
- PRD：`YYYY-MM-DD_prd-<topic>-vN.md`
- PRD 图表源文件：`docs/diagrams/prd/pNN-<topic>.drawio`
- PRD 图表预览文件：`docs/diagrams/prd/pNN-<topic>.svg`
- 原型：`YYYY-MM-DD_prototype-<topic>-<page>-vN.html`
- 注释原型：`YYYY-MM-DD_prototype-annotation-<topic>-<page>-vN.html`
- 视觉基线：`docs/prototypes/visual-baseline.md`（固定路径，不加日期和版本后缀，每个项目只有一个）
- 评审会记录：`docs/review-meetings/YYYY-MM-DD_review-<topic>.md`

说明：

- 当前稳定版本通过 `project-status.json` 维护
- 不以目录中“最新文件名”自动替代稳定锚点
