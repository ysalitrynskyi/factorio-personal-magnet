data:extend({
  {
    type = "capsule",
    name = "personal-magnet",
    icon = "__PersonalMagnet__/graphics/personal-magnet.png",
    icon_size = 64,
    subgroup = "tool",
    order = "z[magnet]",
    stack_size = 500, -- ✅ set high stack size
    capsule_action = {
      type = "use-on-self",
      attack_parameters = {
        type = "projectile",
        ammo_category = "capsule",
        cooldown = 30,
        range = 0,
        ammo_type = {
          category = "capsule",
          target_type = "position",
          consume = false,
          action = {
            type = "direct",
            action_delivery = {
              type = "instant",
              target_effects = {
                type = "script",
                effect_id = "personal-magnet-use"
              }
            }
          }
        }
      }
    }
  },
  {
    type = "recipe",
    name = "personal-magnet",
    enabled = true,
    energy_required = 0.5,
    ingredients = {
      { type = "item", name = "iron-plate", amount = 10 },
      { type = "item", name = "electronic-circuit", amount = 5 }
    },
    results = {
      { type = "item", name = "personal-magnet", amount = 1 }
    },
    main_product = "personal-magnet"
  }
})
