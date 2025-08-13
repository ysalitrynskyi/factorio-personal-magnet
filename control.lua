local PICKUP_RADIUS = 15
local COLLECT_FROM_BELTS = true
local MINE_RESOURCES = true
local MINE_TREES = true
local MINE_OTHER_ENTITIES = true

local BELT_TYPES = {
  ["transport-belt"] = true,
  ["underground-belt"] = true,
  ["splitter"] = true,
  ["linked-belt"] = true
}

local function drain_line_into_player(line, player)
  local contents = line and line.get_contents()
  if not contents then return false, false end
  local any_collected, inventory_full = false, false

  if contents[1] == nil then
    for name, count in pairs(contents) do
      if type(count) == "number" and count > 0 then
        local inserted = player.insert{ name = name, count = count }
        if inserted > 0 then
          line.remove_item{ name = name, count = inserted }
          any_collected = true
          if inserted < count then inventory_full = true; break end
        else
          inventory_full = true; break
        end
      end
    end
  else
    for _, stack in ipairs(contents) do
      local name = stack.name
      local count = stack.count or 0
      if name and count > 0 then
        local inserted = player.insert{ name = name, count = count }
        if inserted > 0 then
          line.remove_item{ name = name, count = inserted }
          any_collected = true
          if inserted < count then inventory_full = true; break end
        else
          inventory_full = true; break end
      end
    end
  end

  return any_collected, inventory_full
end

local function on_personal_magnet_used(event)
  local player
  if event.source_entity and event.source_entity.valid and event.source_entity.type == "character" then
    player = event.source_entity.player
  else
    player = game.get_player(event.player_index)
  end
  if not (player and player.valid) then return end

  local surface = player.surface
  local p = player.position
  local area = {{p.x - PICKUP_RADIUS, p.y - PICKUP_RADIUS}, {p.x + PICKUP_RADIUS, p.y + PICKUP_RADIUS}}

  local items_collected = false
  local inventory_full = false

  -- 🧲 Ground items
  local ground = surface.find_entities_filtered{ area = area, type = "item-on-ground" }
  for _, e in ipairs(ground) do
    if e.valid then
      local stack = e.stack
      if stack and stack.valid_for_read and stack.name and stack.count > 0 then
        local inserted = player.insert{ name = stack.name, count = stack.count }
        if inserted > 0 then
          items_collected = true
          if inserted >= stack.count then
            e.destroy()
          else
            stack.count = stack.count - inserted
            inventory_full = true
          end
        else
          inventory_full = true
        end
      end
    end
  end

  -- 🧲 Belts
  if COLLECT_FROM_BELTS then
    local belts = surface.find_entities_filtered{
      area = area,
      type = {"transport-belt","underground-belt","splitter","linked-belt"}
    }
    for _, b in ipairs(belts) do
      if b.valid and BELT_TYPES[b.type] then
        for i = 1, b.get_max_transport_line_index() or 0 do
          local line = b.get_transport_line(i)
          local got, full = drain_line_into_player(line, player)
          if got then items_collected = true end
          if full then inventory_full = true end
        end
      end
    end
  end

  -- 🧲 Resource mining
  if MINE_RESOURCES then
    local resources = surface.find_entities_filtered{ area = area, type = "resource" }
    for _, r in ipairs(resources) do
      while r.valid do
        local ok = player.mine_entity(r, false)
        if not ok then
          inventory_full = true
          break
        else
          items_collected = true
        end
      end
    end
  end

  -- 🧲 Trees
  if MINE_TREES then
    local trees = surface.find_entities_filtered{ area = area, type = "tree" }
    for _, t in ipairs(trees) do
      while t.valid do
        local ok = player.mine_entity(t, false)
        if not ok then
          inventory_full = true
          break
        else
          items_collected = true
        end
      end
    end
  end

  -- 🧲 Special plants / blocks / modded trees
  if MINE_OTHER_ENTITIES then
    local specials = surface.find_entities_filtered{
      area = area,
      type = {"simple-entity", "decorative", "corpse", "cliff"}
    }
    for _, e in ipairs(specials) do
      if e.valid and e.minable and e.type ~= "container" and e.type ~= "logistic-container" then
        local ok = player.mine_entity(e, false)
        if ok then
          items_collected = true
        else
          inventory_full = true
        end
      end
    end
  end

  if inventory_full then
    player.print("[Personal Magnet] Inventory full!")
  end
  if items_collected then
    player.play_sound{ path = "utility/inventory_click" }
  end
end

script.on_event(defines.events.on_script_trigger_effect, function(event)
  if event.effect_id == "personal-magnet-use" then
    on_personal_magnet_used(event)
  end
end)
