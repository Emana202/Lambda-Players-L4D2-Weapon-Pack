local fireDamageTbl = { 11, 13 }
local fireRateTbl = { 0.21, 0.35 }
local deploySnds = {
    { 0, "lambdaplayers/weapons/l4d2/rifle_desert/gunother/rifle_deploy_1.mp3" },
    { 0.4, "lambdaplayers/weapons/l4d2/rifle_desert/gunother/rifle_slideback_1.mp3" },
    { 0.733, "lambdaplayers/weapons/l4d2/rifle_desert/gunother/rifle_slideforward_1.mp3" }
}

table.Merge( _LAMBDAPLAYERSWEAPONS, {
    l4d2_rifle_desert = {
        model = "models/lambdaplayers/weapons/l4d2/w_rifle_desert.mdl",
        origin = "Left 4 Dead 2",
        prettyname = "Desert Rifle",
        holdtype = "ar2",
        killicon = "lambdaplayers/killicons/icon_l4d2_rifle_desert",
        bonemerge = true,

        clip = 60,
        islethal = true,
        attackrange = 1750,
        keepdistance = 800,

        reloadtime = 3.33,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        reloadanimspeed = 0.66,
        reloadsounds = { 
            { 0.566, "lambdaplayers/weapons/l4d2/rifle_desert/gunother/rifle_slideback_1.mp3" },
            { 1.233, "lambdaplayers/weapons/l4d2/rifle_desert/gunother/rifle_clip_out_1.mp3" },
            { 1.566, "lambdaplayers/weapons/l4d2/rifle_desert/gunother/rifle_clip_in_1.mp3" },
            { 1.8, "lambdaplayers/weapons/l4d2/rifle_desert/gunother/rifle_clip_locked_1.mp3" },
            { 2.533, "lambdaplayers/weapons/l4d2/rifle_desert/gunother/rifle_slideforward_1.mp3" }
        },

        OnDeploy = function( self, wepent )
            wepent.L4D2Data = {}
            wepent.L4D2Data.Damage = fireDamageTbl
            wepent.L4D2Data.Spread = 0.08
            wepent.L4D2Data.Sound = "lambdaplayers/weapons/l4d2/rifle_desert/gunfire/rifle_fire_1.mp3"
            wepent.L4D2Data.RateOfFire = fireRateTbl
            wepent.L4D2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
            wepent.L4D2Data.EjectShell = "RifleShellEject"
            wepent.L4D2Data.DeploySound = deploySnds

            LAMBDA_L4D2:InitializeWeapon( self, wepent )
        end,

        OnAttack = function( self, wepent, target )
            if LAMBDA_L4D2:FireWeapon( self, wepent, target ) != true then
                self:NamedTimer( "DesertRifle_BurstFire", 0.07, 2, function() LAMBDA_L4D2:FireWeapon( self, wepent, target ) end )
            end
            return true
        end
    }
} )