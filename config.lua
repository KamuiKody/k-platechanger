Config = {}

Config.UseTarget = GetConvar('UseTarget', 'false') == 'true'

Config.Owned = false -- if set to true you will not have to own the car to change plates
Config.UseItem = {
    ['owned'] = true, -- set to false to use in game cash
    ['unreg'] = false
}
Config.Cash = {
    ['owned'] = 10000,
    ['unreg'] = 10000
} -- set amount if using cash and not item
Config.Item = {
    ['owned'] = 'platecoin',
    ['unreg'] = 'platecoin'
} -- item taken when plate changer is used. if no item then set Config.UseItem to false
Config.Location = vector3(1174.61, 2640.69, 37.38)  -- 3dtext/polyzone location
Config.Radius = 5 -- how far from the location you can be to use it
Config.CarPos = vector4(1174.61, 2640.69, 37.38, 359.57) -- position the car tp's to when changing plate
Config.Length = 7 -- amount of characters on the plate 
Config.RestrictedWords = {
    --"f4660t" -- case shouldnt matter it should format both cases the same
}