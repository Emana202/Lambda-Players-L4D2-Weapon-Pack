local fireDamageTbl = { 24, 26 }
local fireRateTbl = { 0.35, 0.5 }
local deploySnds = {
    { 0, "lambdaplayers/weapons/l4d2/sniper_mini14/gunother/hunting_rifle_deploy_1.mp3" },
    { 0.56, "lambdaplayers/weapons/l4d2/sniper_mini14/gunother/hunting_rifle_boltback.mp3" },
    { 0.8, "lambdaplayers/weapons/l4d2/sniper_mini14/gunother/hunting_rifle_boltforward.mp3" }
}

table.Merge( _LAMBDAPLAYERSWEAPONS, {
    l4d2_sniper_mini14 = {
        model = "models/lambdaplayers/weapons/l4d2/w_sniper_mini14.mdl",
        origin = "Left 4 Dead 2",
        prettyname = "Hunting Rifle",
        holdtype = "ar2",
        killicon = "lambdaplayers/killicons/icon_l4d2_sniper_mini14",
        bonemerge = true,

        clip = 15,
        islethal = true,
        attackrange = 2500,
        keepdistance = 1000,

        reloadtime = 3.125,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        reloadanimspeed = 0.7,
        reloadsounds = { 
            { 0.9375, "lambdaplayers/weapons/l4d2/sniper_mini14/gunother/hunting_rifle_clipout.mp3" },
            { 1.9375, "lambdaplayers/weapons/l4d2/sniper_mini14/gunother/hunting_rifle_clipin.mp3" },
            { 2.5, "lambdaplayers/weapons/l4d2/sniper_mini14/gunother/hunting_rifle_cliplocked.mp3" }
        },

        OnDeploy = function( self, wepent )
            wepent.L4D2Data = {}
            wepent.L4D2Data.Damage = fireDamageTbl
            wepent.L4D2Data.Spread = 0.066
            wepent.L4D2Data.Sound = "lambdaplayers/weapons/l4d2/sniper_mini14/gunfire/hunting_rifle_fire_1.mp3"
            wepent.L4D2Data.RateOfFire = fireRateTbl
            wepent.L4D2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG
            wepent.L4D2Data.EjectShell = "RifleShellEject"
            wepent.L4D2Data.DeploySound = deploySnds

            LAMBDA_L4D2:InitializeWeapon( self, wepent )
        end,

        OnAttack = function( self, wepent, target )
            LAMBDA_L4D2:FireWeapon( self, wepent, target )
            return true
        end
    }
} )