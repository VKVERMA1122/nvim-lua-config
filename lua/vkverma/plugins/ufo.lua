function FoldCountDisplay()
	local foldCount = 0
	local lnum = vim.v.lnum

	-- Count lines in current fold
	for i = lnum, vim.fn.foldclosedend(lnum) do
		if i > lnum and vim.fn.foldclosed(i) > 0 then
			foldCount = foldCount + 1
		end
	end

	-- Only return count if fold exists
	if foldCount > 0 then
		return string.format(" 󰡵 %d lines", foldCount)
	end

	return ""
end

return {
	"kevinhwang91/nvim-ufo",
	dependencies = {
		"kevinhwang91/promise-async",
	},
	event = "BufRead ",
	config = function()
		require("ufo").setup({
			preview = {
				win_config = {
					border = { "", "─", "", "", "", "─", "", "" },
					winhighlight = "Normal:Folded",
				},
			},
			provider_selector = function(bufnr, filetype, buftype)
				return { "treesitter", "indent" }
			end,
			fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = ("... 󰁂 %d "):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0

				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)

					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						break
					end

					curWidth = curWidth + chunkWidth
				end

				table.insert(newVirtText, { suffix, "Comment" })

				return newVirtText
			end,
		})
		vim.keymap.set("n", "K", function()
			local winid = require("ufo").peekFoldedLinesUnderCursor()
			if not winid then
				vim.lsp.buf.hover()
			end
		end)
	end,
}
