return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#101418',
				base01 = '#101418',
				base02 = '#2e2e2e',
				base03 = '#2e2e2e',
				base04 = '#1a1a1a',
				base05 = '#1a1a1a',
				base06 = '#1a1a1a',
				base07 = '#1a1a1a',
				base08 = '#a52021',
				base09 = '#a52021',
				base0A = '#0782fb',
				base0B = '#178c13',
				base0C = '#595cff',
				base0D = '#0782fb',
				base0E = '#3fc1ff',
				base0F = '#3fc1ff',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#2e2e2e',
				fg = '#1a1a1a',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#0782fb',
				fg = '#101418',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#2e2e2e' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#595cff', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#3fc1ff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#0782fb',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#0782fb',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#595cff',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#178c13',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#1a1a1a' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#1a1a1a' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#2e2e2e',
				italic = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
