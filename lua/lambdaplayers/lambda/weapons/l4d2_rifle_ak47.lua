local fireDamageTbl = { 18, 21 }
local deploySnds = {
    { 0, "lambdaplayers/weapons/l4d2/rifle_ak47/gunother/rifle_deploy_1.mp3" },
    { 0.366, "lambdaplayers/weapons/l4d2/rifle_ak47/gunother/rifle_slideback.mp3" },
    { 0.7, "lambdaplayers/weapons/l4d2/rifle_ak47/gunother/rifle_slideforward.mp3" }
}

table.Merge( _LAMBDAPLAYERSWEAPONS, {
    l4d2_rifle_ak47 = {
        model = "models/lambdaplayers/weapons/l4d2/w_rifle_ak47.mdl",
        origin = "Left 4 Dead 2",
        prettyname = "AK-47",
        holdtype = "ar2",
        killicon = "lambdaplayers/killicons/icon_l4d2_rifle_ak47",
        bonemerge = true,

        clip = 40,
        islethal = true,
        attackrange = 1500,
        keepdistance = 400,

        reloadtime = 2.4,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        reloadanimspeed = 0.8,
        reloadsounds = { 
            { 0.5, "lambdaplayers/weapons/l4d2/rifle_ak47/gunother/rifle_clip_out_1.mp3" },
            { 1.0, "lambdaplayers/weapons/l4d2/rifle_ak47/gunother/rifle_clip_in_1.mp3" },
            { 1.2, "lambdaplayers/weapons/l4d2/rifle_ak47/gunother/rifle_clip_locked_1.mp3" },
            { 1.74, "lambdaplayers/weapons/l4d2/rifle_ak47/gunother/rifle_slideback.mp3" },
            { 1.9, "lambdaplayers/weapons/l4d2/rifle_ak47/gunother/rifle_slideforward.mp3" },
        },

        OnEquip = function( self, wepent )
            wepent.L4D2Data = {}
            wepent.L4D2Data.Damage = fireDamageTbl
            wepent.L4D2Data.Spread = 0.125
            wepent.L4D2Data.Sound = "lambdaplayers/weapons/l4d2/rifle_ak47/gunfire/rifle_fire_1.mp3"
            wepent.L4D2Data.RateOfFire = 0.13
            wepent.L4D2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
            wepent.L4D2Data.EjectShell = "RifleShellEject"
            wepent.L4D2Data.DeploySound = deploySnds

            LAMBDA_L4D2:InitializeWeapon( self, wepent )
        end,

        callback = function( self, wepent, target )
            LAMBDA_L4D2:FireWeapon( self, wepent, target )
            return true
        end
    }
} )