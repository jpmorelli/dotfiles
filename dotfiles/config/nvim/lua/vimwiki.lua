return {
    -- The plugin location on GitHub
    "vimwiki/vimwiki",
    -- The event that triggers the plugin
    event = "BufEnter *.md",
    -- The keys that trigger the plugin
    keys = { "<leader>ww", "<leader>wt" },
    -- The configuration for the plugin
    init = function()
    vim.g.vimwiki_list = {
        {
            -- Here will be the path for your wiki
            path = "~/Nextcloud/Notas",
            -- The syntax for the wiki
            syntax = "markdown",
            ext = "md",
        },
    }
    vim.g.vimwiki_ext2syntax = { }
    end,
}

Here we can see an important part of my own configuration. I set the syntax for the wiki to markdown, this is because I use Obsidian to manage my notes and I want to be able to use the same syntax for my notes. I also set the path for my wiki to ~/vimwiki/. This is the default path, but you can set it to any path you want.

With this minimal configuration, you can start using Vimwiki. To open the wiki, you can use the command :VimwikiIndex and to create a new wiki page, you can use the command :VimwikiMakeDiaryNote.

2024 - Fernando San Miguel
