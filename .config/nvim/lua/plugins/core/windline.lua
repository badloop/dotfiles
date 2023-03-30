local default = {
    filetypes = { "default" },
    active = {},
    in_active = {},
}
return {
    "windwp/windline.nvim",
    enabled = false,
    config = {
        theme = require("wlsample.airline"),
        tabline = {},
        statuslines = {
            default,
        },
    },
}
