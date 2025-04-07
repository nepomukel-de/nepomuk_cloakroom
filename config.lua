Config = {
  Locale = 'de', -- choose your language de/en
  DrawDistance = 10 -- the distance where the marker shoud be shown
}

Command = {
  Enabled = true, -- do you want to be able to open the outfits menu where you want? | true = yes / false = no
  Name = 'outfits' -- command name | exemple: /outfits
}

-- marker settings
Config.MarkerSize   = {x = 0.5, y = 0.5, z = 0.35}
Config.MarkerColor  = {r = 255, g = 255, b = 23}
Config.MarkerType   = 21

Config.Zones = { -- here you can add other outfit points
  vector3(71.5121, -1389.5583, 29.3822),
  vector3(-700.6980, -152.0623, 37.4152),
  vector3(-170.1371, -296.6112, 39.7333),
  vector3(429.4437, -809.5649, 29.4972),
  vector3(-821.3286, -1068.8766, 11.3342),
  vector3(-1446.4658, -245.8884, 49.8273),
  vector3(4.8435, 6507.2607, 31.8839),
  vector3(118.4321, -232.1607, 54.5578),
  vector3(1697.9048, 4819.9502, 42.0692),
  vector3(617.6024, 2773.3184, 42.0881),
  vector3(1200.1312, 2713.9788, 38.2287),
  vector3(-1182.2026, -765.1095, 17.3265),
  vector3(-3178.4387, 1035.8053, 20.8632),
  vector3(-1101.4990, 2715.4766, 19.1140)
}