local status_ok, configs = pcall(require, "neorg")
if not status_ok then
  return
end

configs.setup({
  load = {
    ["core.defaults"] = {},
    ["core.dirman"] = {
      config = {
        workspaces = {
          work = "~/notes/work",
          personal = "~/notes/gomes",
        },
        index = "index.norg",
        default_workspace = "work",
        open_last_workspace = false,
      }
    },
    ["core.concealer"] = {
      config = {
        icon_present = "basic",
        adaptive = true,
        conceal = true,
        --content_only = true,
        padding = 10,
      }
    },
  },
})
