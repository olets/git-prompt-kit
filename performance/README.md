# Performance

At last benchmark, Git Prompt Kit adds roughly 4ms of lag to the first prompt and to the first command when not customized, roughly 8ms lag to the first prompt and first command when fully customized, and under 1.5ms to the time it takes each prompt to appear.

Raw single-run data is available at <https://oletsdev.notion.site/4885a1a3749c45f3b6dbb1e2f924e47e?v=db09d78ce4474da5a6355964dda2bb7a>.

Run the performance suite (requires [zsh-bench](https://github.com/romkatv/zsh-bench)) with

```shell
zsh-bench --isolation docker --config-dir ./performance -- not-sourced sourced sourced-customized
```
