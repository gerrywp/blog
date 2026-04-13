# 使用githubpages部署
- 不需要上传public文件夹到仓库
- 不需要上传themes文件夹到仓库（可选）
- 项目使用了github子模块，直接运行如下命令即可
  ```bash
  #方式1
  git clone https://github.com/xxx/xxx.git
  cd xxx
  git submodule update --init --recursive
  hugo server
  #方式2，省事
  git clone --recurse-submodules https://github.com/xxx/xxx.git
  ```
- 在项目根目录创建`.nojekyll`文件，告诉 GitHub Pages：我不是 Jekyll 项目，别处理我。
- 在本地项目创建正确的 GitHub Actions 配置`.github/workflows/hugo.yml`（Hugo 专用）
- github如果deploy成功会在当前项目生成gh-pages分支

# 设置仓库的page页
1. 打开你的博客仓库 → 点上方 Settings
2. 左边找到 Pages（拉下来一点就能看到）
3. 看到 Build and deployment
4. Source 选：Deploy from a branch
5. Branch 选：gh-pages + /(root)
6. 点 Save
