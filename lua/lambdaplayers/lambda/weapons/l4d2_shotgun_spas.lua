local IsValid = IsValid
local ipairs = ipairs

local fireDamageTbl = { 9, 11 }
local fireRateTbl = { 0.35, 0.5 }
local deploySnds = {
    { 0, "lambdaplayers/weapons/l4d2/shotgun_spas/gunother/autoshotgun_deploy_1.mp3" },
    { 0.33, "lambdaplayers/weapons/l4d2/shotgun_spas/gunother/autoshotgun_boltback.mp3" },
    { 0.66, "lambdaplayers/weapons/l4d2/shotgun_spas/gunother/autoshotgun_boltforward.mp3" }
}
local reloadSnds = {
    { 0.74, "lambdaplayers/weapons/l4d2/shotgun_spas/gunother/auto_shotgun_load_shell_2.mp3" },
    { 1.03, "lambdaplayers/weapons/l4d2/shotgun_spas/gunother/auto_shotgun_load_shell_4.mp3" },
    { 2.11, "lambdaplayers/weapons/l4d2/shotgun_spas/gunother/autoshotgun_boltback.mp3" },
    { 2.29, "lambdaplayers/weapons/l4d2/shotgun_spas/gunother/autoshotgun_boltforward.mp3" }
}

table.Merge( _LAMBDAPLAYERSWEAPONS, {
    l4d2_shotgun_spas = {
        model = "models/lambdaplayers/weapons/l4d2/w_shotgun_spas.mdl",
        origin = "Left 4 Dead 2",
        prettyname = "Combat Shotgun",
        holdtype = "shotgun",
        killicon = "lambdaplayers/killicons/icon_l4d2_shotgun_spas",
        bonemerge = true,

        clip = 10,
        islethal = true,
        attackrange = 800,
        keepdistance = 400,
        reloadtime = 3.1,

        OnReload = function( self, wepent )
            local animID = self:LookupSequence( "reload_shotgun_base_layer" )
            local reloadLayer = ( animID != -1 and self:AddGestureSequence( animID ) or self:AddGesture( ACT_HL2MP_GESTURE_RELOAD_SHOTGUN ) )
            self:SetLayerPlaybackRate( reloadLayer, 0.9 )

            for _, v in ipairs( reloadSnds ) do
                self:SimpleTimer( v[ 1 ], function()
                    if !IsValid( wepent ) or self:GetWeaponName() != "l4d2_shotgun_spas" then return end
                    wepent:EmitSound( v[ 2 ], 65, 100, 1, CHAN_ITEM )
                end )
            end
        end,

        OnEquip = function( self, wepent )
            wepent.L4D2Data = {}
            wepent.L4D2Data.Damage = fireDamageTbl
            wepent.L4D2Data.Spread = 0.15
            wepent.L4D2Data.Sound = "lambdaplayers/weapons/l4d2/shotgun_spas/gunfire/auto_shotgun_fire_1.mp3"
            wepent.L4D2Data.RateOfFire = fireRateTbl
            wepent.L4D2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
            wepent.L4D2Data.EjectShell = "ShotgunShellEject"
            wepent.L4D2Data.Pellets = 9
            wepent.L4D2Data.CrouchedSpreadScale = 0.8
            wepent.L4D2Data.DeploySound = deploySnds

            LAMBDA_L4D2:InitializeWeapon( self, wepent )
        end,

        callback = function( self, wepent, target )
            LAMBDA_L4D2:FireWeapon( self, wepent, target )
            return true
        end
    }
} )