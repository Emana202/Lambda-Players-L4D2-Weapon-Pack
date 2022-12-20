local fireDamageTbl = { 13, 15 }
local deploySnds = {
    { 0, "lambdaplayers/weapons/l4d2/rifle_m16a2/gunother/rifle_deploy_1.mp3" },
    { 0.35, "lambdaplayers/weapons/l4d2/rifle_m16a2/gunother/rifle_slideback_1.mp3" },
    { 0.66, "lambdaplayers/weapons/l4d2/rifle_m16a2/gunother/rifle_slideforward_1.mp3" }
}

table.Merge( _LAMBDAPLAYERSWEAPONS, {
    l4d2_rifle_m16a2 = {
        model = "models/lambdaplayers/weapons/l4d2/w_rifle_m16a2.mdl",
        origin = "Left 4 Dead 2",
        prettyname = "Assault Rifle",
        holdtype = "ar2",
        killicon = "lambdaplayers/killicons/icon_l4d2_rifle_m16a2",
        bonemerge = true,

        clip = 50,
        islethal = true,
        attackrange = 1500,
        keepdistance = 550,

        reloadtime = 2.2,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        reloadanimspeed = 1,
        reloadsounds = { 
            { 0.533, "lambdaplayers/weapons/l4d2/rifle_m16a2/gunother/rifle_clip_out_1.mp3" },
            { 0.866, "lambdaplayers/weapons/l4d2/rifle_m16a2/gunother/rifle_clip_in_1.mp3" },
            { 1.1, "lambdaplayers/weapons/l4d2/rifle_m16a2/gunother/rifle_clip_locked_1.mp3" },
            { 1.66, "lambdaplayers/weapons/l4d2/rifle_m16a2/gunother/rifle_fullautobutton_1.mp3" }
        },

        OnEquip = function( self, wepent )
            wepent.L4D2Data = {}
            wepent.L4D2Data.Damage = fireDamageTbl
            wepent.L4D2Data.Spread = 0.1
            wepent.L4D2Data.Sound = "lambdaplayers/weapons/l4d2/rifle_m16a2/gunfire/rifle_fire_1.mp3"
            wepent.L4D2Data.RateOfFire = 0.0875
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