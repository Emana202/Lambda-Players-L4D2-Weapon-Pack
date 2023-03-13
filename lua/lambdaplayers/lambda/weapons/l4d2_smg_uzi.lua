local fireDamageTbl = { 6, 8 }
local deploySnds = {
    { 0, "lambdaplayers/weapons/l4d2/smg_uzi/gunother/smg_deploy_1.mp3" },
    { 0.33, "lambdaplayers/weapons/l4d2/smg_uzi/gunother/smg_slideback_1.mp3" },
    { 0.733, "lambdaplayers/weapons/l4d2/smg_uzi/gunother/smg_slideforward_1.mp3" }
}

table.Merge( _LAMBDAPLAYERSWEAPONS, {
    l4d2_smg_uzi = {
        model = "models/lambdaplayers/weapons/l4d2/w_smg_uzi.mdl",
        origin = "Left 4 Dead 2",
        prettyname = "SMG",
        holdtype = "pistol",
        killicon = "lambdaplayers/killicons/icon_l4d2_smg_uzi",
        bonemerge = true,

        clip = 50,
        islethal = true,
        attackrange = 1500,
        keepdistance = 600,

        reloadtime = 2.233,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        reloadanimspeed = 0.66,
        reloadsounds = { 
            { 0.55, "lambdaplayers/weapons/l4d2/smg_uzi/gunother/smg_clip_out_1.mp3" },
            { 0.88, "lambdaplayers/weapons/l4d2/smg_uzi/gunother/smg_clip_in_1.mp3" },
            { 1.0, "lambdaplayers/weapons/l4d2/smg_uzi/gunother/smg_clip_locked_1.mp3" },
            { 1.61, "lambdaplayers/weapons/l4d2/smg_uzi/gunother/smg_slideback_1.mp3" },
            { 1.76, "lambdaplayers/weapons/l4d2/smg_uzi/gunother/smg_slideforward_1.mp3" }
        },

        OnDeploy = function( self, wepent )
            wepent.L4D2Data = {}
            wepent.L4D2Data.Damage = fireDamageTbl
            wepent.L4D2Data.Spread = 0.1
            wepent.L4D2Data.Sound = "lambdaplayers/weapons/l4d2/smg_uzi/gunfire/smg_fire_1.mp3"
            wepent.L4D2Data.RateOfFire = 0.0625
            wepent.L4D2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
            wepent.L4D2Data.DeploySound = deploySnds

            LAMBDA_L4D2:InitializeWeapon( self, wepent )
        end,

        OnAttack = function( self, wepent, target )
            LAMBDA_L4D2:FireWeapon( self, wepent, target )
            return true
        end
    }
} )