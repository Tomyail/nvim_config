local status_ok, yanky = pcall(require, "yanky")
if not status_ok then
	return
end

yanky.setup({
  --[[ Yank-ring 允许在放置文本时循环遍历 yank 历史记录（类似于 Emacs 的“kill-ring”功能）。 Yanky 会自动维护您可以在粘贴时选择的 yanks 历史记录。使用这些映射，在执行粘贴后，您可以通过点击 <c-n> 和 <c-p> 循环浏览历史记录。粘贴后所做的任何修改都将取消循环的可能性。 ]]
})
