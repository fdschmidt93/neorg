--[[
    UI GTD components

REQUIRES:
    - core.ui                       to use ui stuff
    - core.norg.dirman              for file operations
    - core.gtd.queries              to use gtd queries

SUBMODULES:
    * DISPLAYERS:
        UI components to display gtd's useful data
        - display_today_tasks
        - display_waiting_for
        - display_contexts
        - display_projects

    * HELPERS:
        Some helpers...

    * SELECTION_POPUPS:
        UI components that use selection popups
        - show_views_popup
        - edit_task

--]]

require("neorg.modules.base")

local module = neorg.modules.create("core.gtd.ui")

module.load = function()
    module.required["core.keybinds"].register_keybinds(module.name, { "goto_task", "close", "edit_task", "details" })
end

module.setup = function()
    return {
        success = true,
        requires = {
            "core.ui",
            "core.keybinds",
            "core.norg.dirman",
            "core.gtd.queries",
            "core.integrations.treesitter",
            "core.mode",
        },
        imports = {
            "displayers",
            "helpers",
            "views_popup_helpers",
            "edit_popup_helpers",
            "selection_popups",
        },
    }
end

module.on_event = function(event)
    if event.split_type[1] == "core.keybinds" then
        if event.split_type[2] == "core.gtd.ui.goto_task" then
            module.public.goto_task()
        elseif event.split_type[2] == "core.gtd.ui.close" then
            module.public.close_buffer()
        elseif event.split_type[2] == "core.gtd.ui.edit_task" then
            local task = module.public.get_task_by_var()
            module.public.close_buffer()
            task = module.public.refetch_task_not_extracted({ task.node, task.bufnr })
            module.public.edit_task(task)
        elseif event.split_type[2] == "core.gtd.ui.details" then
            module.public.toggle_details()
        end
    end
end

module.events.subscribed = {
    ["core.keybinds"] = {
        ["core.gtd.ui.goto_task"] = true,
        ["core.gtd.ui.close"] = true,
        ["core.gtd.ui.edit_task"] = true,
        ["core.gtd.ui.details"] = true,
    },
}

return module