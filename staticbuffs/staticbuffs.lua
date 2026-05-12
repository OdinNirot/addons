_addon.name = 'staticbuffs'
_addon.author = 'Nirot'
_addon.version = '1.0'

require('tables')
texts = require('texts')
res = require('resources')

local tracked_spells = {
    Stoneskin = {
        buff = 'Stoneskin',
        duration = 300,
    },
    Phalanx = {
        buff = 'Phalanx',
        duration = 180,
    },
    Protect = {
        buff = 'Protect',
        duration = 2280,
    },
    Shell = {
        buff = 'Shell',
        duration = 2280,
    },
    Crusade = {
        buff = 'Enmity Boost',
        duration = 360,
    },
	
}

local active_buffs = {}

local ui = texts.new('', {
    pos = {
        x = 1630,
        y = 200
    },

    text = {
        font = 'Consolas',
        size = 12,
        stroke = {
            width = 2,
            alpha = 255,
            red = 0,
            green = 0,
            blue = 0,
        },
    },

    bg = {
        visible = false
    },

    flags = {
        right = false,
        bottom = false,
        bold = true,
    }
})

local function format_time(seconds)
    if seconds <= 0 then
        return '0:00'
    end

    local mins = math.floor(seconds / 60)
    local secs = math.floor(seconds % 60)

    return string.format('%d:%02d', mins, secs)
end

local function has_buff(buff_name)
    local player = windower.ffxi.get_player()

    if not player or not player.buffs then
        return false
    end

    for _, buff_id in ipairs(player.buffs) do
        local buff = res.buffs[buff_id]

        if buff and buff.en == buff_name then
            return true
        end
    end

    return false
end

local function update_display()
    local lines = {}

    for spell_name, info in pairs(tracked_spells) do
        local is_active = has_buff(info.buff)

        if is_active then
            if not active_buffs[spell_name] then
                active_buffs[spell_name] = os.time() + info.duration
            end
        else
            active_buffs[spell_name] = nil
        end

        local remaining = 0

        if active_buffs[spell_name] then
            remaining = active_buffs[spell_name] - os.time()

            if remaining < 0 then
                remaining = 0
            end
        end

        local color

        if is_active then
            color = '\\cs(0,255,0)'
        else
            color = '\\cs(255,0,0)'
        end

        local reset = '\\cr'

        table.insert(
            lines,
            string.format(
                '%s%-10s %8s%s',
                color,
                spell_name,
                format_time(remaining),
                reset
            )
        )
    end

    ui:text(table.concat(lines, '\n'))
end

windower.register_event('prerender', function()
    update_display()
end)

windower.register_event('action', function(act)
    local player = windower.ffxi.get_player()

    if not player then
        return
    end

    if act.actor_id ~= player.id then
        return
    end

    if act.category ~= 4 then
        return
    end

    local spell = res.spells[act.param]

    if not spell then
        return
    end

    local tracked = tracked_spells[spell.en]

    if tracked then
        active_buffs[spell.en] = os.time() + tracked.duration
    end
end)

windower.register_event('load', function()
    ui:show()
end)

windower.register_event('unload', function()
    ui:hide()
end)