local fireDamageTbl = { 30, 34 }
local fireRateTbl = { 0.35, 0.5 }
local deploySnds = {
    { 0, "lambdaplayers/weapons/l4d2/pistol_magnum/gunother/pistol_deploy_1.mp3" },
    { 0.25, "lambdaplayers/weapons/l4d2/pistol_magnum/gunother/pistol_slideback_1.mp3" },
    { 0.45, "lambdaplayers/weapons/l4d2/pistol_magnum/gunother/pistol_slideforward_1.mp3" }
}

table.Merge( _LAMBDAPLAYERSWEAPONS, {
    l4d2_pistol_magnum = {
        model = "models/lambdaplayers/weapons/l4d2/w_pistol_magnum.mdl",
        origin = "Left 4 Dead 2",
        prettyname = "Magnum",
        holdtype = "revolver",
        killicon = "lambdaplayers/killicons/icon_l4d2_pistol_magnum",
        bonemerge = true,
        
        clip = 8,
        islethal = true,
        attackrange = 1500,
        keepdistance = 700,

        reloadtime = 2.0,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        reloadanimspeed = 1,
        reloadsounds = { 
            { 0.366, "lambdaplayers/weapons/l4d2/pistol_magnum/gunother/pistol_clip_out_1.mp3" },
            { 1.0, "lambdaplayers/weapons/l4d2/pistol_magnum/gunother/pistol_clip_in_1.mp3" },
            { 1.2, "lambdaplayers/weapons/l4d2/pistol_magnum/gunother/pistol_clip_locked_1.mp3" },
            { 1.533, "lambdaplayers/weapons/l4d2/pistol_magnum/gunother/pistol_slideforward_1.mp3" }
        },

        OnDeploy = function( self, wepent )
            wepent.L4D2Data = {}
            wepent.L4D2Data.Damage = fireDamageTbl
            wepent.L4D2Data.Spread = 0.075
            wepent.L4D2Data.Sound = "lambdaplayers/weapons/l4d2/pistol_magnum/gunfire/magnum_shoot.mp3"
            wepent.L4D2Data.RateOfFire = fireRateTbl
            wepent.L4D2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER
            wepent.L4D2Data.DeploySound = deploySnds

            LAMBDA_L4D2:InitializeWeapon( self, wepent )
        end,

        OnAttack = function( self, wepent, target )
            LAMBDA_L4D2:FireWeapon( self, wepent, target )
            return true
        end
    }
} )