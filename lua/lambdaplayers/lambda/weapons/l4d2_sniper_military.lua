local fireDamageTbl = { 26, 28 }
local fireRateTbl = { 0.275, 0.4 }

table.Merge( _LAMBDAPLAYERSWEAPONS, {
    l4d2_sniper_military = {
        model = "models/lambdaplayers/weapons/l4d2/w_sniper_military.mdl",
        origin = "Left 4 Dead 2",
        prettyname = "Military Rifle",
        holdtype = "ar2",
        killicon = "lambdaplayers/killicons/icon_l4d2_sniper_military",
        bonemerge = true,

        clip = 30,
        islethal = true,
        attackrange = 2500,
        keepdistance = 1000,

        reloadtime = 3.33,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        reloadanimspeed = 0.66,
        reloadsounds = { 
            { 0.33, "lambdaplayers/weapons/l4d2/sniper_military/gunother/sniper_military_slideback_1.mp3" },
            { 1.233, "lambdaplayers/weapons/l4d2/sniper_military/gunother/sniper_military_clip_out_1.mp3" },
            { 1.8, "lambdaplayers/weapons/l4d2/sniper_military/gunother/sniper_military_clip_in_1.mp3" },
            { 1.833, "lambdaplayers/weapons/l4d2/sniper_military/gunother/sniper_military_clip_locked_1.mp3" },
            { 2.533, "lambdaplayers/weapons/l4d2/sniper_military/gunother/sniper_military_slideforward_1.mp3" }
        },

        OnEquip = function( self, wepent )
            wepent.L4D2Data = {}
            wepent.L4D2Data.Damage = fireDamageTbl
            wepent.L4D2Data.Spread = 0.075
            wepent.L4D2Data.Sound = "lambdaplayers/weapons/l4d2/sniper_military/gunfire/sniper_military_fire_1.mp3"
            wepent.L4D2Data.RateOfFire = fireRateTbl
            wepent.L4D2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG
            wepent.L4D2Data.EjectShell = "RifleShellEject"
            wepent.L4D2Data.DeploySound = "lambdaplayers/weapons/l4d2/sniper_military/gunother/sniper_military_deploy_1.mp3"

            LAMBDA_L4D2:InitializeWeapon( self, wepent )
        end,

        callback = function( self, wepent, target )
            LAMBDA_L4D2:FireWeapon( self, wepent, target )
            return true
        end
    }
} )